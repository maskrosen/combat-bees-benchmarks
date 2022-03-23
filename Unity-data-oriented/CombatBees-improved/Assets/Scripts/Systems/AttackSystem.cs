using UnityEngine;

public static class AttackSystem
{
    public static void Run(float deltaTime)
    {
		Attack(0, 1, deltaTime);
		Attack(1, 0, deltaTime);
    }

	static void Attack(int teamIndex, int enemyTeamIndex, float deltaTime)
    {
		var beesWithTargets = Data.HasEnemyTarget[teamIndex];
		var targets = Data.BeeTargets[teamIndex];
		var movements = Data.BeeMovements[teamIndex];
		var enemyMovements = Data.BeeMovements[enemyTeamIndex];

		for (int i = 0; i < beesWithTargets.Count; i++)
		{
			int beeIndex = beesWithTargets[i];
			int enemyIndex = targets[beeIndex];

			var movement = movements[beeIndex];
			var enemyMovement = enemyMovements[enemyIndex];

			var delta = enemyMovement.Position - movement.Position;
			float sqrDist = delta.x * delta.x + delta.y * delta.y + delta.z * delta.z;
			if (sqrDist > Data.attackDistance * Data.attackDistance)
			{
				movement.Velocity += delta * (Data.chaseForce * deltaTime / Mathf.Sqrt(sqrDist));
			}
			else
			{
				movement.Velocity += delta * (Data.attackForce * deltaTime / Mathf.Sqrt(sqrDist));
				if (sqrDist < Data.hitDistance * Data.hitDistance)
				{
					//ParticleManager.SpawnParticle(enemyMovement.Position, ParticleType.Blood, movement.Velocity * .35f, 2f, 6);
					Utils.KillBee(enemyIndex, enemyTeamIndex);
					targets[beeIndex] = -1;
					Data.HasEnemyTarget[teamIndex].Remove(beeIndex);
					Data.HasNoTarget[teamIndex].AddAndSort(beeIndex);
					
				}
			}

		}
	}

}