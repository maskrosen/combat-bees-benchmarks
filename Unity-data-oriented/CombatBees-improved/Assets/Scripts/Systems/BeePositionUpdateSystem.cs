public static class BeePositionUpdateSystem    
{
    public static void Run(float deltaTime)
    {        
        var movements = Data.Team1BeeMovements;
        int activeBeesCount = Data.Team1AliveBees.Count + Data.Team1DeadBees.Count;
        UpdatePosition(movements, activeBeesCount, deltaTime);

        movements = Data.Team2BeeMovements;
        activeBeesCount = Data.Team2AliveBees.Count + Data.Team2DeadBees.Count;
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
