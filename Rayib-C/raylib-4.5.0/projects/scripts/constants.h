#ifndef CONSTANTS_H
#define CONSTANTS_H


#define MaxNumberOfBeesPerTeam 50000
#define MAX_NUMBER_OF_BITS (MaxNumberOfBeesPerTeam / 64 + 1) 
#define MaxNumberOfBees MaxNumberOfBeesPerTeam 2;
#define flightJitter 200
#define damping 0.9f
#define teamAttraction 5
#define teamRepulsion 4
#define beesPerBatch 1023
#define beeStartCount 100000
#define minBeeSize 0.25f
#define maxBeeSize 0.5f
#define attackDistance 4
#define chaseForce 50
#define attackForce 500
#define hitDistance 0.5f
#define GRAVITY -20.0f

#endif // !CONSTANTS_H