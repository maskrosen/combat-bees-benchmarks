using Unity.Burst;
using Unity.Mathematics;

[BurstCompile]
public static class DeadBeesSystemBurst
{
    public static unsafe void Run(float deltaTime)
    {
        int teamIndex = 0;
        int* deadCountPtr = (int*)DataBurst.DeadCount.GetPtr();
        UpdateDead(deltaTime, deadCountPtr, DataBurst.AliveCount[teamIndex], 
            (MovementBurst*)DataBurst.BeeMovements[teamIndex].GetPtr(), (float*)DataBurst.DeadTimers[teamIndex].GetPtr(),
            (float*)DataBurst.BeeSize[teamIndex].GetPtr(), (float3*)DataBurst.BeeDirections[teamIndex].GetPtr());
        teamIndex = 1;
        deadCountPtr = (int*)DataBurst.DeadCount.GetPtr() + 1;
        UpdateDead(deltaTime, deadCountPtr, DataBurst.AliveCount[teamIndex],
            (MovementBurst*)DataBurst.BeeMovements[teamIndex].GetPtr(), (float*)DataBurst.DeadTimers[teamIndex].GetPtr(),
            (float*)DataBurst.BeeSize[teamIndex].GetPtr(), (float3*)DataBurst.BeeDirections[teamIndex].GetPtr());

    }

    [BurstCompile]
    static unsafe void UpdateDead(float deltaTime, int* deadCount, int aliveCount, MovementBurst* movements, float* deadTimers, float* sizes, float3* directions)
    {

        for (int i = aliveCount; i < aliveCount + *deadCount; i++)
        {
            int beeIndex = i;
            var m = movements[beeIndex];
            m.Velocity.y += Field.gravity * deltaTime;
            float deadTimer = deadTimers[beeIndex];
            deadTimer -= deltaTime / 10f;
            if (deadTimer < 0f)
            {
                UtilsBurst.DeleteBee(beeIndex, deadCount, aliveCount, movements, sizes, deadTimers, directions);
                continue;
            }
            deadTimers[beeIndex] = deadTimer;
            movements[beeIndex] = m;
        }
    }
}