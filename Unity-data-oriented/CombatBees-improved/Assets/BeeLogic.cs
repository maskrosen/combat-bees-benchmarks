using UnityEngine;

public class BeeLogic : MonoBehaviour
{
    public Bee data;
	BeeSpawner beeSpawner;

	// Start is called before the first frame update
	void Start()
    {
        
    }

    public void Init(Vector3 myPosition, int myTeam, float mySize, BeeSpawner beeSpawner)
    {
		data = new Bee();
		data.Init(myPosition, myTeam, mySize);
		this.beeSpawner = beeSpawner;
    }

    // Update is called once per frame
    void Update()
    {
        float deltaTime = Time.deltaTime;

		Bee bee = data;
		bee.isAttacking = false;
		bee.isHoldingResource = false;
		if (bee.dead == false)
		{
			bee.velocity += Random.insideUnitSphere * (beeSpawner.flightJitter * deltaTime);
			bee.velocity *= (1f - Data.damping * deltaTime);
			
			Bee attractiveFriend = beeSpawner.GetRandomAlly(data.team);
			Vector3 delta = attractiveFriend.position - bee.position;
			float dist = Mathf.Sqrt(delta.x * delta.x + delta.y * delta.y + delta.z * delta.z);
			if (dist > 0f)
			{
				bee.velocity += delta * (beeSpawner.teamAttraction * deltaTime / dist);
			}

			Bee repellentFriend = beeSpawner.GetRandomAlly(data.team);
			delta = repellentFriend.position - bee.position;
			dist = Mathf.Sqrt(delta.x * delta.x + delta.y * delta.y + delta.z * delta.z);
			if (dist > 0f)
			{
				bee.velocity -= delta * (beeSpawner.teamRepulsion * deltaTime / dist);
			}

			if (bee.enemyTarget == null)
			{
				var enemyBee = beeSpawner.GetRandomEnemy(bee.team);
				if (enemyBee != null)
				{
					bee.enemyTarget = enemyBee;
				}
			}
			else if (bee.enemyTarget != null)
			{
				if (bee.enemyTarget.dead)
				{
					bee.enemyTarget = null;
				}
				else
				{
					delta = bee.enemyTarget.position - bee.position;
					float sqrDist = delta.x * delta.x + delta.y * delta.y + delta.z * delta.z;
					if (sqrDist > beeSpawner.attackDistance * beeSpawner.attackDistance)
					{
						bee.velocity += delta * (beeSpawner.chaseForce * deltaTime / Mathf.Sqrt(sqrDist));
					}
					else
					{
						bee.isAttacking = true;
						bee.velocity += delta * (beeSpawner.attackForce * deltaTime / Mathf.Sqrt(sqrDist));
						if (sqrDist < beeSpawner.hitDistance * beeSpawner.hitDistance)
						{
							//ParticleManager.SpawnParticle(bee.enemyTarget.position, ParticleType.Blood, bee.velocity * .35f, 2f, 6);
							bee.enemyTarget.dead = true;
							bee.enemyTarget.velocity *= .5f;
							bee.enemyTarget = null;
						}
					}
				}
			}			
			bee.direction = Vector3.Lerp(bee.direction, bee.velocity.normalized, deltaTime * 4);
		}
		else
		{
			
			bee.velocity.y += Field.gravity * deltaTime;
			bee.deathTimer -= deltaTime / 10f;
			if (bee.deathTimer < 0f)
			{
				beeSpawner.DeleteBee(this);
			}
		}
		bee.position += deltaTime * bee.velocity;


		if (Mathf.Abs(bee.position.x) > Field.size.x * .5f)
		{
			bee.position.x = (Field.size.x * .5f) * Mathf.Sign(bee.position.x);
			bee.velocity.x *= -.5f;
			bee.velocity.y *= .8f;
			bee.velocity.z *= .8f;
		}
		if (Mathf.Abs(bee.position.z) > Field.size.z * .5f)
		{
			bee.position.z = (Field.size.z * .5f) * Mathf.Sign(bee.position.z);
			bee.velocity.z *= -.5f;
			bee.velocity.x *= .8f;
			bee.velocity.y *= .8f;
		}
		float resourceModifier = 0f;
		if (bee.isHoldingResource)
		{
			resourceModifier = ResourceManager.instance.resourceSize;
		}
		if (Mathf.Abs(bee.position.y) > Field.size.y * .5f - resourceModifier)
		{
			bee.position.y = (Field.size.y * .5f - resourceModifier) * Mathf.Sign(bee.position.y);
			bee.velocity.y *= -.5f;
			bee.velocity.z *= .8f;
			bee.velocity.x *= .8f;
		}
		transform.localScale = new Vector3(bee.size, bee.size, bee.size);
		transform.SetPositionAndRotation(bee.position, Quaternion.LookRotation(bee.direction));

	}
}
