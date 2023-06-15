#pragma once

#include "Assets/Shaders/BeesCommon.hlsl"

uint _StartInstance;
StructuredBuffer<PackedBeeData> _Bees;

void GetStartInstance_float(out float StartInstance)
{
    StartInstance = _StartInstance;
}

void GetBeePositionAndVelocity_float(float instanceID, out float3 position, out float3 velocity)
{
    PackedBeeData p = _Bees[uint(instanceID)];

    UnpackPositionAndVelocity(p.packedBeeData.xyz, position, velocity);
}

void GetRotationMatrixFromDirection_float(float3 direction, out float3x3 rotationMatrix)
{
    float3 forward = direction; // or pre-normalize it in c#
    float3 right = normalize(cross(forward, float3(0,1,0)));
    if (any(isnan(right)))
    {
        rotationMatrix = half3x3(1, 0, 0, 0, 1, 0, 0, 0, 1);
        return;
    }
    float3 up = cross(right, forward);
    rotationMatrix = float3x3(forward, up, right); // special order for quad
}