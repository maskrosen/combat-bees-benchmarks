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

    static void GetNewEnemyTargets(StateList noTargets, StateList enemyTeamAlive, int[] targets, StateList hasEnemyTarget)
    {
        while (noTargets.Count > 0)
        {
            int beeIndex = noTargets[0];
            int newTarget = Random.Range(0, enemyTeamAlive.Count);
            targets[beeIndex] = newTarget;
            Utils.AddToTargetList(hasEnemyTarget, noTargets, beeIndex);
            StateChecker.Run();
        }
    }
}