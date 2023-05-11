using Unity.Entities;
using Unity.Transforms;
using Unity.Burst;
using Unity.Entities.UniversalDelegates;
using UnityEngine;
using Unity.Mathematics;
using static Unity.Mathematics.math;
using Unity.Collections;
using Unity.Jobs;

namespace DOTS
{

    [BurstCompile]
    public partial struct BeeMovementSystem : ISystem
    {

        private EntityQuery team1Bees;
        private EntityQuery team2Bees;

        private NativeArray<float3> team1Positions;
        private NativeArray<float3> team2Positions;

        public void OnCreate(ref SystemState state)
        {
            team1Bees = state.EntityManager.CreateEntityQuery(typeof(Team1), typeof(LocalTransform), typeof(Velocity), typeof(RandomComponent), typeof(Alive));
            team2Bees = state.EntityManager.CreateEntityQuery(typeof(Team2), typeof(LocalTransform), typeof(Velocity), typeof(RandomComponent), typeof(Alive));

            team1Positions = new NativeArray<float3>(Data.beeStartCount / 2, Allocator.Persistent);
            team2Positions = new NativeArray<float3>(Data.beeStartCount / 2, Allocator.Persistent);

        }

        public void OnDestroy(ref SystemState state) { }

        [BurstCompile]
        public void OnUpdate(ref SystemState state)
        {
            EntityCommandBuffer.ParallelWriter ecb = GetEntityCommandBuffer(ref state);
            int team1AliveCount = team1Bees.CalculateEntityCount();
            int team2AliveCount = team2Bees.CalculateEntityCount();

            var team1Transforms = team1Bees.ToComponentDataArray<LocalTransform>(Allocator.Temp);
            for (int i = 0; i < team1Transforms.Length; i++)
            {
                team1Positions[i] = team1Transforms[i].Position;
            }
            //team1 job
            new PositionJob
            {
                Ecb = ecb,
                deltaTime = state.WorldUnmanaged.Time.DeltaTime,
                aliveBeesCount = team1AliveCount,
                allyPositions = team1Positions,

            }.ScheduleParallel(team1Bees, state.Dependency).Complete();

            var team2Transforms = team2Bees.ToComponentDataArray<LocalTransform>(Allocator.Temp);
            for (int i = 0; i < team2Transforms.Length; i++)
            {
                team2Positions[i] = team2Transforms[i].Position;
            }
            // team2 job
            new PositionJob
            {
                Ecb = ecb,
                deltaTime = state.WorldUnmanaged.Time.DeltaTime,
                aliveBeesCount = team2AliveCount,
                allyPositions = team2Positions

            }.ScheduleParallel(team2Bees, state.Dependency).Complete();
        }

        private EntityCommandBuffer.ParallelWriter GetEntityCommandBuffer(ref SystemState state)
        {
            var ecbSingleton = SystemAPI.GetSingleton<BeginSimulationEntityCommandBufferSystem.Singleton>();
            var ecb = ecbSingleton.CreateCommandBuffer(state.WorldUnmanaged);
            return ecb.AsParallelWriter();
        }
               
        [BurstCompile]
        public partial struct PositionJob : IJobEntity
        {
            public EntityCommandBuffer.ParallelWriter Ecb;
            public float deltaTime;
            public int aliveBeesCount;
            [ReadOnly] public NativeArray<float3> allyPositions;

            // IJobEntity generates a component data query based on the parameters of its `Execute` method.
            // This example queries for all Spawner components and uses `ref` to specify that the operation
            // requires read and write access. Unity processes `Execute` for each entity that matches the
            // component data query.
            private void Execute([ChunkIndexInQuery] int chunkIndex, ref LocalTransform transform, ref Velocity velocity, ref RandomComponent random)
            {
                float3 randomVector;
                randomVector.x = random.generator.NextFloat() * 2.0f - 1.0f;
                randomVector.y = random.generator.NextFloat() * 2.0f - 1.0f;
                randomVector.z = random.generator.NextFloat() * 2.0f - 1.0f;

                velocity.Value += randomVector * (Data.flightJitter * deltaTime);
                velocity.Value *= (1f - Data.damping * deltaTime);

                //Move towards random ally
                float3 beePosition = transform.Position;
                int allyIndex = random.generator.NextInt(aliveBeesCount);
                var allyPosition = allyPositions[allyIndex];
                float3 delta = allyPosition - beePosition;
                float dist = Mathf.Sqrt(delta.x * delta.x + delta.y * delta.y + delta.z * delta.z);
                dist = Mathf.Max(0.01f, dist);
                velocity.Value += delta * (Data.teamAttraction * deltaTime / dist);

                //Move away from random ally
                allyIndex = random.generator.NextInt(aliveBeesCount);
                allyPosition = allyPositions[allyIndex];
                delta = allyPosition - beePosition;
                dist = Mathf.Sqrt(delta.x * delta.x + delta.y * delta.y + delta.z * delta.z);
                dist = Mathf.Max(0.01f, dist);
                velocity.Value -= delta * (Data.teamRepulsion * deltaTime / dist);

                var rotation = transform.Rotation;
                var targetRotation = Quaternion.LookRotation(normalize(velocity.Value), Vector3.up);
                rotation = Quaternion.Lerp(rotation, targetRotation, deltaTime * 4);
                transform.Rotation = rotation;

            }
        }

    }
}
