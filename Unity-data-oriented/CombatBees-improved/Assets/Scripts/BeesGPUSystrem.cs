using System;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using Unity.Collections;
using Unity.Entities;
using Unity.Mathematics;
using UnityEngine;
using UnityEngine.Rendering;

public class BeesGPUSystrem : MonoBehaviour
{
    [Header("Bee Settings")]
    public BeesConstantData initData = new BeesConstantData(Color.red, Color.blue);

    [Header("Others")] 
    public Mesh beeMesh;
    public Material beesMaterial;
    public Material beesURPMaterial;
    public ComputeShader beesBehaviourComputeShader;
    public bool disableURP = true;

    public static BeesGPUSystrem instance;

    // All constants are uploaded on the GPU using a constant buffer (fast access compared to regular buffers)
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

        [HideInInspector]
        public Vector3 team0SpawnPosition;
        public float hitDistance;

        [HideInInspector]
        public Vector3 team1SpawnPosition;
        [Space(10)]
        public int startBeeCount;

        public float deadTimeout;
        // Padding to align to 16 bytes, needed for several platforms using constant buffers
        [HideInInspector]
        public float _padding0;
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
            deadTimeout = 2;
            _padding0 = 0;
            _padding1 = 0;
            _padding2 = 0;
            team0SpawnPosition = Vector3.zero;
            team1SpawnPosition = Vector3.zero;
        } 
    }

    // 16 bytes of data per bee, good to cache utilization on GPU
    [GenerateHLSL(needAccessors = false), StructLayout(LayoutKind.Sequential)]
    struct PackedBeeData
    {
        // We can use half to improve bandwidth read on GPU as there is not much computation going on
        public uint4 packedBeeData; 
    }

    [GenerateHLSL(needAccessors = false), StructLayout(LayoutKind.Sequential)]
    struct BeeData
    {
        // We can use half to improve bandwidth read on GPU as there is not much computation going on
        public Vector3 position; 
        public Vector3 velocity; 
        public uint isAttacking; 
        public uint teamIndex; 
        public uint enemyTargetIndex; 
    }

    GraphicsBuffer beesConstantBuffer;
    readonly int beesConstantBufferSize = Marshal.SizeOf(typeof(BeesConstantData));
    CommandBuffer updateBeesCommandBuffer;
    GraphicsBuffer runtimeBeesBuffer;
    // Separate dead bee buffer because they can kill each other
    GraphicsBuffer deadBeesBuffer;

    // Buffers for rendering the bees (indirect indexed rendering)
    GraphicsBuffer beesIndirectArgumentBuffer;
    MaterialPropertyBlock beesPropertyBlock; 

    uint threadGroupSizeX;
    uint threadGroupSizeY;
    int behaviourUpdateKernel;
    int initKernel;

    Mesh team0BeeMesh;
    Mesh team1BeeMesh;
 
    void Start()
    {
        instance = this;

        // Disable entities in this scene as we don't need them
        World.DefaultGameObjectInjectionWorld.DestroyAllSystemsAndLogException();
        // Also disable URP as the C# side of the engine is pretty slow for rendering this particular scene.
        if (disableURP)
            GraphicsSettings.renderPipelineAsset = null;

        // odd number of bees is not supported
        if (initData.startBeeCount % 2 != 0)
            initData.startBeeCount += 1;
 
        updateBeesCommandBuffer = new CommandBuffer{ name = "Update Bees"};
        beesConstantBuffer = new GraphicsBuffer(GraphicsBuffer.Target.Constant, 1, beesConstantBufferSize) { name = "Bees Constant" };
        beesIndirectArgumentBuffer = new GraphicsBuffer(GraphicsBuffer.Target.IndirectArguments, 2, GraphicsBuffer.IndirectDrawIndexedArgs.size) { name = "Bees Indirect Draw Args" };
        runtimeBeesBuffer = new GraphicsBuffer(GraphicsBuffer.Target.Structured, initData.startBeeCount, Marshal.SizeOf(typeof(BeeData))) { name = "Bees Data" };
        deadBeesBuffer = new GraphicsBuffer(GraphicsBuffer.Target.Structured, initData.startBeeCount, sizeof(float)) { name = "Dead Bees" };
        beesPropertyBlock = new();

        // Upload CBuffer data once
        initData.team0SpawnPosition = GetTeamSpawnPos(0);
        initData.team1SpawnPosition = GetTeamSpawnPos(1);
        beesConstantBuffer.SetData(new []{ initData });

        uint halfInstanceCount = Math.Clamp((uint)initData.startBeeCount / 2, 1, 100000000); // failsafe to avoid crashing your GPU
        var team0IndirectArgs = new GraphicsBuffer.IndirectDrawIndexedArgs
        {
            indexCountPerInstance = 6,
            instanceCount = halfInstanceCount,
        };
        var team1IndirectArgs = new GraphicsBuffer.IndirectDrawIndexedArgs
        {
            indexCountPerInstance = 6,
            instanceCount = halfInstanceCount,
            startInstance = halfInstanceCount, 
        };
        beesIndirectArgumentBuffer.SetData(new []{ team0IndirectArgs, team1IndirectArgs });

        behaviourUpdateKernel = beesBehaviourComputeShader.FindKernel("BehaviourUpdate");
        initKernel = beesBehaviourComputeShader.FindKernel("InitBeeData");
        beesBehaviourComputeShader.GetKernelThreadGroupSizes(behaviourUpdateKernel, out threadGroupSizeX, out threadGroupSizeY, out _);

        // Init bees data with 2 teams:
        updateBeesCommandBuffer.SetComputeBufferParam(beesBehaviourComputeShader, initKernel, "_Bees", runtimeBeesBuffer);
        updateBeesCommandBuffer.SetComputeBufferParam(beesBehaviourComputeShader,initKernel, "_DeadBees", deadBeesBuffer);
        updateBeesCommandBuffer.SetComputeConstantBufferParam(beesBehaviourComputeShader, "BeesConstantData", beesConstantBuffer, 0, beesConstantBufferSize);
        DispatchCompute(initData.startBeeCount, initKernel);
        Graphics.ExecuteCommandBuffer(updateBeesCommandBuffer);

        // Prepare meshes for rendering:
        team0BeeMesh = CreateBeeMesh(initData.team0Color);
        team1BeeMesh = CreateBeeMesh(initData.team1Color);
    }

    // 12 bytes vertex data
    struct MeshVertexData
    {
        public half4 position;
        public Color32 color;
    }

    Mesh CreateBeeMesh(Color color)
    {
        var m = new Mesh{ indexFormat = IndexFormat.UInt16 }; 

        // Build a mesh with better data layout than the default unity one (faster for the attribute fetcher)
        var meshLayout = new []{ new VertexAttributeDescriptor(VertexAttribute.Position, VertexAttributeFormat.Float16, 4), new VertexAttributeDescriptor(VertexAttribute.Color, VertexAttributeFormat.UNorm8, 4) };
        int vertexCount = beeMesh.vertices.Length;
        m.SetVertexBufferParams(vertexCount, meshLayout);
        m.SetIndices(beeMesh.GetIndices(0), MeshTopology.Triangles, 0, false);
        var vertices = new MeshVertexData[vertexCount]; 
        for (int i = 0; i < vertexCount; i++)
        {
            vertices[i] = new MeshVertexData
            {
                position = new half4((Vector4)beeMesh.vertices[i]),
                color = color,
            };
        }
        m.SetVertexBufferData(vertices, 0, 0, vertexCount);
        return m;
    }

    Vector3 GetTeamSpawnPos(int teamIndex)
    {
        return Vector3.right * (-Field.size.x * .4f + Field.size.x * .8f * teamIndex);
    }

    void Destroy()
    {
        beesConstantBuffer?.Dispose();
        updateBeesCommandBuffer?.Dispose();
        beesIndirectArgumentBuffer?.Dispose();
        runtimeBeesBuffer?.Dispose();
        deadBeesBuffer?.Dispose();
        CoreUtils.Destroy(team0BeeMesh);
        CoreUtils.Destroy(team1BeeMesh);
    }

    void Update()
    {
        // Update bees behavior for the frame
        updateBeesCommandBuffer.Clear();
        updateBeesCommandBuffer.SetGlobalFloat("_UpdateTime", Time.time);
        updateBeesCommandBuffer.SetGlobalFloat("_DeltaTime", Time.deltaTime);
        updateBeesCommandBuffer.SetGlobalFloat("_FieldGravity", Field.gravity);
        updateBeesCommandBuffer.SetGlobalVector("_FieldSize", Field.size);
        updateBeesCommandBuffer.SetComputeBufferParam(beesBehaviourComputeShader, behaviourUpdateKernel, "_Bees", runtimeBeesBuffer);
        updateBeesCommandBuffer.SetComputeBufferParam(beesBehaviourComputeShader, behaviourUpdateKernel, "_DeadBees", deadBeesBuffer);
        updateBeesCommandBuffer.SetComputeConstantBufferParam(beesBehaviourComputeShader, "BeesConstantData", beesConstantBuffer, 0, beesConstantBufferSize);
        DispatchCompute(initData.startBeeCount, behaviourUpdateKernel); 
        Graphics.ExecuteCommandBuffer(updateBeesCommandBuffer);

        // Register rendering call to camera rendering using Graphics API (deferred call)
        beesPropertyBlock.SetBuffer("_Bees", runtimeBeesBuffer); 
        beesPropertyBlock.SetConstantBuffer("BeesConstantData", beesConstantBuffer, 0, beesConstantBufferSize); 
        beesPropertyBlock.SetInteger("_StartInstance", 0); 

        RenderParams rp = new RenderParams(disableURP ? beesMaterial : beesURPMaterial);
        rp.worldBounds = new Bounds(Vector3.zero, 10000 * Vector3.one);
        rp.matProps = beesPropertyBlock;
        Graphics.RenderMeshIndirect(rp, team0BeeMesh, beesIndirectArgumentBuffer, 1, 0);
        beesPropertyBlock.SetInteger("_StartInstance", initData.startBeeCount / 2); 
        Graphics.RenderMeshIndirect(rp, team1BeeMesh, beesIndirectArgumentBuffer, 1, 1);
    }

    // Helper to do a 2D dispatch and bypass the 65k thread limit on X axis
    void DispatchCompute(int threadCount, int kernelIndex)
    {
        // Try to fit thread count on an optimal square to minimize wasted threads (above startBeeCount) 
        int maxThreadGroupX = Mathf.Min(1024, Mathf.NextPowerOfTwo(Mathf.CeilToInt(Mathf.Sqrt(threadCount / 8f))));
        int threadGroupCountX = Mathf.Clamp(threadCount / (int)threadGroupSizeX, 1, maxThreadGroupX);
        int threadGroupCountY = Mathf.Max(1, threadCount / (int)(threadGroupCountX * threadGroupSizeX));
        updateBeesCommandBuffer.SetComputeIntParam(beesBehaviourComputeShader, "_DispatchSizeX", threadGroupCountX);
        updateBeesCommandBuffer.DispatchCompute(beesBehaviourComputeShader, kernelIndex, threadGroupCountX, threadGroupCountY, 1);
    }
}
