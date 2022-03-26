using System.Collections.Generic;
using UnityEngine;

public static class StateChecker
{
    public static void Run()
    {
       // return;
        NotDeadAndAlive();
        NotDeadAndInactive();
        NotAliveAndInactive();
        NotHasTargetAndHasNotTarget();
        TargetNotValid();
        CheckForCopies();
        CheckBeeOrder();
    }

    static void CheckBeeOrder()
    {
        var alive1 = Data.Team1AliveBees;
        var dead1 = Data.Team1DeadBees;
        for (int i = 0; i < alive1.Count; i++)
        {
            int beeIndex = alive1[i];
            if(beeIndex > alive1.Count)
            {
                Debug.LogError("Alive bees team 1 are not sorted properly");
            }
        }
        if(dead1.Count > 0 && dead1[0] != alive1.Count)
        {
            Debug.LogError("Dead bees team 1 are not sorted properly");
        }

        var alive2 = Data.Team2AliveBees;
        var dead2 = Data.Team2DeadBees;
        for (int i = 0; i < alive2.Count; i++)
        {
            int beeIndex = alive2[i];
            if (beeIndex > alive2.Count)
            {
                Debug.LogError("Alive bees team 2 are not sorted properly");
            }
        }
        if (dead2.Count > 0 && dead2.Contains(alive2.Count))
        {
            Debug.LogError("Dead bees team 2 are not sorted properly");
        }
    }

    public static void CheckForCopies()
    {
        if (ContainsCopies(Data.Team1AliveBees))
        {
            Debug.LogError("Team 1 alive bees contains copies");
        }
        if (ContainsCopies(Data.Team2AliveBees))
        {
            Debug.LogError("Team 2 alive bees contains copies");
        }
        if (ContainsCopies(Data.Team1DeadBees))
        {
            Debug.LogError("Team 1 dead bees contains copies");
        }
        if (ContainsCopies(Data.Team2DeadBees))
        {
            Debug.LogError("Team 2 dead bees contains copies");
        }
        if (ContainsCopies(Data.Team1InactiveBees))
        {
            Debug.LogError("Team 1 inactive bees contains copies");
        }
        if (ContainsCopies(Data.Team2InactiveBees))
        {
            Debug.LogError("Team 2 inactive bees contains copies");
        }
        if (ContainsCopies(Data.Team1HasEnemyTarget))
        {
            Debug.LogError("Team 1 has enemy target contains copies");
        }
        if (ContainsCopies(Data.Team2HasEnemyTarget))
        {
            Debug.LogError("Team 2 has enemy target contains copies");
        }
        if (ContainsCopies(Data.Team1HasNoTarget))
        {
            Debug.LogError("Team 1 has no target contains copies");
        }
        if (ContainsCopies(Data.Team2HasNoTarget))
        {
            Debug.LogError("Team 2 has no target contains copies");
        }

    }

    public static void NotDeadAndAlive()
    {
        var alive1 = Data.Team1AliveBees;
        var dead1 = Data.Team1DeadBees;

        for (int i = 0; i < alive1.Count; i++)
        {
            if (dead1.Contains(alive1[i]))
            {
                Debug.LogError("Beeindex " + i + " in team 1 is in both alive and dead lists. This is illegal");
            }
        }

        var alive2 = Data.Team2AliveBees;
        var dead2 = Data.Team2DeadBees;

        for (int i = 0; i < alive2.Count; i++)
        {
            if (dead2.Contains(alive2[i]))
            {
                Debug.LogError("Beeindex " + i + " in team 2 is in both alive and dead lists. This is illegal");
            }
        }
    }

    public static void NotDeadAndInactive()
    {
        var inactive1 = Data.Team1InactiveBees;
        var dead1 = Data.Team1DeadBees;

        for (int i = 0; i < inactive1.Count; i++)
        {
            if (dead1.Contains(inactive1[i]))
            {
                Debug.LogError("Beeindex " + i + " in team 1 is in both inactive and dead lists. This is illegal");
            }
        }

        var inactive2 = Data.Team2InactiveBees;
        var dead2 = Data.Team2DeadBees;

        for (int i = 0; i < inactive2.Count; i++)
        {
            if (dead2.Contains(inactive2[i]))
            {
                Debug.LogError("Beeindex " + i + " in team 2 is in both inactive and dead lists. This is illegal");
            }
        }
    }

    public static void NotAliveAndInactive()
    {
        var inactive1 = Data.Team1InactiveBees;
        var alive1 = Data.Team1AliveBees;

        for (int i = 0; i < inactive1.Count; i++)
        {
            if (alive1.Contains(inactive1[i]))
            {
                Debug.LogError("Beeindex " + i + " in team 1 is in both inactive and alive lists. This is illegal");
            }
        }

        var inactive2 = Data.Team2InactiveBees;
        var alive2 = Data.Team2AliveBees;

        for (int i = 0; i < inactive2.Count; i++)
        {
            if (alive2.Contains(inactive2[i]))
            {
                Debug.LogError("Beeindex " + i + " in team 2 is in both inactive and alive lists. This is illegal");
            }
        }
    }

    static void NotHasTargetAndHasNotTarget()
    {
        var hasTarget1 = Data.Team1HasEnemyTarget;
        var hasNotTarget1 = Data.Team1HasNoTarget;

        for (int i = 0; i < hasTarget1.Count; i++)
        {
            if (hasNotTarget1.Contains(hasTarget1[i]))
            {
                Debug.LogError("Beeindex " + i + " in team 1 is in both has target and has not target lists. This is illegal");
            }
        }

        var hasTarget2 = Data.Team1HasEnemyTarget;
        var hasNotTarget2 = Data.Team1HasNoTarget;

        for (int i = 0; i < hasTarget2.Count; i++)
        {
            if (hasNotTarget2.Contains(hasTarget2[i]))
            {
                Debug.LogError("Beeindex " + i + " in team 2 is in both has target and has not target lists. This is illegal");
            }
        }
    }

    static void TargetNotValid()
    {
        var hasTarget1 = Data.Team1HasEnemyTarget;
        var targets1 = Data.Team1BeeTargets;
        for (int i = 0; i < hasTarget1.Count; i++)
        {
            int beeIndex = hasTarget1[i];
            int enemyIndex = targets1[beeIndex];
            if(enemyIndex < 0)
            {
                Debug.LogError("Beeindex " + i + " in team 1 is in hasEnemyTarget list but does not have a proper enemy target");
            }
        }

        var hasTarget2 = Data.Team2HasEnemyTarget;
        var targets2 = Data.Team2BeeTargets;
        for (int i = 0; i < hasTarget2.Count; i++)
        {
            int beeIndex = hasTarget2[i];
            int enemyIndex = targets2[beeIndex];
            if (enemyIndex < 0)
            {
                Debug.LogError("Beeindex " + i + " in team 2 is in hasEnemyTarget list but does not have a proper enemy target");
            }
        }

    }

    static bool ContainsCopies(StateList list)
    {
        for (int i = 0; i < list.Count; i++)
        {
            for (int j = 0; j < list.Count; j++)
            {
                if (list[i] == list[j] && i != j)
                {
                    return true;
                }
            }
        }
        return false;
    }
}