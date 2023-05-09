#include "data.h"
#include "raymath.h"


Movement Team1BeeMovements[MaxNumberOfBeesPerTeam];
Vector3 Team1BeeDirections[MaxNumberOfBeesPerTeam];
float Team1Size[MaxNumberOfBeesPerTeam];
int Team1BeeTargets[MaxNumberOfBeesPerTeam];
float Team1DeadTimers[MaxNumberOfBeesPerTeam];

Movement Team2BeeMovements[MaxNumberOfBeesPerTeam];
Vector3 Team2BeeDirections[MaxNumberOfBeesPerTeam];
float Team2Size[MaxNumberOfBeesPerTeam];
int Team2BeeTargets[MaxNumberOfBeesPerTeam];
float Team2DeadTimers[MaxNumberOfBeesPerTeam];

Movement* BeeMovements[2] = {Team1BeeMovements, Team2BeeMovements};
Vector3* BeeDirections[2] = {Team1BeeDirections, Team2BeeDirections};
float* BeeSize[2] = {Team1Size, Team2Size};
float* DeadTimers[2] = {Team1DeadTimers, Team2DeadTimers};
int* BeeTargets[2] = {Team1BeeTargets, Team2BeeTargets};

int AliveCount[2];
int DeadCount[2];

__int64 team1HasTargets[MAX_NUMBER_OF_BITS];
__int64 team2HasTargets[MAX_NUMBER_OF_BITS];

__int64 team1HasNoTargets[MAX_NUMBER_OF_BITS];
__int64 team2HasNoTargets[MAX_NUMBER_OF_BITS];

__int64* teamHasTargets[2] = { team1HasTargets , team2HasTargets };
__int64* teamHasNoTargets[2] = { team1HasNoTargets , team2HasNoTargets };

Vector3 BeeSpawnPos[2];

float16 team1Transforms[MaxNumberOfBeesPerTeam];
float16 team2Transforms[MaxNumberOfBeesPerTeam];

Mesh beeMesh;
Material yellowMat;
Material blueMat;

void Init()
{
	BeeSpawnPos[0] = Team1BeeSpawnPos;
	BeeSpawnPos[1] = Team2BeeSpawnPos;
}