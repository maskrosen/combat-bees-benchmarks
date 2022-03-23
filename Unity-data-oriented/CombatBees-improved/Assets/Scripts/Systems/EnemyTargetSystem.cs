using System.Collections.Generic;
using UnityEngine;

public static class EnemyTargetSystem
{
    public static void Run()
    {
        var noTargets = Data.Team1HasNoTarget;
        var enemyTeamAlive = Data.Team2AliveBees;
        var targets = Data.Team1BeeTargets;
        var hasEnemyTarget = Data.Team1HasEnemyTarget;
        GetNewEnemyTargets(noTargets, enemyTeamAlive, targets, hasEnemyTarget);


        noTargets = Data.Team2HasNoTarget;
        enemyTeamAlive = Data.Team1AliveBees;
        targets = Data.Team2BeeTargets;
        hasEnemyTarget = Data.Team2HasEnemyTarget;
        GetNewEnemyTargets(noTargets, enemyTeamAlive, targets, hasEnemyTarget);

    }

    static void GetNewEnemyTargets(List<int> noTargets, List<int> enemyTeamAlive, int[] targets, List<int> hasEnemyTarget)
    {

        for (int i = 0; i < noTargets.Count; i++)
        {
            int beeIndex = noTargets[i];
            int newTarget = Random.Range(0, enemyTeamAlive.Count);
            targets[beeIndex] = newTarget;
            Utils.AddToTargetList(hasEnemyTarget, noTargets, beeIndex);
        }
    }
}