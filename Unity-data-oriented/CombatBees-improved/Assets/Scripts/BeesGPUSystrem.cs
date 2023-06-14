using System;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using Unity.Collections;
using Unity.Entities;
using UnityEngine;
using UnityEngine.Rendering;

public class BeesGPUSystrem : MonoBehaviour
{
    [Header("Bee Settings")]
    public BeesConstantData initData = new BeesConstantData(Color.red, Color.blue);

    [Header("Others")] 
    public Mesh beeMesh;
    public Material beesMaterial;
    public ComputeShader beesBehaviourComputeShader;

    public static BeesGPUSystrem instance;

    [GenerateHLSL(needAccessors = false, generateCBuffer = true), StructLayout(LayoutKind.Sequential), Serializable]
    public struct BeesConstantData
    {
        public Color team0Color;
        public Color team1Color;

        public float minBeeSize;
        public float maxBeeSize;
        [Space(10)]
        [Range(0f, 1f)]
        public float aggression;
        public float flightJitter;

        public float teamAttraction;
        public float teamRepulsion;
        [Range(0f, 1f)]
        public float damping;
        public float chaseForce;

        public float carryForce;
        public float grabDistance;
        public float attackDistance;
        public float attackForce;

        public float hitDistance;
        [Space(10)]
        public int startBeeCount;
        // Padding to align to 16 bytes, needed for several platforms using constant buffers
        [HideInInspector]
        public float _padding1;
        [HideInInspector]
        public float _padding2;

        public BeesConstantData(Color team0Color, Color team1Color)
        {
            this.team0Color = team0Color;
            this.team1Color = team1Color;
            minBeeSize = 0.25f;
            maxBeeSize = 0.5f;
            aggression = 1;
            flightJitter = 200;
            teamAttraction = 5;
            teamRepulsion = 4;
            damping = 0.9f;
            chaseForce = 50;
            carryForce = 0;
            grabDistance = 0;
            attackDistance = 4;
            attackForce = 500;
            hitDistance = 0.5f;
            startBeeCount = 512;
            _padding1 = 0;
            _padding2 = 0;
        } 
    }

    [GenerateHLSL(needAccessors = false), StructLayout(LayoutKind.Sequential)]
    struct BeeData
    {
        // We can use half to improve bandwidth read on GPU as there is not much computation going on
        // TODO: reorder and split data to maximize bandwidth read
        public Vector3 position;
        public int teamIndex;
        public Vector3 velocity;
        // TODO: pack data better depending on what takes time on GPU (do a bit of profiling)
        public int isAttacking;
        public int isHoldingResource;
        public int enemyTargetIndex;
    }

    GraphicsBuffer beesConstantBuffer;
    readonly int beesConstantBufferSize = Marshal.SizeOf(typeof(BeesConstantData));
    CommandBuffer updateBeesCommandBuffer;
    GraphicsBuffer runtimeBeesBuffer;
    GraphicsBuffer deadBeesBuffer;

    // Buffers for rendering the bees (indirect indexed rendering)
    GraphicsBuffer beesIndirectArgumentBuffer;
    MaterialPropertyBlock beesPropertyBlock; 

    uint threadGroupSizeX;
    uint threadGroupSizeY;
    int csKernelIndex;
 
