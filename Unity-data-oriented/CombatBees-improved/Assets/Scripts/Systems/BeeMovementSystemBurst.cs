using Unity.Burst;
using static Unity.Mathematics.math;
using UnityEngine;
using Random = UnityEngine.Random;
using Unity.Mathematics;

[BurstCompile]
public static class BeeMovementSystemBurst
{
    public unsafe static void Run(float deltaTime)
    {
        var movements = DataBurst.Team1BeeMovements;
        UpdateMovements(DataBurst.AliveCount[0], (MovementBurst*)movements.GetPtr(), (float3*)DataBurst.BeeDirections[0].GetPtr(), deltaTime);
      
        movements = DataBurst.Team2BeeMovements;
        UpdateMovements(DataBurst.AliveCount[1], (MovementBurst*)movements.GetPtr(), (float3*)DataBurst.BeeDirections[1].GetPtr(), deltaTime);

    }


    [BurstCompile]
    static unsafe void UpdateMovements(int aliveBeesCount, MovementBurst* movements, float3* directions, float deltaTime)
    {

        for (int i = 0; i < aliveBeesCount; i++)
        {
            int beeIndex = i;
            var movement = movements[beeIndex];
            var velocity = movement.Velocity;

            float3 randomVector;
            randomVector.x = Random.value * 2.0f - 1.0f;
            randomVector.y = Random.value * 2.0f - 1.0f;
            randomVector.z = Random.value * 2.0f - 1.0f;

            velocity += randomVector * (Data.flightJitter * deltaTime);
            velocity *= (1f - Data.damping * deltaTime);

            //Move towards random ally
            int allyIndex = Random.Range(0, aliveBeesCount);
            var allyMovement = movements[allyIndex];
            float3 delta = allyMovement.Position - movement.Position;
            float dist = Mathf.Sqrt(delta.x * delta.x + delta.y * delta.y + delta.z * delta.z);
            dist = Mathf.Max(0.01f, dist);
            velocity += delta * (Data.teamAttraction * deltaTime / dist);

            //Move away from random ally
            allyIndex = Random.Range(0, aliveBeesCount);
            allyMovement = movements[allyIndex];
            delta = allyMovement.Position - movement.Position;
            dist = Mathf.Sqrt(delta.x * delta.x + delta.y * delta.y + delta.z * delta.z);
            dist = Mathf.Max(0.01f, dist);
            velocity -= delta * (Data.teamRepulsion * deltaTime / dist);

            movement.Velocity = velocity;
            movements[beeIndex] = movement;

            var direction = directions[beeIndex];
            direction = lerp(direction, normalize(movement.Velocity), deltaTime * 4);
            directions[beeIndex] = direction;

        }
    }

}