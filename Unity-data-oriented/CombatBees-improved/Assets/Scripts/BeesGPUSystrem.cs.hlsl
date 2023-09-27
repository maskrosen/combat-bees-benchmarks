//
// This file was automatically generated. Please don't edit by hand. Execute Editor command [ Edit > Rendering > Generate Shader Includes ] instead
//

#ifndef BEESGPUSYSTREM_CS_HLSL
#define BEESGPUSYSTREM_CS_HLSL
// Generated from BeesGPUSystrem+BeesConstantData
// PackingRules = Exact
CBUFFER_START(BeesConstantData)
    float4 team0Color; // x: r y: g z: b w: a 
    float4 team1Color; // x: r y: g z: b w: a 
    float minBeeSize;
    float maxBeeSize;
    float aggression;
    float flightJitter;
    float teamAttraction;
    float teamRepulsion;
    float damping;
    float chaseForce;
    float carryForce;
    float grabDistance;
    float attackDistance;
    float attackForce;
    float3 team0SpawnPosition;
    float hitDistance;
    float3 team1SpawnPosition;
    int startBeeCount;
    float deadTimeout;
    float _padding0;
    float _padding1;
    float _padding2;
CBUFFER_END

// Generated from BeesGPUSystrem+PackedBeeData
// PackingRules = Exact
struct PackedBeeData
{
    uint4 packedBeeData;
};

// Generated from BeesGPUSystrem+BeeData
// PackingRules = Exact
struct BeeData
{
    float3 position;
    float3 velocity;
    uint isAttacking;
    uint teamIndex;
    uint enemyTargetIndex;
};


#endif
