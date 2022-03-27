public static class BeePositionUpdateSystem    
{
    public static void Run(float deltaTime)
    {        
        var movements = Data.Team1BeeMovements;
        int activeBeesCount = Data.AliveCount[0] + Data.DeadCount[0];
        UpdatePosition(movements, activeBeesCount, deltaTime);

        movements = Data.Team2BeeMovements;
        activeBeesCount = Data.AliveCount[1] + Data.DeadCount[1];
        UpdatePosition(movements, activeBeesCount, deltaTime);
    }

    static void UpdatePosition(Movement[] movements, int activeBeesCount, float deltaTime)
    {
        for (int i = 0; i < activeBeesCount; i++)
        {
            var movement = movements[i];
            movement.Position += movement.Velocity * deltaTime;
            movements[i] = movement;
        }
    }
}
