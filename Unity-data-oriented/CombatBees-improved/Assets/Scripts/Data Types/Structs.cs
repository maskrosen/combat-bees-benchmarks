using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;

public struct Movement
{
    public Vector3 Position;
    public Vector3 Velocity;
}

public struct AliveHasTarget
{
    public AliveHasTarget(int numberOfBees)
    {
        Movements = new Movement[numberOfBees];
        Directions = new Vector3[numberOfBees];
        Size = new float[numberOfBees];
        Targets = new int[numberOfBees];
        Count = 0;
    }
    public readonly Movement[] Movements;
    public readonly Vector3[] Directions;
    public readonly float[] Size;
    public readonly int[] Targets;
    public int Count;
}

public struct AliveNoTarget
{
    public AliveNoTarget(int numberOfBees)
    {
        Movements = new Movement[numberOfBees];
        Directions = new Vector3[numberOfBees];
        Size = new float[numberOfBees];
        Count = 0;
    }
    public readonly Movement[] Movements;
    public readonly Vector3[] Directions;
    public readonly float[] Size;
    public int Count;
}

public struct Dead
{
    public Dead(int numberOfBees)
    {
        Movements = new Movement[numberOfBees];
        Directions = new Vector3[numberOfBees];
        Size = new float[numberOfBees];
        DeadTimers = new float[numberOfBees];
        Count = 0;
    }
    public readonly Movement[] Movements;
    public readonly Vector3[] Directions;
    public readonly float[] Size;
    public readonly float[] DeadTimers;
    public int Count;
}


