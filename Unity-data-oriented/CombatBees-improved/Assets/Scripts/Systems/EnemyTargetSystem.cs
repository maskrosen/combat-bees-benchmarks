using System.Collections.Generic;
using UnityEngine;

public static class EnemyTargetSystem
{
    public static void Run()
    {
        var noTargets = Data.Team1HasNoTarget;
        //var enemyTeamAlive = Data.Team2AliveBees;
        var targets = Data.Team1BeeTargets;
        var hasEnemyTarget = Data.Team1HasEnemyTarget;
        GetNewEnemyTargets(noTargets, Data.AliveCount[1], targets, hasEnemyTarget);


        noTargets = Data.Team2HasNoTarget;
        //enemyTeamAlive = Data.Team1AliveBees;
        targets = Data.Team2BeeTargets;
        hasEnemyTarget = Data.Team2HasEnemyTarget;
        GetNewEnemyTargets(noTargets, Data.AliveCount[0], targets, hasEnemyTarget);

    }

    static void GetNewEnemyTargets(StateList noTargets, int enemyTeamAliveCount, int[] targets, StateList hasEnemyTarget)
    {
        bool addedTarget = noTargets.Count > 0;
        while (noTargets.Count > 0)
        {
            int beeIndex = noTargets[0];
            int newTarget = Random.Range(0, enemyTeamAliveCount);
            targets[beeIndex] = newTarget;
            Utils.AddToTargetList(hasEnemyTarget, noTargets, beeIndex);
            StateChecker.Run();
        }
        if (addedTarget)
        {
            hasEnemyTarget.Sort();
            noTargets.Sort();
            
        }
    }
}