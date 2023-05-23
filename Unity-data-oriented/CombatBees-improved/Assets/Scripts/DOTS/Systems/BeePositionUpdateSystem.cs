using Unity.Entities;
using Unity.Transforms;
using Unity.Burst;
namespace DOTS
{

    [BurstCompile]
    [UpdateBefore(typeof(TransformSystemGroup))]
    [UpdateAfter(typeof(BeeMovementSystem))]
    public partial struct BeePositionUpdateSystem : ISystem
    {
        public void OnCreate(ref SystemState state)
        {
        }

        public void OnDestroy(ref SystemState state) { }

        [BurstCompile]
        public void OnUpdate(ref SystemState state)
        {
            EntityCommandBuffer.ParallelWriter ecb = GetEntityCommandBuffer(ref state);
           
            new BeeMovementJob
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
        public partial struct BeeMovementJob : IJobEntity
        {
            public EntityCommandBuffer.ParallelWriter Ecb;
            public float deltaTime;


            // IJobEntity generates a component data query based on the parameters of its `Execute` method.
            // This example queries for all Spawner components and uses `ref` to specify that the operation
            // requires read and write access. Unity processes `Execute` for each entity that matches the
            // component data query.
            private void Execute([ChunkIndexInQuery] int chunkIndex, ref LocalTransform transform, in Velocity velocity)
            {
                transform.Position += velocity.Value * deltaTime;
            }
        }

    }
}
