#ifndef STRUCTS_H
#define STRUCTS_H

#include "taskRunner.h"

typedef struct Movement
{
	Vector3 position;
	Vector3 velocity;
}Movement;

typedef struct UpdateMovementData
{
	TaskData taskData;
	Movement* movements;
	Vector3* directions;
	int startIndex;
	int count;
	int* aliveBeesCount;
	float* deltaTime;
}UpdateMovementData;

typedef struct SpawnBeesData
{
	TaskData taskData;
	int* aliveBeesCount;
	int* deadBeesCount;
	int teamIndex;
	int threadCount;
	
}SpawnBeesData;

#endif // !STRUCTS_H
