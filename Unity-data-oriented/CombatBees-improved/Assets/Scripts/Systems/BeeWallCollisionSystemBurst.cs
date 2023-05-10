using UnityEngine;
using Unity.Burst;
using Unity.Collections;

[BurstCompile]
public static class BeeWallCollisionSystemBurst
{
    public static unsafe void Run()
    {
		var movements = DataBurst.Team1BeeMovements;
		CheckCollisions(DataBurst.AliveCount[0], DataBurst.DeadCount[0], (MovementBurst*)movements.GetPtr());

		movements = DataBurst.Team2BeeMovements;
		CheckCollisions(DataBurst.AliveCount[1], DataBurst.DeadCount[1], (MovementBurst*)movements.GetPtr());
		
	}

	[BurstCompile]
	static unsafe void CheckCollisions(int aliveCount, int deadCount, MovementBurst* movements)
    {
		int activeCount = aliveCount + deadCount;

        for (int i = 0; i < activeCount; i++)
        {
			var movement = movements[i];
			if (Mathf.Abs(movement.Position.x) > DataBurst.FieldSize.x * .5f)
			{
				movement.Position.x = (DataBurst.FieldSize.x * .5f) * Mathf.Sign(movement.Position.x);
				movement.Velocity.x *= -.5f;
				movement.Velocity.y *= .8f;
				movement.Velocity.z *= .8f;
			}
			if (Mathf.Abs(movement.Position.z) > DataBurst.FieldSize.z * .5f)
			{
				movement.Position.z = (DataBurst.FieldSize.z * .5f) * Mathf.Sign(movement.Position.z);
				movement.Velocity.z *= -.5f;
				movement.Velocity.x *= .8f;
				movement.Velocity.y *= .8f;
			}
			
			if (Mathf.Abs(movement.Position.y) > DataBurst.FieldSize.y * .5f)
			{
				movement.Position.y = (DataBurst.FieldSize.y * .5f) * Mathf.Sign(movement.Position.y);
				movement.Velocity.y *= -.5f;
				movement.Velocity.z *= .8f;
				movement.Velocity.x *= .8f;
			}
			movements[i] = movement;
		}

		
	}
}