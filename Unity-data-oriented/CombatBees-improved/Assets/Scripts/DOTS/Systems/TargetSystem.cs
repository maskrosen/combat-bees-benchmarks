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
                        .WithAllRW<Target>()
                        .Build(ref state);
            team2Bees = new EntityQueryBuilder(Allocator.Temp)
                        .WithAllRW<RandomComponent>()
                        .WithAll<Team2, Alive>()
                        .WithAllRW<Target>()
                        .Build(ref state);
            team1Alive = state.EntityManager.CreateEntityQuery(typeof(Team1), typeof(Alive));
            team2Alive = state.EntityManager.CreateEntityQuery(typeof(Team2), typeof(Alive));
        }

        public void OnDestroy(ref SystemState state) { }

        [BurstCompile]
        public void OnUpdate(ref SystemState state)
        {
            var enemyEntities = team2Alive.ToEntityArray(Allocator.TempJob);
            //team1 job
            new TargetJob
            {
                deltaTime = state.WorldUnmanaged.Time.DeltaTime,
                enemies = enemyEntities

            }.ScheduleParallel(team1Bees, state.Dependency).Complete();
            enemyEntities.Dispose();

            enemyEntities = team1Alive.ToEntityArray(Allocator.TempJob);

            // team2 job
            new TargetJob
            {
                deltaTime = state.WorldUnmanaged.Time.DeltaTime,
                enemies = enemyEntities


            }.ScheduleParallel(team2Bees, state.Dependency).Complete();
            enemyEntities.Dispose();
        }


        [BurstCompile]
        public partial struct TargetJob : IJobEntity
        {
            public float deltaTime;
            [ReadOnly]public NativeArray<Entity> enemies;

            private void Execute(Entity e, [ChunkIndexInQuery] int chunkIndex, ref RandomComponent random, ref Target target)
            {
                if (target.enemyTarget == Entity.Null)
                {
                    int newTarget = random.generator.NextInt(0, enemies.Length);
                    target.enemyTarget = enemies[newTarget];
                }
            }
        }

    }
}
