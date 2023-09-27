#pragma once

#include "Assets/Scripts/BeesGPUSystrem.cs.hlsl"

float _UpdateTime;
float _DeltaTime;

// Integer hash functions from https://www.shadertoy.com/view/llGSzw
float hash1( uint n ) 
{
    // integer hash copied from Hugo Elias
	n = (n << 13U) ^ n;
    n = n * (n * n * 15731U + 789221U) + 1376312589U;
    return float( n & uint(0x7fffffffU))/float(0x7fffffff);
}

// Return values between 0 and 1
float3 hash3( uint n ) 
{
    // integer hash copied from Hugo Elias
	n = (n << 13U) ^ n;
    n = n * (n * n * 15731U + 789221U) + 1376312589U;
    uint3 k = n * uint3(n,n*16807U,n*48271U);
    return saturate(float3( k & 0x7fffffffU)/float(0x7fffffff));
}

// Not perfect but good enough for the random movement of bees
float3 RandomInsideUnitSphere(uint seed)
{
    float3 r = hash3(seed) * 2.f - 1.f;
    float d = r.x * r.x + r.y * r.y + r.z * r.z;

    // Bring back random point in cube to surface of sphere
    if (d > 1)
        r = r / sqrt(d);
 
    return r;
}

// Note: this can return dead bees, but I think it's like that in the original code
// Random between 0 and startBeeCount
int GetRandomBee(int teamIndex, int beeIndex)
{
    // TODO: check if this random is good with high startBeeCount values
    int halfBeeCount = (uint)startBeeCount / 2; 
    int randomBeeIndex = (saturate(hash1((uint)(beeIndex + _UpdateTime * 743))) * (float)halfBeeCount);

    if (teamIndex == 0)
        return randomBeeIndex;
    else
        return randomBeeIndex + halfBeeCount;
}

uint3 PackPositionAndVelocity(float3 position, float3 velocity)
{
    uint3 p = f32tof16(position);
    uint3 v = f32tof16(velocity);

    return uint3(
        p.x | (p.y << 16),
        p.z | (v.x << 16),
        v.y | (v.z << 16)
    );
}

void UnpackPositionAndVelocity(uint3 packed, out float3 position, out float3 velocity)
{
    uint3 p = uint3(packed.x, packed.x >> 16, packed.y);
    uint3 v = uint3(packed.y >> 16, packed.z, packed.z >> 16);

    position = f16tof32(p);
    velocity = f16tof32(v);
}

PackedBeeData PackBeeData(BeeData data)
{
    PackedBeeData packed;
    packed.packedBeeData.xyz = PackPositionAndVelocity(data.position, data.velocity);
    packed.packedBeeData.w = (uint(data.isAttacking & 1) << 31) | (uint(data.teamIndex & 1) << 30) | (data.enemyTargetIndex & 0x3FFFFFFF);
    return packed;
}

BeeData UnpackBeeData(PackedBeeData packed)
{
    BeeData bee;
    uint otherData = packed.packedBeeData.w; 
    bee.isAttacking = (otherData & 0x80000000) != 0;
    bee.teamIndex = (otherData & 0x40000000) != 0;
    bee.enemyTargetIndex = otherData & 0x3FFFFFFF;
    if (bee.enemyTargetIndex == 0x3FFFFFFF)
        bee.enemyTargetIndex = -1;
    UnpackPositionAndVelocity(packed.packedBeeData.xyz, bee.position, bee.velocity);
    return bee;
}