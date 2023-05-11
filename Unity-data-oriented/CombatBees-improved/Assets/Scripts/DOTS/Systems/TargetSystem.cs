using Unity.Entities;
using Unity.Transforms;
using Unity.Burst;
using UnityEngine;
using Unity.Collections;
using Unity.Mathematics;

namespace DOTS
{

    [BurstCompile]
    public partial struct TargetSystem : ISystem
    {

        private EntityQuery team1Bees;
        private EntityQuery team2Bees; 
        private EntityQuery team1Alive;
        private EntityQuery team2Alive;

        public void OnCreate(ref SystemState state)
        {
            team1Bees = new EntityQueryBuilder(Allocator.Temp)
                        .WithAllRW<RandomComponent>()
                        .WithAll<Team1, Alive>()
                        .WithAbsent<Target>()
                        .Build(ref state);
            team2Bees = new EntityQueryBuilder(Allocator.Temp)
                        .WithAllRW<RandomComponent>()
                        .WithAll<Team2, Alive>()
                        .WithAbsent<Target>()
                        .Build(ref state);
            team1Alive = state.EntityManager.CreateEntityQuery(typeof(Team1), typeof(Alive));
            team2Alive = state.EntityManager.CreateEntityQuery(typeof(Team2), typeof(Alive));
        }

        public void OnDestroy(ref SystemState state) { }

        [BurstCompile]
        public void OnUpdate(ref SystemState state)
        {
            EntityCommandBuffer.ParallelWriter ecb = GetEntityCommandBuffer(ref state);
            var enemyEntities = team2Alive.ToEntityArray(Allocator.TempJob);
            //team1 job
            new TargetJob
            {
                Ecb = ecb,
                deltaTime = state.WorldUnmanaged.Time.DeltaTime,
                enemies = enemyEntities

            }.ScheduleParallel(team1Bees, state.Dependency).Complete();
            enemyEntities.Dispose();

            enemyEntities = team1Alive.ToEntityArray(Allocator.TempJob);

            // team2 job
            new TargetJob
            {
                Ecb = ecb,
                deltaTime = state.WorldUnmanaged.Time.DeltaTime,
                enemies = enemyEntities


            }.ScheduleParallel(team2Bees, state.Dependency).Complete();
            enemyEntities.Dispose();
        }

        private EntityCommandBuffer.ParallelWriter GetEntityCommandBuffer(ref SystemState state)
        {
            var ecbSingleton = SystemAPI.GetSingleton<BeginSimulationEntityCommandBufferSystem.Singleton>();
            var ecb = ecbSingleton.CreateCommandBuffer(state.WorldUnmanaged);
            return ecb.AsParallelWriter();
        }

        [BurstCompile]
        public partial struct TargetJob : IJobEntity
        {
            public EntityCommandBuffer.ParallelWriter Ecb;
            public float deltaTime;
            [ReadOnly]public NativeArray<Entity> enemies;

            private void Execute(Entity e, [ChunkIndexInQuery] int chunkIndex, ref RandomComponent random)
            {
                int newTarget = random.generator.NextInt(0, enemies.Length);
                Target target;
                target.enemyTarget = enemies[newTarget];
                Ecb.AddComponent(chunkIndex, e, target);
            }
        }

    }
}
