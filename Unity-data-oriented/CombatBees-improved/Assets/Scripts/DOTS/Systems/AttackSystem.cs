using Unity.Entities;
using Unity.Transforms;
using Unity.Burst;
using UnityEngine;
using Unity.Collections;

namespace DOTS
{

    [BurstCompile]
    public partial struct AttackSystem : ISystem
    {

        private EntityQuery team1Bees;
        private EntityQuery team2Bees;
        private ComponentLookup<Dead> deadType;
        private ComponentLookup<LocalTransform> transformLookup;

        public void OnCreate(ref SystemState state)
        {
            team1Bees = state.EntityManager.CreateEntityQuery(typeof(Team1), typeof(LocalTransform), typeof(Velocity), typeof(Target), typeof(Alive));
            team2Bees = state.EntityManager.CreateEntityQuery(typeof(Team2), typeof(LocalTransform), typeof(Velocity), typeof(Target), typeof(Alive));
            deadType = state.GetComponentLookup<Dead>();
            transformLookup = state.GetComponentLookup<LocalTransform>();
        }

        public void OnDestroy(ref SystemState state) { }

        [BurstCompile]
        public void OnUpdate(ref SystemState state)
        {
            EntityCommandBuffer.ParallelWriter ecb = GetEntityCommandBuffer(ref state);
            deadType.Update(ref state);
            transformLookup.Update(ref state);
            //team1 job
            new AttackJob
            {
                Ecb = ecb,
                deltaTime = state.WorldUnmanaged.Time.DeltaTime,
                DeadType = deadType,
                TransformLookup = transformLookup

            }.ScheduleParallel(team1Bees, state.Dependency).Complete();

            deadType.Update(ref state);
            transformLookup.Update(ref state);
            // team2 job
            new AttackJob
            {
                Ecb = ecb,
                deltaTime = state.WorldUnmanaged.Time.DeltaTime,
                DeadType = deadType,
                TransformLookup = transformLookup

            }.ScheduleParallel(team2Bees, state.Dependency).Complete();
        }

        private EntityCommandBuffer.ParallelWriter GetEntityCommandBuffer(ref SystemState state)
        {
            var ecbSingleton = SystemAPI.GetSingleton<BeginSimulationEntityCommandBufferSystem.Singleton>();
            var ecb = ecbSingleton.CreateCommandBuffer(state.WorldUnmanaged);
            return ecb.AsParallelWriter();
        }

        [BurstCompile]
        public partial struct AttackJob : IJobEntity
        {
            public EntityCommandBuffer.ParallelWriter Ecb;
            public float deltaTime;
            [ReadOnly] public ComponentLookup<Dead> DeadType;
            [ReadOnly] public ComponentLookup<LocalTransform> TransformLookup;

            private void Execute(Entity e, [ChunkIndexInQuery] int chunkIndex, in LocalTransform transform, ref Velocity velocity, in Target targets)
            {
                if (DeadType.HasComponent(targets.enemyTarget))
                {
                    //the target is dead
                    Ecb.RemoveComponent<Target>(chunkIndex, e);
                    return;
                }

                var beePosition = transform.Position;
                var enmeyPosition = TransformLookup.GetRefRO(targets.enemyTarget).ValueRO.Position;

                var delta = enmeyPosition - beePosition;
                float sqrDist = delta.x * delta.x + delta.y * delta.y + delta.z * delta.z;
                if (sqrDist > Data.attackDistance * Data.attackDistance)
                {
                    velocity.Value += delta * (Data.chaseForce * deltaTime / Mathf.Sqrt(sqrDist));
                }
                else
                {
                    velocity.Value += delta * (Data.attackForce * deltaTime / Mathf.Sqrt(sqrDist));
                    if (sqrDist < Data.hitDistance * Data.hitDistance)
                    {
                        Ecb.AddComponent<Dead>(chunkIndex, targets.enemyTarget);
                        Ecb.AddComponent(chunkIndex, targets.enemyTarget, new DeadTimer { time = 0.0f});
                        Ecb.RemoveComponent<Alive>(chunkIndex, targets.enemyTarget);
                    }
                }

            }
        }

    }
}
