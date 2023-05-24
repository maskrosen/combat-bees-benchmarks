using System;
using System.Collections.Generic;
using UnityEngine;
using Unity.Collections;
using Unity.Mathematics;

public static class DataBurst
{
    public const int MaxNumberOfBeesPerTeam = 50000;
    public const int MaxNumberOfBees = MaxNumberOfBeesPerTeam * 2;
    public const int MaxNumberOfBits = MaxNumberOfBeesPerTeam / 64 + 1;
    public const float flightJitter = 200;
    public const float damping = 0.9f;
    public const float teamAttraction = 5;
    public const float teamRepulsion = 4;
    public const int beesPerBatch = 1023;
    public const int beeStartCount = 100000;
    public const float minBeeSize = 0.25f;
    public const float maxBeeSize = 0.5f;
    public const float attackDistance = 4;
    public const float chaseForce = 50;
    public const float attackForce = 500;
    public const float hitDistance = 0.5f;

    public static void Init()
    {
        Team1BeeMovements = new NativeArray<MovementBurst>(MaxNumberOfBeesPerTeam, Allocator.Persistent);
        Team2BeeMovements = new NativeArray<MovementBurst>(MaxNumberOfBeesPerTeam, Allocator.Persistent);
        BeeMovements = new NativeArray<MovementBurst>[] { Team1BeeMovements, Team2BeeMovements };
        Team2BeeTargets = new NativeArray<int>(MaxNumberOfBeesPerTeam, Allocator.Persistent);
        Team1BeeTargets = new NativeArray<int>(MaxNumberOfBeesPerTeam, Allocator.Persistent);
        BeeTargets = new NativeArray<int>[] { Team1BeeTargets, Team2BeeTargets };

        Team1BeeDirections = new NativeArray<float3>(MaxNumberOfBeesPerTeam, Allocator.Persistent);
        Team2BeeDirections = new NativeArray<float3>(MaxNumberOfBeesPerTeam, Allocator.Persistent);
        BeeDirections = new NativeArray<float3>[] { Team1BeeDirections, Team2BeeDirections }; 

        Team1Size = new NativeArray<float>(MaxNumberOfBeesPerTeam, Allocator.Persistent);
        Team1DeadTimers = new NativeArray<float>(MaxNumberOfBeesPerTeam, Allocator.Persistent);

        Team2Size = new NativeArray<float>(MaxNumberOfBeesPerTeam, Allocator.Persistent);
        Team2DeadTimers = new NativeArray<float>(MaxNumberOfBeesPerTeam, Allocator.Persistent);

        BeeSize = new NativeArray<float>[] { Team1Size, Team2Size };
        DeadTimers = new NativeArray<float>[] { Team1DeadTimers, Team2DeadTimers };

        AliveCount = new NativeArray<int>(2, Allocator.Persistent);
        DeadCount = new NativeArray<int>(2, Allocator.Persistent);      

        BeeSpawnPos = new NativeArray<float3>(2, Allocator.Persistent);
        BeeSpawnPos[0] = Team1BeeSpawnPos;
        BeeSpawnPos[1] = Team2BeeSpawnPos;

        team1HasTargets = new NativeArray<ulong>(MaxNumberOfBits, Allocator.Persistent);
        team2HasTargets = new NativeArray<ulong>(MaxNumberOfBits, Allocator.Persistent);
        team1HasNoTargets = new NativeArray<ulong>(MaxNumberOfBits, Allocator.Persistent);
        team2HasNoTargets = new NativeArray<ulong>(MaxNumberOfBits, Allocator.Persistent);

    }

    //The index in these arrays represent a bee.
    //The order of the bees in the arrays are sorted in alive -> dead -> inactive, always

    public static NativeArray<MovementBurst> Team1BeeMovements;
    public static NativeArray<float3> Team1BeeDirections;
    public static NativeArray<float> Team1Size;
    public static NativeArray<int> Team1BeeTargets;
    public static NativeArray<float> Team1DeadTimers;

    public static NativeArray<MovementBurst> Team2BeeMovements;
    public static NativeArray<float3> Team2BeeDirections;
    public static NativeArray<float> Team2Size;
    public static NativeArray<int> Team2BeeTargets;
    public static NativeArray<float> Team2DeadTimers;

    public static NativeArray<MovementBurst>[] BeeMovements;
    public static NativeArray<float3>[] BeeDirections;
    public static NativeArray<float>[] BeeSize;
    public static NativeArray<float>[] DeadTimers;
    public static NativeArray<int>[] BeeTargets;

    public static NativeArray<int> AliveCount;
    public static NativeArray<int> DeadCount;

    public static readonly float3 FieldSize = new float3(100f, 20f, 30f);
    public static readonly float3 Right = new float3(1.0f, 0f, 0f);

    public static NativeArray<ulong> team1HasTargets;
    public static NativeArray<ulong> team2HasTargets;

    public static NativeArray<ulong> team1HasNoTargets;
    public static NativeArray<ulong> team2HasNoTargets;

    public static readonly float3 Team1BeeSpawnPos = Right * (-FieldSize.x * .4f + FieldSize.x * .8f * 0);
    public static readonly float3 Team2BeeSpawnPos = Right * (-FieldSize.x * .4f + FieldSize.x * .8f * 1);

    public static NativeArray<float3> BeeSpawnPos;

    //Render data


}
