using Unity.Entities;

public struct Team : ISharedComponentData
{
    public int Value;
    public static implicit operator Team(int value) => new Team { Value = value };
    public static implicit operator int(Team team) => team.Value;
}
