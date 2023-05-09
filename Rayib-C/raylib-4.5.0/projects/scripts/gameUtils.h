#ifndef GAME_UTILS_H
#define GAME_UTILS_H

#include "raylib.h"
#include "raymath.h"

#define max(a,b) (((a) > (b)) ? (a) : (b))
#define min(a,b) (((a) < (b)) ? (a) : (b))

Mesh GenMeshDoubleSidedQuad(float width, float height);
float GetRandomFloat();
float GetRandomFloatRange(float min, float max);
void DrawMeshInstancedNoAlloc(Mesh mesh, Material material, float16* instanceTransforms, int instances);
Vector3 RandomPointInSphere(float radius);
int GetLargeRandomValue(int min, int max);
float signf(float v);

#endif