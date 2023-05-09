#ifndef DATA_H
#define DATA_H

#include "raylib.h"
#include "structs.h"
#include "constants.h"
#include "raymath.h"


extern Movement Team1BeeMovements[MaxNumberOfBeesPerTeam];
extern Vector3 Team1BeeDirections[MaxNumberOfBeesPerTeam];
extern float Team1Size[MaxNumberOfBeesPerTeam];
extern int Team1BeeTargets[MaxNumberOfBeesPerTeam];
extern float Team1DeadTimers[MaxNumberOfBeesPerTeam];

extern Movement Team2BeeMovements[MaxNumberOfBeesPerTeam];
extern Vector3 Team2BeeDirections[MaxNumberOfBeesPerTeam];
extern float Team2Size[MaxNumberOfBeesPerTeam];
extern int Team2BeeTargets[MaxNumberOfBeesPerTeam];
extern float Team2DeadTimers[MaxNumberOfBeesPerTeam];

extern Movement* BeeMovements[2];
extern Vector3* BeeDirections[2];
extern float* BeeSize[2];
extern float* DeadTimers[2];
extern int* BeeTargets[2];

extern int AliveCount[2];
extern int DeadCount[2];

extern __int64 team1HasTargets[MAX_NUMBER_OF_BITS];
extern __int64 team2HasTargets[MAX_NUMBER_OF_BITS];

extern __int64 team1HasNoTargets[MAX_NUMBER_OF_BITS];
extern __int64 team2HasNoTargets[MAX_NUMBER_OF_BITS];

extern __int64* teamHasTargets[2];
extern __int64* teamHasNoTargets[2];

#define FIELD_WIDTH 100.0f
#define FieldSize (Vector3) { FIELD_WIDTH, 20.0f, 30.0f }
#define Team1BeeSpawnPos (Vector3) { -FIELD_WIDTH * 0.4f, 0.0f, 0.0f }
#define Team2BeeSpawnPos (Vector3) { -FIELD_WIDTH * 0.4f + FIELD_WIDTH * .8f, 0.0f, 0.0f }

extern Vector3 BeeSpawnPos[2];

extern float16 team1Transforms[MaxNumberOfBeesPerTeam];
extern float16 team2Transforms[MaxNumberOfBeesPerTeam];


extern Mesh beeMesh;
extern Material yellowMat;
extern Material blueMat;

void Init();

#endif // !DATA_H
