using UnityEngine;

public static class RenderSystem
{
    public static void Run(Mesh mesh, Material material, MaterialPropertyBlock matProps, Color[] beeColors)
    {
        int team1ActiveBees = Data.Team1AliveBees.Count + Data.Team1DeadBees.Count;
        int numberOfBatches = team1ActiveBees / Data.beesPerBatch;
        int restNumber = team1ActiveBees % Data.beesPerBatch;
        var movements = Data.Team1BeeMovements;
        var sizes = Data.Team1Size;
        int teamIndex = 0;
        RenderTeam(numberOfBatches, restNumber, sizes, movements, matProps, beeColors, teamIndex, mesh, material);

        int team2ActiveBees = Data.Team2AliveBees.Count + Data.Team2DeadBees.Count;
        numberOfBatches = team2ActiveBees / Data.beesPerBatch;
        restNumber = team2ActiveBees % Data.beesPerBatch;
        movements = Data.Team2BeeMovements;
        sizes = Data.Team2Size;
        teamIndex = 1;
        RenderTeam(numberOfBatches, restNumber, sizes, movements, matProps, beeColors, teamIndex, mesh, material);
    }

    static void RenderTeam(int numberOfBatches, int restNumber, float[] sizes, Movement[] movements, MaterialPropertyBlock matProps, Color[] beeColors, int teamIndex, Mesh mesh, Material material)
    {
        var fullBatch = Data.FullBatch;
        var restBatch = Data.RestBatch;
        var fullBatchColors = Data.FullBatchColors;
        var restBatchColors = Data.RestBatchColors;
        restBatch.Clear();
        restBatchColors.Clear();

        var color = beeColors[teamIndex]; 

        int beeIndex = 0;
        for (int i = 0; i < numberOfBatches; i++)
        {
            for (int j = 0; j < fullBatch.Length; j++)
            {
                var rotation = Quaternion.LookRotation(Vector3.forward);
                var size = sizes[beeIndex];
                var scale = Vector3.one * size;
                var movement = movements[beeIndex];
                fullBatch[j] = Matrix4x4.TRS(movement.Position, rotation, scale);
                fullBatchColors[j] = color;
                beeIndex++;
            }
            matProps.SetVectorArray("_Color", fullBatchColors);
            Graphics.DrawMeshInstanced(mesh, 0, material, fullBatch, Data.beesPerBatch, matProps);
        }
        for (int i = 0; i < restNumber; i++)
        {
            var rotation = Quaternion.LookRotation(Vector3.forward);
            var size = sizes[beeIndex];
            var scale = Vector3.one * size;
            var movement = movements[beeIndex];
            restBatch.Add(Matrix4x4.TRS(movement.Position, rotation, scale));
            restBatchColors.Add(color);
            beeIndex++;
        }
        matProps.SetVectorArray("_Color", restBatchColors);
        Graphics.DrawMeshInstanced(mesh, 0, material, restBatch, matProps);

    }

}