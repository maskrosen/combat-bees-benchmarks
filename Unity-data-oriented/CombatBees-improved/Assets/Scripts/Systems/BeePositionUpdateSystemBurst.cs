using Unity.Burst;
using Unity.Collections;

[BurstCompile]
public static class BeePositionUpdateSystemBurst    
{
    public unsafe static void Run(float deltaTime)
    {        
        var movements = DataBurst.Team1BeeMovements;
        int activeBeesCount = DataBurst.AliveCount[0] + DataBurst.DeadCount[0];
        UpdatePosition((MovementBurst*)movements.GetPtr(), activeBeesCount, deltaTime);

        movements = DataBurst.Team2BeeMovements;
        activeBeesCount = DataBurst.AliveCount[1] + DataBurst.DeadCount[1];
        UpdatePosition((MovementBurst*)movements.GetPtr(), activeBeesCount, deltaTime);
    }

    [BurstCompile]
    static unsafe void UpdatePosition(MovementBurst* movements, int activeBeesCount, float deltaTime)
    {
        for (int i = 0; i < activeBeesCount; i++)
        {
            var movement = movements[i];
            movement.Position += movement.Velocity * deltaTime;
            movements[i] = movement;
        }
    }
}
