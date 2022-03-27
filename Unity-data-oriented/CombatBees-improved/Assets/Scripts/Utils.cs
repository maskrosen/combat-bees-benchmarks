using System.Collections.Generic;
using System.Runtime.CompilerServices;
using UnityEngine;

public static class Utils
{
    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public static void AddToTargetList(StateList hasEnemyTarget, StateList hasNoTarget, int beeIndex)
    {
        hasEnemyTarget.Add(beeIndex);
        hasNoTarget.Remove(beeIndex);
    }

    public static void SpawnBees(int count, int teamIndex)
    {
        //var aliveBees = Data.AliveBees[teamIndex];
        //var deadBees = Data.DeadBees[teamIndex];
        int aliveBeesCount = Data.AliveCount[teamIndex];
        int deadBeesStartIndex = aliveBeesCount;
        int deadBeesCount = Data.DeadCount[teamIndex];
        if(deadBeesCount == 0)
        {
            //fast spawns, we don't need to copy any data in this case, just init bees after last current alive bee
            InitBees(deadBeesStartIndex, count, teamIndex);
        }
        else
        {
            //If we have dead bee we need to copy enough dead bees to make room for our new spawned bees in the alive segment
            int numberOfBeesToCopy = Mathf.Min(deadBeesCount, count);
            int destIndex = deadBeesStartIndex + count + deadBeesCount; //We copy them to the after the end of dead bees
            CopyBeeData(deadBeesStartIndex, destIndex, numberOfBeesToCopy, teamIndex);
            InitBees(deadBeesStartIndex, count, teamIndex);
        }
        
    }

    //Copies bee data in batch for the specified length starting at sourceIndex, overwriting the data in dest index and forward
    //Only used when spawning bees
    public static void CopyBeeData(int sourceIndex, int destIndex, int length, int teamIndex)
    {
        var movements = Data.BeeMovements[teamIndex];
        var directions = Data.BeeDirections[teamIndex];
        var sizes = Data.BeeSize[teamIndex];
        var targets = Data.BeeTargets[teamIndex];
        var deadTimers = Data.DeadTimers[teamIndex];
        //var deadBees = Data.DeadBees[teamIndex];

        var hasTargets = Data.HasEnemyTarget[teamIndex];
        var hasNoTargets = Data.HasNoTarget[teamIndex];

        /*
        for (int i = 0; i < length; i++)
        {
            int beeSourceIndex = sourceIndex + i;
            int beeDestIndex = destIndex + i;
            if (hasTargets.Remove(beeSourceIndex) && !hasTargets.Contains(beeDestIndex))
            {
                hasTargets.Add(beeDestIndex);
                hasNoTargets.Remove(beeDestIndex);
            }
            if (hasNoTargets.Remove(beeSourceIndex) && !hasNoTargets.Contains(beeDestIndex))
            {
                hasNoTargets.Add(beeDestIndex);
                hasTargets.Remove(beeDestIndex);
            }
        }
        */
        /*
        for (int i = 0; i < length; i++)
        {
            int beeSourceIndex = sourceIndex + i;
            deadBees.Remove(beeSourceIndex);
        }*/
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

    //Assumes that beeIndex is free and not currently holds data of an active bee
    public static void InitBees(int beeStartIndex, int length, int teamIndex)
    {
        var spawnPos = Data.BeeSpawnPos[teamIndex];
        var movements = Data.BeeMovements[teamIndex];
        var sizes = Data.BeeSize[teamIndex];
        //var alive = Data.AliveBees[teamIndex];
        var noTarget = Data.HasNoTarget[teamIndex];
        var hasEnemyTarget = Data.HasEnemyTarget[teamIndex];
        //var inActive = Data.InactiveBees[teamIndex];
        for (int i = 0; i < length; i++)
        {
            int beeIndex = beeStartIndex + i;
            var m = new Movement { Position = spawnPos, Velocity = new() };
            sizes[beeIndex] = Random.Range(Data.minBeeSize, Data.maxBeeSize);
            movements[beeIndex] = m;
            Data.AliveCount[teamIndex]++;
            //alive.Add(beeIndex);
            noTarget.Add(beeIndex);
            hasEnemyTarget.Remove(beeIndex); //TODO should not bee needed here, we should have cleared this while the bee was set to dead
            //inActive.Remove(beeIndex);
        }
        //alive.Sort();
        noTarget.Sort();
        StateChecker.Run();
    }

    public static void KillBee(int beeIndex, int teamIndex)
    {
        var movements = Data.BeeMovements[teamIndex];
        var directions = Data.BeeDirections[teamIndex];
        var sizes = Data.BeeSize[teamIndex];
        var targets = Data.BeeTargets[teamIndex];
        var deadTimers = Data.DeadTimers[teamIndex];

        var hasTargets = Data.HasEnemyTarget[teamIndex];
        var hasNoTargets = Data.HasNoTarget[teamIndex];
        //var alive = Data.AliveBees[teamIndex];
        //var dead = Data.DeadBees[teamIndex];
        int aliveCount = Data.AliveCount[teamIndex];

        int beeIndex1 = beeIndex;
        int beeIndex2 = aliveCount - 1; //Last alive bee
        Data.AliveCount[teamIndex]--;
        Data.DeadCount[teamIndex]++;
        bool aliveBeeHasTarget = !hasNoTargets.Contains(beeIndex2);
        if (aliveBeeHasTarget)
        {
            hasNoTargets.Remove(beeIndex1);
            if (!hasTargets.Contains(beeIndex1))
            {
                hasTargets.Add(beeIndex1);
            }
        }
        else
        {
            if (!hasNoTargets.Contains(beeIndex1))
            {
                hasNoTargets.Add(beeIndex1);
            }
            hasTargets.Remove(beeIndex1);
        }
        hasTargets.Remove(beeIndex2);
        hasNoTargets.Remove(beeIndex2);

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
        StateChecker.Run();
    }

    public static void DeleteBee(int beeIndex, int teamIndex)
    {
        var movements = Data.BeeMovements[teamIndex];
        var directions = Data.BeeDirections[teamIndex];
        var sizes = Data.BeeSize[teamIndex];
        var targets = Data.BeeTargets[teamIndex];
        var deadTimers = Data.DeadTimers[teamIndex];

        var hasTargets = Data.HasEnemyTarget[teamIndex];
        var hasNoTargets = Data.HasNoTarget[teamIndex];
        //var dead = Data.DeadBees[teamIndex];
        //var inactive = Data.InactiveBees[teamIndex];


        int beeIndex1 = beeIndex;
        //dead.Sort(); //We do a sort here so we can take the last index, this should hopefully be quite fast since we usually don't have that many bees in the dead list.
        int beeIndex2 = Data.AliveCount[teamIndex] + Data.DeadCount[teamIndex] - 1; //Last dead bee
        Data.DeadCount[teamIndex]--;

        movements[beeIndex1] = movements[beeIndex2];
        movements[beeIndex2] = new();


        directions[beeIndex1] = directions[beeIndex2];
        directions[beeIndex2] = new();

        sizes[beeIndex1] = sizes[beeIndex2];
        sizes[beeIndex2] = new();

        deadTimers[beeIndex1] = deadTimers[beeIndex2];
        deadTimers[beeIndex2] = 0;
        StateChecker.Run();
    }

}