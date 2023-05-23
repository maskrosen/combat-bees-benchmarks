using Unity.Entities;
using Unity.Transforms;
using Unity.Burst;
using Unity.Core;

[BurstCompile]
public partial struct BeeSpawnSystem : ISystem
{
    private EntityQuery team1Alive;
    private EntityQuery team2Alive;
    private EntityQuery team1Dead;
    private EntityQuery team2Dead;

    public void OnCreate(ref SystemState state)
    {

        team1Alive = state.EntityManager.CreateEntityQuery(typeof(Team), typeof(Alive));
        team1Alive.AddSharedComponentFilter<Team>(1);
        team2Alive = state.EntityManager.CreateEntityQuery(typeof(Team), typeof(Alive));
        team2Alive.AddSharedComponentFilter<Team>(2);
        team1Dead = state.EntityManager.CreateEntityQuery(typeof(Team), typeof(Dead));
        team1Dead.AddSharedComponentFilter<Team>(1);
        team2Dead = state.EntityManager.CreateEntityQuery(typeof(Team), typeof(Dead));
        team2Dead.AddSharedComponentFilter<Team>(2);
    }

    public void OnDestroy(ref SystemState state) { }

    [BurstCompile]
    public void OnUpdate(ref SystemState state)
    {
        EntityCommandBuffer.ParallelWriter ecb = GetEntityCommandBuffer(ref state);

        int team1AliveCount = team1Alive.CalculateEntityCount();
        int team1DeadCount = team1Dead.CalculateEntityCount();
        int team1BeeCount = team1AliveCount + team1DeadCount;


        int team2AliveCount = team2Alive.CalculateEntityCount();
        int team2DeadCount = team2Dead.CalculateEntityCount();
        int team2BeeCount = team2AliveCount + team2DeadCount;

        // Creates a new instance of the job, assigns the necessary data, and schedules the job in parallel.
        new ProcessSpawnerJob
        {
            Ecb = ecb,
            team1BeeCount = team1BeeCount,
            team2BeeCount = team2BeeCount,
            timeData = state.WorldUnmanaged.Time

        }.ScheduleParallel();
    }

    private EntityCommandBuffer.ParallelWriter GetEntityCommandBuffer(ref SystemState state)
    {
        var ecbSingleton = SystemAPI.GetSingleton<BeginSimulationEntityCommandBufferSystem.Singleton>();
        var ecb = ecbSingleton.CreateCommandBuffer(state.WorldUnmanaged);
        return ecb.AsParallelWriter();
    }


    [BurstCompile]
    public partial struct ProcessSpawnerJob : IJobEntity
    {
        public EntityCommandBuffer.ParallelWriter Ecb;
        public int team1BeeCount;
        public int team2BeeCount;
        public TimeData timeData;

        // IJobEntity generates a component data query based on the parameters of its `Execute` method.
        // This example queries for all Spawner components and uses `ref` to specify that the operation
        // requires read and write access. Unity processes `Execute` for each entity that matches the
        // component data query.
        private void Execute([ChunkIndexInQuery] int chunkIndex, ref Spawner spawner)
        {

            int beesToSpawnTeam1 = Data.beeStartCount / 2 - team1BeeCount;

            for (int i = 0; i < beesToSpawnTeam1; i++)
            {
                Entity newEntity = Ecb.Instantiate(chunkIndex, spawner.BlueBee);
                var rand = new RandomComponent();
                rand.generator.InitState((uint)((i + 1) * (timeData.ElapsedTime + 1.0) * 57131));
                var transform = LocalTransform.FromPosition(spawner.Team1SpawnPosition);
                transform.Scale = rand.generator.NextFloat(Data.minBeeSize, Data.maxBeeSize);
                Ecb.SetComponent(chunkIndex, newEntity, transform);
                Ecb.AddComponent(chunkIndex, newEntity, new Velocity());
                Ecb.AddComponent(chunkIndex, newEntity, new Alive());
                Ecb.AddComponent(chunkIndex, newEntity, new Target());
                Ecb.AddComponent(chunkIndex, newEntity, rand);
                Ecb.AddSharedComponent(chunkIndex, newEntity, new Team { Value = 1 });
            }


            int beesToSpawnTeam2 = Data.beeStartCount / 2 - team2BeeCount;

            for (int i = 0; i < beesToSpawnTeam2; i++)
            {
                Entity newEntity = Ecb.Instantiate(chunkIndex, spawner.YellowBee);
                var rand = new RandomComponent();
                rand.generator.InitState((uint)((i + 1) * (timeData.ElapsedTime + 1.0) * 33223));
                var transform = LocalTransform.FromPosition(spawner.Team2SpawnPosition);
                transform.Scale = rand.generator.NextFloat(Data.minBeeSize, Data.maxBeeSize);
                Ecb.SetComponent(chunkIndex, newEntity, transform);
                Ecb.AddComponent(chunkIndex, newEntity, new Velocity());
                Ecb.AddComponent(chunkIndex, newEntity, new Alive());
                Ecb.AddComponent(chunkIndex, newEntity, new Target());
                Ecb.AddComponent(chunkIndex, newEntity, rand);
                Ecb.AddSharedComponent(chunkIndex, newEntity, new Team { Value = 2 });
            }
        }
    }
}
