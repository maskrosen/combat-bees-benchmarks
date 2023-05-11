using Unity.Entities;
using Unity.Mathematics;

public struct Spawner : IComponentData
{
    public Entity BlueBee;
    public Entity YellowBee;
    public float3 Team1SpawnPosition;
    public float3 Team2SpawnPosition;
}
