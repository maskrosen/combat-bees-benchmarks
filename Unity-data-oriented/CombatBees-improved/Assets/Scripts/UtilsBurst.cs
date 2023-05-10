using System.Collections.Generic;
using System.Runtime.CompilerServices;
using UnityEngine;
using Unity.Burst;
using Unity.Mathematics;
using Random = UnityEngine.Random;

public static class UtilsBurst
{
    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public static void AddToTargetList(StateList hasEnemyTarget, StateList hasNoTarget, int beeIndex)
    {
        hasEnemyTarget.Add(beeIndex);
        hasNoTarget.Remove(beeIndex);
    }

    public static void SpawnBees(int count, int teamIndex)
    {
        int aliveBeesCount = DataBurst.AliveCount[teamIndex];
        int deadBeesStartIndex = aliveBeesCount;
        int deadBeesCount = DataBurst.DeadCount[teamIndex];
        if(deadBeesCount == 0)
        {
            //fast spawns, we don't need to copy any data in this case, just init bees after last current alive bee
            InitBees(deadBeesStartIndex, count, teamIndex);
        }
        else
        {
            //If we have dead bee we need to copy enough dead bees to make room for our new spawned bees in the alive segment
            int numberOfBeesToCopy = Mathf.Min(deadBeesCount, count);
            int destIndex = deadBeesStartIndex + deadBeesCount; //We copy them to the after the end of dead bees
            CopyBeeData(deadBeesStartIndex, destIndex, numberOfBeesToCopy, teamIndex);
            InitBees(deadBeesStartIndex, count, teamIndex);
        }
        
    }
    //Copies bee data in batch for the specified length starting at sourceIndex, overwriting the data in dest index and forward
    //Only used when spawning bees
    public static void CopyBeeData(int sourceIndex, int destIndex, int length, int teamIndex)
    {
        var movements = DataBurst.BeeMovements[teamIndex];
        var directions = DataBurst.BeeDirections[teamIndex];
        var sizes = DataBurst.BeeSize[teamIndex];
        var targets = DataBurst.BeeTargets[teamIndex];
        var deadTimers = DataBurst.DeadTimers[teamIndex];
       
        for (int i = 0; i < length; i++)
        {
            int beeSourceIndex = sourceIndex + i;
            int beeDestIndex = destIndex + i;
            movements[beeDestIndex] = movements[beeSourceIndex];
        }

        for (int i = 0; i < length; i++)
        {
            int beeSourceIndex = sourceIndex + i;
            int beeDestIndex = destIndex + i;
            directions[beeDestIndex] = directions[beeSourceIndex];
        }
        
        for (int i = 0; i < length; i++)
        {
            int beeSourceIndex = sourceIndex + i;
            int beeDestIndex = destIndex + i;
            sizes[beeDestIndex] = sizes[beeSourceIndex];
        }

        for (int i = 0; i < length; i++)
        {
            int beeSourceIndex = sourceIndex + i;
            int beeDestIndex = destIndex + i;
            targets[beeDestIndex] = targets[beeSourceIndex];
        }

        for (int i = 0; i < length; i++)
        {
            int beeSourceIndex = sourceIndex + i;
            int beeDestIndex = destIndex + i;
            deadTimers[beeDestIndex] = deadTimers[beeSourceIndex];
        }
    }

    //Assumes that beeIndex is free and not currently holds data of an active bee]
    public static unsafe void InitBees(int beeStartIndex, int length, int teamIndex)
    {
        var spawnPos = DataBurst.BeeSpawnPos[teamIndex];
        var movements = DataBurst.BeeMovements[teamIndex];
        var sizes = DataBurst.BeeSize[teamIndex];
        for (int i = 0; i < length; i++)
        {
            int beeIndex = beeStartIndex + i;
            var m = new MovementBurst { Position = spawnPos, Velocity = new() };
            sizes[beeIndex] = Random.Range(DataBurst.minBeeSize, DataBurst.maxBeeSize);
            movements[beeIndex] = m;
            DataBurst.AliveCount[teamIndex]++;
            var noTargets = teamIndex == 0 ? DataBurst.team1HasNoTargets : DataBurst.team2HasNoTargets;
            var hasTargets = teamIndex == 0 ? DataBurst.team1HasTargets : DataBurst.team2HasTargets;
            BitMaskUtils.SetBitTrue((ulong*)noTargets.GetPtr(), beeIndex);
            BitMaskUtils.SetBitFalse((ulong*)hasTargets.GetPtr(), beeIndex);
           
        }
    }

    public static unsafe void KillBee(int beeIndex, int* deadCount, int* aliveCount, MovementBurst* movements, float* sizes, float* deadTimers, float3* directions,
        ulong* noTargets, ulong* hasEnemyTarget, int* targets)
    {
        
        int beeIndex1 = beeIndex;
        int beeIndex2 = *aliveCount - 1; //Last alive bee
        *aliveCount -= 1;
        *deadCount += 1;

        BitMaskUtils.CopyBitValue(noTargets, beeIndex2, beeIndex1);
        BitMaskUtils.CopyBitValue(hasEnemyTarget, beeIndex2, beeIndex1);

        var tempM = movements[beeIndex1];
        tempM.Velocity *= .5f;
        movements[beeIndex1] = movements[beeIndex2];
        movements[beeIndex2] = tempM;


        var tempSD = directions[beeIndex1];
        directions[beeIndex1] = directions[beeIndex2];
        directions[beeIndex2] = tempSD;

        var tempS = sizes[beeIndex1];
        sizes[beeIndex1] = sizes[beeIndex2];
        sizes[beeIndex2] = tempS;

        targets[beeIndex1] = targets[beeIndex2];
        targets[beeIndex2] = -1;

        deadTimers[beeIndex1] = deadTimers[beeIndex2];
        deadTimers[beeIndex2] = 1;
    }

    [BurstCompile]
    public static unsafe void DeleteBee(int beeIndex, int* deadCount, int aliveCount, MovementBurst* movements, float* sizes, float* deadTimers, float3* directions)
    {
        int beeIndex1 = beeIndex;
        int beeIndex2 = aliveCount + *deadCount - 1; //Last dead bee
        *deadCount -= 1;

        movements[beeIndex1] = movements[beeIndex2];
        movements[beeIndex2] = new();


        directions[beeIndex1] = directions[beeIndex2];
        directions[beeIndex2] = new();

        sizes[beeIndex1] = sizes[beeIndex2];
        sizes[beeIndex2] = new();

        deadTimers[beeIndex1] = deadTimers[beeIndex2];
        deadTimers[beeIndex2] = 0;
    }

}