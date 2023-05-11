using Unity.Entities;
using Unity.Mathematics;

public struct Targets : IComponentData
{
    public float3 AllyTarget;
    public float3 EnemyTarget;
}