    void Start()
    {
        instance = this;

        // Disable entities in this scene as we don't need them
        World.DefaultGameObjectInjectionWorld.DestroyAllSystemsAndLogException();
        // Also disable URP as the C# side of the engine is pretty slow for rendering this particular scene.
        GraphicsSettings.renderPipelineAsset = null;
 
        beesConstantBuffer = new GraphicsBuffer(GraphicsBuffer.Target.Constant, 1, beesConstantBufferSize);
        updateBeesCommandBuffer = new CommandBuffer{ name = "Update Bees"};
        beesIndirectArgumentBuffer = new GraphicsBuffer(GraphicsBuffer.Target.IndirectArguments, 1, GraphicsBuffer.IndirectDrawIndexedArgs.size);
        runtimeBeesBuffer = new GraphicsBuffer(GraphicsBuffer.Target.Structured, initData.startBeeCount, Marshal.SizeOf(typeof(BeeData)));
        deadBeesBuffer = new GraphicsBuffer(GraphicsBuffer.Target.Structured, initData.startBeeCount, sizeof(float));
        beesPropertyBlock = new();

        // Upload CBuffer data once
        beesConstantBuffer.SetData(new []{ initData });

        var indirectDrawArgs = new GraphicsBuffer.IndirectDrawIndexedArgs
        {
            indexCountPerInstance = 6,
            baseVertexIndex = 0,
            startIndex = 0,
            instanceCount = Math.Clamp((uint)initData.startBeeCount, 1, 100000000), // failsafe to avoid crashing your GPU
        };
        beesIndirectArgumentBuffer.SetData(new []{ indirectDrawArgs });

        csKernelIndex = beesBehaviourComputeShader.FindKernel("BehaviourUpdate");
        beesBehaviourComputeShader.GetKernelThreadGroupSizes(csKernelIndex, out threadGroupSizeX, out threadGroupSizeY, out _);

        // Init bees data with 2 teams:
        // TODO: move this to GPU init kernel
        NativeArray<BeeData> beesData = new NativeArray<BeeData>(initData.startBeeCount, Allocator.Temp);
        NativeArray<float> deadList = new NativeArray<float>(initData.startBeeCount, Allocator.Temp);
        for (int i = 0; i < initData.startBeeCount; i++)
        {
            int teamIndex = i < initData.startBeeCount / 2 ? 0 : 1;
            beesData[i] = new BeeData
            {
                position = Vector3.right * (-Field.size.x * .4f + Field.size.x * .8f * teamIndex),
                teamIndex = teamIndex,
                velocity = Vector3.zero,
                isAttacking = 0,
                isHoldingResource = 0,
                enemyTargetIndex = -1,
            };
        }
        runtimeBeesBuffer.SetData(beesData);
        deadBeesBuffer.SetData(deadList);
        beesData.Dispose();
        deadList.Dispose();
    }

    void Destroy()
    {
        beesConstantBuffer?.Dispose();
        updateBeesCommandBuffer?.Dispose();
        beesIndirectArgumentBuffer?.Dispose();
        runtimeBeesBuffer?.Dispose();
        deadBeesBuffer?.Dispose();
    }

    void Update()
    {
        // Update bees behavior for the frame
        updateBeesCommandBuffer.Clear();
        updateBeesCommandBuffer.SetGlobalFloat("_UpdateTime", Time.time);
        updateBeesCommandBuffer.SetGlobalFloat("_DeltaTime", Time.deltaTime);
        updateBeesCommandBuffer.SetGlobalFloat("_FieldGravity", Field.gravity);
        // updateBeesCommandBuffer.SetGlobalFloat("_ResourceSize", ResourceManager.instance.resourceSize);
        updateBeesCommandBuffer.SetGlobalVector("_FieldSize", Field.size);
        updateBeesCommandBuffer.SetComputeBufferParam(beesBehaviourComputeShader, csKernelIndex, "_Bees", runtimeBeesBuffer);
        updateBeesCommandBuffer.SetComputeBufferParam(beesBehaviourComputeShader, csKernelIndex, "_DeadBees", deadBeesBuffer);
        updateBeesCommandBuffer.SetComputeConstantBufferParam(beesBehaviourComputeShader, "BeesConstantData", beesConstantBuffer, 0, beesConstantBufferSize);
        DispatchCompute(initData.startBeeCount); 
        Graphics.ExecuteCommandBuffer(updateBeesCommandBuffer);

        // Register rendering call to URP camera rendering
        RenderParams rp = new RenderParams(beesMaterial);
        rp.worldBounds = new Bounds(Vector3.zero, 10000 * Vector3.one);
        beesPropertyBlock.SetBuffer("_Bees", runtimeBeesBuffer); 
        beesPropertyBlock.SetConstantBuffer("BeesConstantData", beesConstantBuffer, 0, beesConstantBufferSize); 
        rp.matProps = beesPropertyBlock;
        Graphics.RenderMeshIndirect(rp, beeMesh, beesIndirectArgumentBuffer, 1);
    }

    // Helper to do a 2D dispatch and bypass the 65k thread limit on X axis
    void DispatchCompute(int threadCount)
    {
        // Try to fit thread count on an optimal square to minimize wasted threads (above startBeeCount) 
        int maxThreadGroupX = Mathf.Min(1024, Mathf.NextPowerOfTwo(Mathf.CeilToInt(Mathf.Sqrt(threadCount / 8f))));
        int threadGroupCountX = Mathf.Clamp(threadCount / (int)threadGroupSizeX, 1, maxThreadGroupX);
        int threadGroupCountY = Mathf.Max(1, threadCount / (int)(threadGroupCountX * threadGroupSizeX));
        updateBeesCommandBuffer.SetComputeIntParam(beesBehaviourComputeShader, "_DispatchSizeX", threadGroupCountX);
        updateBeesCommandBuffer.DispatchCompute(beesBehaviourComputeShader, csKernelIndex, threadGroupCountX, threadGroupCountY, 1);
    }
}
