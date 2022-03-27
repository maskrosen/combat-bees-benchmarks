using UnityEngine;

public class GameHandler : MonoBehaviour
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
    }

    private void Update()
    {
        float deltaTime = Time.deltaTime;
        deltaTime = Mathf.Min(deltaTime, 0.033f);
        SpawnBeesSystem.Run();
        BeeMovementSystem.Run(deltaTime);
        BeePositionUpdateSystem.Run(deltaTime);
        EnemyTargetSystem.Run();
        AttackSystem.Run(deltaTime);
        DeadBeesSystem.Run(deltaTime);
        BeeWallCollisionSystem.Run();
        RenderSystem.Run(beeMesh, beeMaterial, props, teamColors);

#if DEBUG && UNITY_EDITOR
        StateChecker.Run();
#endif

    }

}