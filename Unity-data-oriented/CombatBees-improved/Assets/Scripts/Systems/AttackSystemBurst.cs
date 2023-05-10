using UnityEngine;
using Unity.Burst;
using Unity.Burst.Intrinsics;
using Unity.Mathematics;

[BurstCompile]
public static class AttackSystemBurst
{
    public static unsafe void Run(float deltaTime)
    {
        int* deadCountPtr = (int*)DataBurst.DeadCount.GetPtr();
        int* aliveCountPtr = (int*)DataBurst.AliveCount.GetPtr();
        DoAttack(deltaTime, (MovementBurst*)DataBurst.Team1BeeMovements.GetPtr(), (MovementBurst*)DataBurst.Team2BeeMovements.GetPtr(), 
            (ulong*)DataBurst.team1HasNoTargets.GetPtr(), (ulong *)DataBurst.team1HasTargets.GetPtr(), aliveCountPtr, deadCountPtr, DataBurst.AliveCount[1], 
            (int*)DataBurst.Team1BeeTargets.GetPtr(), 1, (float*)DataBurst.Team1Size.GetPtr(), (float*)DataBurst.Team1DeadTimers.GetPtr(), (float3*)DataBurst.Team1BeeDirections.GetPtr());
        deadCountPtr = (int*)DataBurst.DeadCount.GetPtr() + 1;
        aliveCountPtr = (int*)DataBurst.AliveCount.GetPtr() + 1;
        DoAttack(deltaTime, (MovementBurst*)DataBurst.Team2BeeMovements.GetPtr(), (MovementBurst*)DataBurst.Team1BeeMovements.GetPtr(),
             (ulong*)DataBurst.team2HasNoTargets.GetPtr(), (ulong*)DataBurst.team2HasTargets.GetPtr(), aliveCountPtr, deadCountPtr, DataBurst.AliveCount[0],
             (int*)DataBurst.Team2BeeTargets.GetPtr(), 0, (float*)DataBurst.Team2Size.GetPtr(), (float*)DataBurst.Team2DeadTimers.GetPtr(), (float3*)DataBurst.Team2BeeDirections.GetPtr());
    }

	[BurstCompile]
	static unsafe void DoAttack(float deltaTime, MovementBurst* movements, MovementBurst* enemyMovements,
        ulong* noTargets, ulong* hasEnemyTarget, int* aliveCount, int* deadCount, int enemyAliveCount, int* targets, int enemyTeamIndex,
        float* sizes, float* deadTimers, float3* directions)
    {
        for (int i = 0; i < *aliveCount / 64 + 1; i++)
        {
            ulong mask = hasEnemyTarget[i];
            if (mask == 0)
            {
                continue;
            }

            do
            {
                int nextBitIndex = (int)X86.Bmi1.tzcnt_u64(mask);
                int beeIndex = i * 64 + nextBitIndex;

                int enemyIndex = targets[beeIndex];
                if (enemyIndex >= enemyAliveCount)
                {
                    //the target is dead
                    targets[beeIndex] = -1;
                    BitMaskUtils.SetBitFalse(hasEnemyTarget, beeIndex);
                    BitMaskUtils.SetBitTrue(noTargets, beeIndex);
                    mask ^= ((ulong)1 << nextBitIndex); //clear bit we just handled
                    continue;
                }

                MovementBurst movement = movements[beeIndex];
                MovementBurst enemyMovement = enemyMovements[enemyIndex];

                float3 delta = enemyMovement.Position - movement.Position;
                float sqrDist = delta.x * delta.x + delta.y * delta.y + delta.z * delta.z;
                if (sqrDist > DataBurst.attackDistance * DataBurst.attackDistance)
                {
                    movement.Velocity = movement.Velocity + (delta * (DataBurst.chaseForce * deltaTime / Mathf.Sqrt(sqrDist)));
                }
                else
                {
                    movement.Velocity = movement.Velocity + (delta * (DataBurst.attackForce * deltaTime / Mathf.Sqrt(sqrDist)));
                    if (sqrDist < DataBurst.hitDistance * DataBurst.hitDistance)
                    {
                        UtilsBurst.KillBee(enemyIndex, deadCount, aliveCount, movements, sizes, deadTimers, directions, noTargets, hasEnemyTarget, targets);
                        targets[beeIndex] = -1;
                        BitMaskUtils.SetBitFalse(hasEnemyTarget, beeIndex);
                        BitMaskUtils.SetBitTrue(noTargets, beeIndex);
                    }
                }
                movements[beeIndex] = movement;

                mask ^= ((ulong)1 << nextBitIndex); //clear bit we just handled

            } while (mask != 0);
        }
	}

}