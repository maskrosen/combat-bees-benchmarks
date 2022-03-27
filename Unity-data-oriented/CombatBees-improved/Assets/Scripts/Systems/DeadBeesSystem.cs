public static class DeadBeesSystem
{
    public static void Run(float deltaTime)
    {
        UpdateDead(0, deltaTime);
        UpdateDead(1, deltaTime);

    }

    static void UpdateDead(int teamIndex, float deltaTime)
    {
        //var deadBees = Data.DeadBees[teamIndex];
        int deadCount = Data.DeadCount[teamIndex];
        int aliveCount = Data.AliveCount[teamIndex];
        var movements = Data.BeeMovements[teamIndex];
        var deadTimers = Data.DeadTimers[teamIndex];

        bool deletedBee = false;

        for (int i = aliveCount; i < aliveCount + deadCount; i++)
        {
            int beeIndex = i;
            var m = movements[beeIndex];
            m.Velocity.y += Field.gravity * deltaTime;
            float deadTimer = deadTimers[beeIndex];
            deadTimer -= deltaTime / 10f;
            if (deadTimer < 0f)
            {
                Utils.DeleteBee(beeIndex, teamIndex);
                deletedBee = true;
                continue;
            }
            deadTimers[beeIndex] = deadTimer;
            movements[beeIndex] = m;
        }

        if (deletedBee)
        {
            //Data.DeadBees[teamIndex].Sort();
        }
    }
}