using UnityEngine;

public static class StateChecker
{
    public static void Run()
    {
        NotDeadAndAlive();
        NotDeadAndInactive();
        NotAliveAndInactive();
        NotHasTargetAndHasNotTarget();
    }

    static void NotDeadAndAlive()
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

    static void NotDeadAndInactive()
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

    static void NotAliveAndInactive()
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
}