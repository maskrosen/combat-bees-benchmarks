using UnityEngine;

public static class AttackSystem
{
    public static void Run(float deltaTime)
    {
		Attack(0, 1, deltaTime, out bool beKilled1);
		Attack(1, 0, deltaTime, out bool beKilled2);
		if(beKilled1)
        {
			Data.Team1HasNoTarget.Sort();
			Data.Team1HasEnemyTarget.Sort();
			//Data.Team1AliveBees.Sort();
			//Data.Team1DeadBees.Sort();
        }
        if (beKilled2)
        {
			Data.Team2HasNoTarget.Sort();
			Data.Team2HasEnemyTarget.Sort();
			//Data.Team2AliveBees.Sort();
			//Data.Team2DeadBees.Sort();
		}
    }

	static void Attack(int teamIndex, int enemyTeamIndex, float deltaTime, out bool beKilled)
    {
		var beesWithTargets = Data.HasEnemyTarget[teamIndex];
		var targets = Data.BeeTargets[teamIndex];
		var movements = Data.BeeMovements[teamIndex];
		var enemyMovements = Data.BeeMovements[enemyTeamIndex];
		beKilled = false;
		for (int i = 0; i < beesWithTargets.Count; i++)
		{
			int beeIndex = beesWithTargets[i];
			int enemyIndex = targets[beeIndex];
			if(enemyIndex >= Data.AliveCount[enemyTeamIndex])
            {
				//the target is dead
				targets[beeIndex] = -1;
				beesWithTargets.Remove(beeIndex);
				Data.HasNoTarget[teamIndex].Add(beeIndex);
				continue;
			}

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
					Data.HasNoTarget[teamIndex].Add(beeIndex);
					beKilled = true;
					StateChecker.Run();
				}
			}
			movements[beeIndex] = movement;

		}
	}

}