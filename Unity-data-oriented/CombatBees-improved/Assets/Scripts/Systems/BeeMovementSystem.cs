using UnityEngine;
public static class BeeMovementSystem
{
    public static void Run(float deltaTime)
    {
        var movements = Data.Team1BeeMovements;
        UpdateMovements(Data.AliveCount[0], movements, Data.BeeDirections[0], deltaTime);
        movements = Data.Team2BeeMovements;
        UpdateMovements(Data.AliveCount[1], movements, Data.BeeDirections[1], deltaTime);

    }

    static Vector3 GetRandomVectorInCube()
    {
        Vector3 res;
        res.x = Random.value * 2.0f - 1.0f;
        res.y = Random.value * 2.0f - 1.0f;
        res.z = Random.value * 2.0f - 1.0f;
        return res;
    }
    static void UpdateMovements(int aliveBeesCount, Movement[] movements, Vector3[] directions, float deltaTime)
    {
        for (int i = 0; i < aliveBeesCount; i++)
        {
            int beeIndex = i;
            var movement = movements[beeIndex];
            var velocity = movement.Velocity;
            velocity += GetRandomVectorInCube() * (Data.flightJitter * deltaTime);
            velocity *= (1f - Data.damping * deltaTime);

            //Move towards random ally
            int allyIndex = Random.Range(0, aliveBeesCount);
            var allyMovement = movements[allyIndex];
            Vector3 delta = allyMovement.Position - movement.Position;
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
            direction = Vector3.Lerp(direction, movement.Velocity.normalized, deltaTime * 4);
            directions[beeIndex] = direction;

        }
    }

}