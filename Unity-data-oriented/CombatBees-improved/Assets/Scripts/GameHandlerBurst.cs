using UnityEngine;

public class GameHandlerBurst : MonoBehaviour
{
    public Mesh beeMesh;
    public Material beeMaterial;
    public Color[] teamColors;
    MaterialPropertyBlock props;

    // Mesh Properties struct to be read from the GPU.
    // Size() is a convenience funciton which returns the stride of the struct.
    private struct MeshProperties
    {
        public Matrix4x4 mat;
        public Vector4 color;

        public static int Size()
        {
            return
                sizeof(float) * 4 * 4 + // matrix;
                sizeof(float) * 4;      // color;
        }
    }

    private void Start()
    {
        props = new MaterialPropertyBlock();
        DataBurst.Init();
    }

    private void Update()
    {
        float deltaTime = Time.deltaTime;
        deltaTime = Mathf.Min(deltaTime, 0.033f);
        SpawnBeesSystemBurst.Run();
        BeeMovementSystemBurst.Run(deltaTime);
        BeePositionUpdateSystemBurst.Run(deltaTime);
        EnemyTargetSystemBurst.Run();
        AttackSystemBurst.Run(deltaTime);
        DeadBeesSystemBurst.Run(deltaTime);
        BeeWallCollisionSystemBurst.Run();
        RenderSystemBurst.Run(beeMesh, beeMaterial, props, teamColors);

#if DEBUG && UNITY_EDITOR
        StateChecker.Run();
#endif

    }

}