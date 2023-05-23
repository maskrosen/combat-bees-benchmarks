using Unity.Entities;
using Unity.Transforms;
using Unity.Burst;
using UnityEngine;
using Unity.Collections;
using Unity.Mathematics;
using Unity.Jobs;

namespace DOTS
{

    [BurstCompile]
    [UpdateBefore(typeof(AttackSystem))]
    public partial struct TargetSystem : ISystem
    {
        private EntityQuery team1Alive;
        private EntityQuery team2Alive;

        public void OnCreate(ref SystemState state)
        {
            team1Alive = state.EntityManager.CreateEntityQuery(typeof(Team), typeof(Alive));
            team1Alive.AddSharedComponentFilter<Team>(1);
            team2Alive = state.EntityManager.CreateEntityQuery(typeof(Team), typeof(Alive));
            team2Alive.AddSharedComponentFilter<Team>(2);
        }

        public void OnDestroy(ref SystemState state) { }

        [BurstCompile]
        public void OnUpdate(ref SystemState state)
        {
            var team1Entities = team1Alive.ToEntityArray(Allocator.TempJob);
            var team2Entities = team2Alive.ToEntityArray(Allocator.TempJob);

            state.Dependency = new TargetJob
            {
                deltaTime = state.WorldUnmanaged.Time.DeltaTime,
                team1Enemies = team2Entities,
                team2Enemies = team1Entities
            }.ScheduleParallel(state.Dependency);

            team1Entities.Dispose(state.Dependency);
            team2Entities.Dispose(state.Dependency);
        }


        [BurstCompile]
        public partial struct TargetJob : IJobEntity
        {
            public float deltaTime;
            [ReadOnly] public NativeArray<Entity> team1Enemies;
            [ReadOnly] public NativeArray<Entity> team2Enemies;

            private void Execute(ref RandomComponent random, ref Target target, in Team team, in Alive _)
            {
                if (target.enemyTarget == Entity.Null)
                {
                    var enemies = team == 1 ? team1Enemies : team2Enemies;
                    int newTarget = random.generator.NextInt(0, enemies.Length);
                    target.enemyTarget = enemies[newTarget];
                }
            }
        }
    }
}
