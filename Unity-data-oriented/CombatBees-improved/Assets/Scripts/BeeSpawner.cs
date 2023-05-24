using System.Collections.Generic;
using UnityEngine;

public class BeeSpawner : MonoBehaviour
{
	public GameObject beePrefab;
	public Color[] teamColors;
	public float minBeeSize = 0.25f;
	public float maxBeeSize = 0.5f;
	[Space(10)]
	[Range(0f, 1f)]
	public float aggression = 1;
	public float flightJitter = 200;
	public float teamAttraction = 5;
	public float teamRepulsion = 4;
	[Range(0f, 1f)]
	public float damping = 0.9f;
	public float chaseForce = 50;
	public float carryForce;
	public float grabDistance;
	public float attackDistance = 4;
	public float attackForce = 500;
	public float hitDistance = 0.5f;
	[Space(10)]
	public int startBeeCount;

	public Material team1Mat;
	public Material team2Mat;
	public List<BeeLogic>[] teamsOfBees;
	public static BeeSpawner instance;

	// Start is called before the first frame update
	void Start()
    {
		teamsOfBees = new List<BeeLogic>[] { new List<BeeLogic>(startBeeCount/2), new List<BeeLogic>(startBeeCount/2) };
		team1Mat.color = teamColors[0];
		team2Mat.color = teamColors[1];
		instance = this;
	}

    // Update is called once per frame
    void Update()
    {
		while (teamsOfBees[0].Count < startBeeCount / 2)
		{
			SpawnBee(0);
		}
		while (teamsOfBees[1].Count < startBeeCount / 2)
		{
			SpawnBee(1);
		}
	}

	void SpawnBee(int teamIndex)
    {
		var newBee = Instantiate(beePrefab);
		var beeLogic = newBee.GetComponent<BeeLogic>();
		Vector3 pos = Vector3.right * (-Field.size.x * .4f + Field.size.x * .8f * teamIndex);
		beeLogic.Init(pos, teamIndex, Random.Range(minBeeSize, maxBeeSize), this);
		teamsOfBees[teamIndex].Add(beeLogic);
		var r = newBee.GetComponentInChildren<MeshRenderer>();
		r.sharedMaterial = teamIndex == 0 ? team1Mat : team2Mat;
    }

	public Bee GetRandomAlly(int teamIndex)
    {
		List<BeeLogic> allies = teamsOfBees[teamIndex];
		return allies[Random.Range(0, allies.Count)].data;
	}

	public Bee GetRandomEnemy(int teamIndex)
	{
		List<BeeLogic> enemies = teamsOfBees[1 - teamIndex];
		if(enemies.Count == 0)
        {
			return null;
        }
		return enemies[Random.Range(0, enemies.Count)].data;
	}

	public void DeleteBee(BeeLogic bee)
    {
		var team = teamsOfBees[bee.data.team];
		team.Remove(bee);
		Destroy(bee);
    }

}


