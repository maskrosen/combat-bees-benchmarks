public static class DeadBeesSystem
{
    public static void Run(float deltaTime)
    {
        UpdateDead(0, deltaTime);
        UpdateDead(1, deltaTime);

    }

    static void UpdateDead(int teamIndex, float deltaTime)
    {
        var deadBees = Data.DeadBees[teamIndex];
        var movements = Data.BeeMovements[teamIndex];
        var deadTimers = Data.DeadTimers[teamIndex];

        for (int i = 0; i < deadBees.Count; i++)
        {
            int beeIndex = deadBees[i];
            var m = movements[beeIndex];
            m.Velocity.y += Field.gravity * deltaTime;
            float deadTimer = deadTimers[beeIndex];
            deadTimer -= deltaTime / 10f;
            if (deadTimer < 0f)
            {
                Utils.DeleteBee(beeIndex, teamIndex);
            }
            deadTimers[beeIndex] = deadTimer;
        }
    }
}