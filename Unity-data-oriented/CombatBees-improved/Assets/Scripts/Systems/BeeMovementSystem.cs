using System.Collections.Generic;
using UnityEngine;

public static class BeeMovementSystem
{
    public static void Run(float deltaTime)
    {
        var aliveBees = Data.Team1AliveBees;
        var movements = Data.Team1BeeMovements;
        UpdateMovements(aliveBees, movements, deltaTime);
        aliveBees = Data.Team2AliveBees;
        movements = Data.Team2BeeMovements;
        UpdateMovements(aliveBees, movements, deltaTime);

    }

    static void UpdateMovements(StateList aliveBees, Movement[] movements, float deltaTime)
    {
        for (int i = 0; i < aliveBees.Count; i++)
        {
            int beeIndex = aliveBees[i];
            var movement = movements[beeIndex];
            var velocity = movement.Velocity;
            velocity += Random.insideUnitSphere * (Data.flightJitter * deltaTime);
            velocity *= (1f - Data.damping * deltaTime);

            //Move towards random ally
            int allyIndex = Random.Range(0, aliveBees.Count);
            var allyMovement = movements[allyIndex];
            Vector3 delta = allyMovement.Position - movement.Position;
            float dist = Mathf.Sqrt(delta.x * delta.x + delta.y * delta.y + delta.z * delta.z);
            dist = Mathf.Max(0.01f, dist);
            velocity += delta * (Data.teamAttraction * deltaTime / dist);

            //Move away from random ally
            allyIndex = Random.Range(0, aliveBees.Count);
            allyMovement = movements[allyIndex];
            delta = allyMovement.Position - movement.Position;
            dist = Mathf.Sqrt(delta.x * delta.x + delta.y * delta.y + delta.z * delta.z);
            dist = Mathf.Max(0.01f, dist);
            velocity -= delta * (Data.teamRepulsion * deltaTime / dist);

            //Move away from edges of box
           /* var beePos = movement.Position;
            var posY = Mathf.Max(0, beePos.y);
            posY *= posY * posY;
            var negY = Mathf.Min(0, beePos.y);
            negY *= negY * negY;
            var posX = Mathf.Max(0, beePos.x);
            posX *= posX * posX;
            var negX = Mathf.Min(0, beePos.x);
            negX *= negX * negX;
            var posZ = Mathf.Max(0, beePos.z);
            posZ *= posZ * posZ;
            var negZ = Mathf.Min(0, beePos.z);
            negZ *= negZ * negZ;

            Vector3 push = new();

            //-1 below to avoid needing abs on negative number
            push += posY * Vector3.down;
            push += negY * Vector3.up * -1;  
            push += posX * Vector3.left;
            push += negX * Vector3.right * -1;
            push += posZ * Vector3.back;
            push += negZ * Vector3.forward * -1;
            push *= 0.03f;
            push *= deltaTime;


            velocity += push;
            */
            movement.Velocity = velocity;
            movements[beeIndex] = movement;

        }
    }

}