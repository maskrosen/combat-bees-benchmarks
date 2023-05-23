using Unity.Entities;
using Unity.Transforms;
using Unity.Burst;
using UnityEngine;
using Unity.Mathematics;
using Unity.Collections;
using Unity.Jobs;

namespace DOTS
{

    [BurstCompile]
    [UpdateBefore(typeof(TransformSystemGroup))]
    public partial struct BeeMovementSystem : ISystem
    {

        private EntityQuery team1Bees;
        private EntityQuery team2Bees;

        public void OnCreate(ref SystemState state)
        {
            team1Bees = state.EntityManager.CreateEntityQuery(typeof(Team), typeof(LocalToWorld), typeof(Velocity), typeof(RandomComponent), typeof(Alive));
            team1Bees.AddSharedComponentFilter<Team>(1);
            team2Bees = state.EntityManager.CreateEntityQuery(typeof(Team), typeof(LocalToWorld), typeof(Velocity), typeof(RandomComponent), typeof(Alive));
            team2Bees.AddSharedComponentFilter<Team>(2);
        }

        public void OnDestroy(ref SystemState state) { }

        [BurstCompile]
        public void OnUpdate(ref SystemState state)
        {
            var team1Transforms = team1Bees.ToComponentDataArray<LocalToWorld>(Allocator.TempJob);
            var team2Transforms = team2Bees.ToComponentDataArray<LocalToWorld>(Allocator.TempJob);

            state.Dependency = new PositionJob
            {
                deltaTime = state.WorldUnmanaged.Time.DeltaTime,
                Team1Transforms = team1Transforms,
                Team2Transforms = team2Transforms,

            }.ScheduleParallel(state.Dependency);

            team1Transforms.Dispose(state.Dependency);
            team2Transforms.Dispose(state.Dependency);
        }

        [BurstCompile]
        public partial struct PositionJob : IJobEntity
        {
            public float deltaTime;
            [ReadOnly] public NativeArray<LocalToWorld> Team1Transforms;
            [ReadOnly] public NativeArray<LocalToWorld> Team2Transforms;

            // IJobEntity generates a component data query based on the parameters of its `Execute` method.
            // This example queries for all Spawner components and uses `ref` to specify that the operation
            // requires read and write access. Unity processes `Execute` for each entity that matches the
            // component data query.
            private void Execute(ref LocalTransform transform, ref Velocity velocity, ref RandomComponent random, in Team team, in Alive _)
            {
                float3 randomVector;
                randomVector.x = random.generator.NextFloat() * 2.0f - 1.0f;
                randomVector.y = random.generator.NextFloat() * 2.0f - 1.0f;
                randomVector.z = random.generator.NextFloat() * 2.0f - 1.0f;

                velocity.Value += randomVector * (Data.flightJitter * deltaTime);
                velocity.Value *= (1f - Data.damping * deltaTime);

                var aliveBeesCount = team == 1 ? Team1Transforms.Length : Team2Transforms.Length;
                var allyPositions = team == 1 ? Team1Transforms : Team2Transforms;

                //Move towards random ally
                float3 beePosition = transform.Position;
                int allyIndex = random.generator.NextInt(aliveBeesCount);
                var allyPosition = allyPositions[allyIndex].Position;
                float3 delta = allyPosition - beePosition;
                float dist = math.sqrt(delta.x * delta.x + delta.y * delta.y + delta.z * delta.z);
                dist = math.max(0.01f, dist);
                velocity.Value += delta * (Data.teamAttraction * deltaTime / dist);

                //Move away from random ally
                allyIndex = random.generator.NextInt(aliveBeesCount);
                allyPosition = allyPositions[allyIndex].Position;
                delta = allyPosition - beePosition;
                dist = math.sqrt(delta.x * delta.x + delta.y * delta.y + delta.z * delta.z);
                dist = math.max(0.011f, dist);
                velocity.Value -= delta * (Data.teamRepulsion * deltaTime / dist);

                var rotation = transform.Rotation;
                var targetRotation = quaternion.LookRotation(math.normalize(velocity.Value), Vector3.up);
                rotation = math.nlerp(rotation, targetRotation, deltaTime * 4);
                transform.Rotation = rotation;
            }
        }
    }
}
