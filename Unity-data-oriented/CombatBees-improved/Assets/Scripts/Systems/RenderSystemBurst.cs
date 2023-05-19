using System.Collections.Generic;
using Unity.Collections;
using UnityEngine;

public static class RenderSystemBurst
{

    static readonly Matrix4x4[] FullBatch = new Matrix4x4[DataBurst.beesPerBatch];
    static readonly List<Matrix4x4> RestBatch = new List<Matrix4x4>(DataBurst.beesPerBatch);
    static readonly Vector4[] FullBatchColors = new Vector4[DataBurst.beesPerBatch];
    static readonly List<Vector4> RestBatchColors = new List<Vector4>(DataBurst.beesPerBatch);

    public static void Run(Mesh mesh, Material[] materials, MaterialPropertyBlock matProps)
    {
        int team1ActiveBees = DataBurst.AliveCount[0] + DataBurst.DeadCount[0];
        int numberOfBatches = team1ActiveBees / DataBurst.beesPerBatch;
        int restNumber = team1ActiveBees % DataBurst.beesPerBatch;
        var movements = DataBurst.Team1BeeMovements;
        var sizes = DataBurst.Team1Size;
        int teamIndex = 0;
        RenderTeam(numberOfBatches, restNumber, sizes, movements, matProps, teamIndex, mesh, materials);

        int team2ActiveBees = DataBurst.AliveCount[1] + DataBurst.DeadCount[1];
        numberOfBatches = team2ActiveBees / DataBurst.beesPerBatch;
        restNumber = team2ActiveBees % DataBurst.beesPerBatch;
        movements = DataBurst.Team2BeeMovements;
        sizes = DataBurst.Team2Size;
        teamIndex = 1;
        RenderTeam(numberOfBatches, restNumber, sizes, movements, matProps, teamIndex, mesh, materials);
    }

    static void RenderTeam(int numberOfBatches, int restNumber, NativeArray<float> sizes, NativeArray<MovementBurst> movements, MaterialPropertyBlock matProps, int teamIndex, Mesh mesh, Material[] materials)
    {
        var fullBatch = FullBatch;
        var restBatch = RestBatch;
        var fullBatchColors = FullBatchColors;
        var restBatchColors = RestBatchColors;
        restBatch.Clear();
        restBatchColors.Clear();
        var directions = DataBurst.BeeDirections[teamIndex];

        var material = materials[teamIndex];

        int beeIndex = 0;
        for (int i = 0; i < numberOfBatches; i++)
        {
            for (int j = 0; j < fullBatch.Length; j++)
            {
                var direction = directions[beeIndex];
                var rotation = Quaternion.LookRotation(direction);
                var size = sizes[beeIndex];
                var scale = Vector3.one * size;
                var movement = movements[beeIndex];
                fullBatch[j] = Matrix4x4.TRS(movement.Position, rotation, scale);
                beeIndex++;
            }
            matProps.SetVectorArray("_Color", fullBatchColors);
            Graphics.DrawMeshInstanced(mesh, 0, material, fullBatch, DataBurst.beesPerBatch, matProps);
        }
        for (int i = 0; i < restNumber; i++)
        {
            var direction = directions[beeIndex];
            var rotation = Quaternion.LookRotation(direction);
            var size = sizes[beeIndex];
            var scale = Vector3.one * size;
            var movement = movements[beeIndex];
            restBatch.Add(Matrix4x4.TRS(movement.Position, rotation, scale));
            beeIndex++;
        }
        matProps.SetVectorArray("_Color", restBatchColors);
        Graphics.DrawMeshInstanced(mesh, 0, material, restBatch, matProps);

    }

}