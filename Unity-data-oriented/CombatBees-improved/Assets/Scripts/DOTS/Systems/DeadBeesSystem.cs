using Unity.Entities;
using Unity.Burst;
namespace DOTS
{

    [BurstCompile]
    public partial struct DeadBeesSystem : ISystem
    {
        public void OnCreate(ref SystemState state)
        {
        }

        public void OnDestroy(ref SystemState state) { }

        [BurstCompile]
        public void OnUpdate(ref SystemState state)
        {
            EntityCommandBuffer.ParallelWriter ecb = GetEntityCommandBuffer(ref state);

            new BeeDeadJob
            {
                Ecb = ecb,
                deltaTime = state.WorldUnmanaged.Time.DeltaTime

            }.ScheduleParallel(state.Dependency).Complete();
        }

        private EntityCommandBuffer.ParallelWriter GetEntityCommandBuffer(ref SystemState state)
        {
            var ecbSingleton = SystemAPI.GetSingleton<BeginSimulationEntityCommandBufferSystem.Singleton>();
            var ecb = ecbSingleton.CreateCommandBuffer(state.WorldUnmanaged);
            return ecb.AsParallelWriter();
        }

        [BurstCompile]
        public partial struct BeeDeadJob : IJobEntity
        {
            public EntityCommandBuffer.ParallelWriter Ecb;
            public float deltaTime;

            private void Execute(Entity e, [ChunkIndexInQuery] int chunkIndex, ref Velocity velocity, ref DeadTimer deadTimer, in Dead dead)
            {
                deadTimer.time += deltaTime / 10.0f;
                velocity.Value.y += Field.gravity * deltaTime;

                if (deadTimer.time >= 1.0f)
                {
                    Ecb.DestroyEntity(chunkIndex, e);
                }
            }
        }

    }
}
