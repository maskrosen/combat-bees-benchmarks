using System.Collections.Generic;
using Unity.Burst;
using Unity.Burst.Intrinsics;
using UnityEngine;
using Unity.Collections;

[BurstCompile]
public static class EnemyTargetSystemBurst
{
    public static unsafe void Run()
    {
        GetNewEnemyTargets((ulong*)DataBurst.team1HasNoTargets.GetPtr(), DataBurst.AliveCount[0], DataBurst.AliveCount[1], 
            (int*)DataBurst.Team1BeeTargets.GetPtr(), (ulong*)DataBurst.team1HasTargets.GetPtr());
        GetNewEnemyTargets((ulong*)DataBurst.team2HasNoTargets.GetPtr(), DataBurst.AliveCount[1], DataBurst.AliveCount[0], 
            (int*)DataBurst.Team2BeeTargets.GetPtr(), (ulong*)DataBurst.team2HasTargets.GetPtr());

    }

    [BurstCompile]
    static unsafe void GetNewEnemyTargets(ulong* noTargets, int aliveCount, int enemyTeamAliveCount, int* targets, ulong* hasEnemyTarget)
    {
        for (int i = 0; i < aliveCount / 64 + 1; i++)
        {
            ulong mask = noTargets[i];
            if (mask == 0)
            {
                continue;
            }

            do
            {
                int nextBitIndex = (int)X86.Bmi1.tzcnt_u64(mask);
                int newTarget = (int)Random.Range(0, enemyTeamAliveCount);
                int beeIndex = i * 64 + nextBitIndex;
                targets[beeIndex] = newTarget;
                BitMaskUtils.SetBitTrue(hasEnemyTarget, beeIndex);
                BitMaskUtils.SetBitFalse(noTargets, beeIndex);
                mask ^= ((ulong)1 << nextBitIndex); //clear bit we just handled

        } while (mask != 0) ;
    }
}
}