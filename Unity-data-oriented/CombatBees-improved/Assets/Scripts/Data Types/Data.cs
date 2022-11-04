using System;
using System.Collections.Generic;
using UnityEngine;

public static class Data
{
    public const int MaxNumberOfBeesPerTeam = 15000;
    public const int MaxNumberOfBees = MaxNumberOfBeesPerTeam * 2;
    public const float flightJitter = 200;
    public const float damping = 0.9f;
    public const float teamAttraction = 5;
    public const float teamRepulsion = 4;
    public const int beesPerBatch = 1023;
    public const int beeStartCount = 20000;
    public const float minBeeSize = 0.25f;
    public const float maxBeeSize = 0.5f;
    public const float attackDistance = 4;
    public const float chaseForce = 50;
    public const float attackForce = 500;
    public const float hitDistance = 0.5f;

    public static void Init()
    {
        //BeePositions.Clear();
        //BeeVelocities.Clear();
        Team1BeeMovements.Clear();
        Team1BeeDirections.Clear();
        Team1Size.Clear();
        Array.Fill(Team1BeeTargets, -1);
        Team1DeadTimers.Clear();

        Team2BeeMovements.Clear();
        Team2BeeDirections.Clear();
        Team2Size.Clear();
        Array.Fill(Team2BeeTargets, -1);
        Team2DeadTimers.Clear();

        //Team1AliveBees.Clear();
        //Team1DeadBees.Clear();
        //Team1InactiveBees.Clear();
        Team1HasEnemyTarget.Clear();
        //Team2AliveBees.Clear();
        //Team2DeadBees.Clear();
        //Team2InactiveBees.Clear();
        Team2HasEnemyTarget.Clear();

        FullBatch.Clear();
        RestBatch.Clear();

       /* Team1HasTarget = new(MaxNumberOfBeesPerTeam);
        Team2HasTarget = new(MaxNumberOfBeesPerTeam);
        Team1NoTarget = new(MaxNumberOfBeesPerTeam);
        Team2NoTarget = new(MaxNumberOfBeesPerTeam);
        Team1Dead = new(MaxNumberOfBeesPerTeam);
        Team2Dead = new(MaxNumberOfBeesPerTeam);*/


    }

    //public static readonly Vector3[] BeePositions = new Vector3[MaxNumberOfBees];
    //public static readonly Vector3[] BeeVelocities = new Vector3[MaxNumberOfBees];

    //The index in these arrays represent a bee.
    //The order of the bees in the arrays are sorted in alive -> dead -> inactive, always

    public static readonly Movement[] Team1BeeMovements = new Movement[MaxNumberOfBeesPerTeam];
    public static readonly Vector3[] Team1BeeDirections = new Vector3[MaxNumberOfBeesPerTeam];
    public static readonly float[] Team1Size = new float[MaxNumberOfBeesPerTeam];
    public static readonly int[] Team1BeeTargets = new int[MaxNumberOfBeesPerTeam];
    public static readonly float[] Team1DeadTimers = new float[MaxNumberOfBeesPerTeam];

    public static readonly Movement[] Team2BeeMovements = new Movement[MaxNumberOfBeesPerTeam];
    public static readonly Vector3[] Team2BeeDirections = new Vector3[MaxNumberOfBeesPerTeam];
    public static readonly float[] Team2Size = new float[MaxNumberOfBeesPerTeam];
    public static readonly int[] Team2BeeTargets = new int[MaxNumberOfBeesPerTeam];
    public static readonly float[] Team2DeadTimers = new float[MaxNumberOfBeesPerTeam];

    public static readonly Movement[][] BeeMovements = new Movement[][] { Team1BeeMovements, Team2BeeMovements };
    public static readonly Vector3[][] BeeDirections = new Vector3[][] { Team1BeeDirections, Team2BeeDirections };
    public static readonly float[][] BeeSize = new float[][] { Team1Size, Team2Size };
    public static readonly float[][] DeadTimers = new float[][] { Team1DeadTimers, Team2DeadTimers };
    public static readonly int[][] BeeTargets = new int[][] { Team1BeeTargets, Team2BeeTargets };

    public static readonly int[] AliveCount = new int[2];
    public static readonly int[] DeadCount = new int[2];

    //public static readonly StateList Team1AliveBees = new StateList(MaxNumberOfBeesPerTeam);
    //public static readonly StateList Team1DeadBees = new StateList(MaxNumberOfBeesPerTeam);
    //public static readonly StateList Team1InactiveBees = new StateList(MaxNumberOfBeesPerTeam);
    public static readonly StateList Team1HasNoTarget = new StateList(MaxNumberOfBeesPerTeam);
    public static readonly StateList Team1HasEnemyTarget = new StateList(MaxNumberOfBeesPerTeam);

    //public static readonly StateList Team2AliveBees = new StateList(MaxNumberOfBeesPerTeam);
    //public static readonly StateList Team2DeadBees = new StateList(MaxNumberOfBeesPerTeam);
    //public static readonly StateList Team2InactiveBees = new StateList(MaxNumberOfBeesPerTeam);
    public static readonly StateList Team2HasNoTarget = new StateList(MaxNumberOfBeesPerTeam);
    public static readonly StateList Team2HasEnemyTarget = new StateList(MaxNumberOfBeesPerTeam);

    //public static readonly StateList[] AliveBees = { Team1AliveBees , Team2AliveBees };
    //public static readonly StateList[] DeadBees = { Team1DeadBees , Team2DeadBees };
    //public static readonly StateList[] InactiveBees = { Team1InactiveBees , Team2InactiveBees };
    public static readonly StateList[] HasNoTarget = { Team1HasNoTarget , Team2HasNoTarget };
    public static readonly StateList[] HasEnemyTarget = { Team1HasEnemyTarget , Team2HasEnemyTarget };

    public static readonly Vector3 Team1BeeSpawnPos = Vector3.right * (-Field.size.x * .4f + Field.size.x * .8f * 0);
    public static readonly Vector3 Team2BeeSpawnPos = Vector3.right * (-Field.size.x * .4f + Field.size.x * .8f * 1);

    public static readonly Vector3[] BeeSpawnPos = { Team1BeeSpawnPos, Team2BeeSpawnPos };
    /*
    public static AliveHasTarget Team1HasTarget;
    public static AliveHasTarget Team2HasTarget;
    public static AliveNoTarget Team1NoTarget;
    public static AliveNoTarget Team2NoTarget;
    public static Dead Team1Dead;
    public static Dead Team2Dead;

    public static readonly AliveHasTarget[] AliveHasTargets = { Team1HasTarget, Team2HasTarget};
    public static readonly AliveNoTarget[] AliveNoTargets = { Team1NoTarget, Team2NoTarget};
    public static readonly Dead[] Deads = { Team1Dead, Team2Dead};*/

    //Render data

    public static readonly Matrix4x4[] FullBatch = new Matrix4x4[beesPerBatch];
    public static readonly List<Matrix4x4> RestBatch = new List<Matrix4x4>(beesPerBatch);
    public static readonly Vector4[] FullBatchColors = new Vector4[beesPerBatch];
    public static readonly List<Vector4> RestBatchColors = new List<Vector4>(beesPerBatch);

}
