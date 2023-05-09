#include "logic.h"
#include "data.h"
#include "raymath.h"
#include "gameUtils.h"
#include "bitMaskUtils.h"
#include <immintrin.h> 


void CopyBeeData(int sourceIndex, int destIndex, int length, int teamIndex)
{
    Movement* movements = BeeMovements[teamIndex];
    Vector3* directions = BeeDirections[teamIndex];
    float* sizes = BeeSize[teamIndex];
    int* targets = BeeTargets[teamIndex];
    float* deadTimers = DeadTimers[teamIndex];

    for (int i = 0; i < length; i++)
    {
        int beeSourceIndex = sourceIndex + i;
        int beeDestIndex = destIndex + i;
        movements[beeDestIndex] = movements[beeSourceIndex];
    }

    for (int i = 0; i < length; i++)
    {
        int beeSourceIndex = sourceIndex + i;
        int beeDestIndex = destIndex + i;
        directions[beeDestIndex] = directions[beeSourceIndex];
    }

    for (int i = 0; i < length; i++)
    {
        int beeSourceIndex = sourceIndex + i;
        int beeDestIndex = destIndex + i;
        sizes[beeDestIndex] = sizes[beeSourceIndex];
    }

    for (int i = 0; i < length; i++)
    {
        int beeSourceIndex = sourceIndex + i;
        int beeDestIndex = destIndex + i;
        targets[beeDestIndex] = targets[beeSourceIndex];
    }

    for (int i = 0; i < length; i++)
    {
        int beeSourceIndex = sourceIndex + i;
        int beeDestIndex = destIndex + i;
        deadTimers[beeDestIndex] = deadTimers[beeSourceIndex];
    }
}

void InitBees(int beeStartIndex, int length, int teamIndex)
{
    Vector3 spawnPos = BeeSpawnPos[teamIndex];
    Movement* movements = BeeMovements[teamIndex];
    float* sizes = BeeSize[teamIndex];
    Vector3* directions = BeeDirections[teamIndex];
    for (int i = 0; i < length; i++)
    {
        int beeIndex = beeStartIndex + i;
        Movement m = { spawnPos, Vector3Zero()};
        sizes[beeIndex] = GetRandomFloatRange(minBeeSize, maxBeeSize);
        movements[beeIndex] = m;
        directions[beeIndex] = (Vector3){1.0f, 0.0f, 0.0f};
        AliveCount[teamIndex]++;
        SetBitTrue(teamHasNoTargets[teamIndex], beeIndex);
        SetBitFalse(teamHasTargets[teamIndex], beeIndex);
    }
}

void SpawnBees(int count, int teamIndex)
{
    int aliveBeesCount = AliveCount[teamIndex];
    int deadBeesStartIndex = aliveBeesCount;
    int deadBeesCount = DeadCount[teamIndex];
    if (deadBeesCount == 0)
    {
        //fast spawns, we don't need to copy any data in this case, just init bees after last current alive bee
        InitBees(deadBeesStartIndex, count, teamIndex);
    }
    else
    {
        //If we have dead bee we need to copy enough dead bees to make room for our new spawned bees in the alive segment
        int numberOfBeesToCopy = min(deadBeesCount, count);
        int destIndex = deadBeesStartIndex + deadBeesCount; //We copy them to the after the end of dead bees
        CopyBeeData(deadBeesStartIndex, destIndex, numberOfBeesToCopy, teamIndex);
        InitBees(deadBeesStartIndex, count, teamIndex);
    }
}

void SpawnBeesUpdate()
{
    int team1BeeCount = AliveCount[0] + DeadCount[0];
    int beesToSpawnTeam1 = beeStartCount / 2 - team1BeeCount;
    if (beesToSpawnTeam1 > 0)
    {
        SpawnBees(beesToSpawnTeam1, 0);
    }

    int team2BeeCount = AliveCount[1] + DeadCount[1];
    int beesToSpawnTeam2 = beeStartCount / 2 - team2BeeCount;
    if (beesToSpawnTeam2 > 0)
    {
        SpawnBees(beesToSpawnTeam2, 1);
    }
}

void UpdateMovements(int aliveBeesCount, Movement* movements, Vector3* directions, float deltaTime)
{
    for (int i = 0; i < aliveBeesCount; i++)
    {
        int beeIndex = i;
        Movement movement = movements[beeIndex];
        Vector3 velocity = movement.velocity;
        velocity = Vector3Add(velocity, Vector3Scale(RandomPointInSphere(1.0f), (flightJitter * deltaTime)));
        velocity = Vector3Scale(velocity, (1.0f - damping * deltaTime));

        //Move towards random ally
        int allyIndex = GetLargeRandomValue(0, aliveBeesCount - 1);
        Movement allyMovement = movements[allyIndex];
        Vector3 delta = Vector3Subtract(allyMovement.position, movement.position);
        float dist = sqrtf(delta.x * delta.x + delta.y * delta.y + delta.z * delta.z);
        dist = max(0.01f, dist);
        velocity = Vector3Add(velocity, Vector3Scale(delta, (teamAttraction * deltaTime / dist)));

        //Move away from random ally
        allyIndex = GetLargeRandomValue(0, aliveBeesCount - 1);
        allyMovement = movements[allyIndex];
        delta = Vector3Subtract(allyMovement.position, movement.position);
        dist = sqrtf(delta.x * delta.x + delta.y * delta.y + delta.z * delta.z);
        dist = max(0.01f, dist);
        velocity = Vector3Subtract(velocity, Vector3Scale(delta, (teamRepulsion * deltaTime / dist)));

        movement.velocity = velocity;
        movements[beeIndex] = movement;

        Vector3 direction = directions[beeIndex];
        direction = Vector3Lerp(direction, Vector3Normalize(movement.velocity), deltaTime * 4);
        directions[beeIndex] = direction;
    }
}

void UpdateMovement(float deltaTime)
{
    Movement* movements = Team1BeeMovements;
    UpdateMovements(AliveCount[0], movements, BeeDirections[0], deltaTime);
    movements = Team2BeeMovements;
    UpdateMovements(AliveCount[1], movements, BeeDirections[1], deltaTime);
}

void UpdatePosition(Movement* movements, int activeBeesCount, float deltaTime)
{
    for (int i = 0; i < activeBeesCount; i++)
    {
        Movement movement = movements[i];
        movement.position = Vector3Add(movement.position, Vector3Scale(movement.velocity, deltaTime));
        movements[i] = movement;
    }
}

void UpdatePositions(float deltaTime)
{
    Movement* movements = Team1BeeMovements;
    int activeBeesCount = AliveCount[0] + DeadCount[0];
    UpdatePosition(movements, activeBeesCount, deltaTime);

    movements = Team2BeeMovements;
    activeBeesCount = AliveCount[1] + DeadCount[1];
    UpdatePosition(movements, activeBeesCount, deltaTime);
}

void CheckCollisions(int aliveCount, int deadCount, Movement* movements)
{
    int activeCount = aliveCount + deadCount;

    for (int i = 0; i < activeCount; i++)
    {
        Movement movement = movements[i];
        if (fabsf(movement.position.x) > FieldSize.x * .5f)
        {
            movement.position.x = (FieldSize.x * .5f) * signf(movement.position.x);
            movement.velocity.x *= -.5f;
            movement.velocity.y *= .8f;
            movement.velocity.z *= .8f;
        }
        if (fabsf(movement.position.z) > FieldSize.z * .5f)
        {
            movement.position.z = (FieldSize.z * .5f) * signf(movement.position.z);
            movement.velocity.z *= -.5f;
            movement.velocity.x *= .8f;
            movement.velocity.y *= .8f;
        }

        if (fabsf(movement.position.y) > FieldSize.y * .5f)
        {
            movement.position.y = (FieldSize.y * .5f) * signf(movement.position.y);
            movement.velocity.y *= -.5f;
            movement.velocity.z *= .8f;
            movement.velocity.x *= .8f;
        }
        movements[i] = movement;
    }
}

void UpdateCollisions()
{
    Movement* movements = Team1BeeMovements;
    CheckCollisions(AliveCount[0], DeadCount[0], movements);

    movements = Team2BeeMovements;
    CheckCollisions(AliveCount[1], DeadCount[1], movements);
}

void GetNewEnemyTargets(__int64* noTargets, int aliveCount, int enemyTeamAliveCount, int* targets, __int64* hasEnemyTarget)
{
    
    for (int i = 0; i < aliveCount / 64 + 1; i++)
    {
        int mask = noTargets[i];
        if (mask == 0)
        {
            continue;
        }
        
        do 
        {
            int nextBitIndex = (int)_tzcnt_u64(mask);
            int newTarget = GetLargeRandomValue(0, enemyTeamAliveCount);
            int beeIndex = i * 64 + nextBitIndex;
            targets[beeIndex] = newTarget;
            SetBitTrue(hasEnemyTarget, beeIndex);
            SetBitFalse(noTargets, beeIndex);
            mask ^= (1ULL << nextBitIndex); //clear bit we just handled

        } while (mask != 0);
    }   
}

void UpdateTargets()
{
    __int64* noTargets = team1HasNoTargets;
    int* targets = Team1BeeTargets;
    __int64* hasEnemyTarget = team1HasTargets;
    GetNewEnemyTargets(noTargets, AliveCount[0], AliveCount[1], targets, hasEnemyTarget);


    noTargets = team2HasNoTargets;
    targets = Team2BeeTargets;
    hasEnemyTarget = team2HasTargets;
    GetNewEnemyTargets(noTargets, AliveCount[1], AliveCount[0], targets, hasEnemyTarget);
}

void KillBee(int beeIndex, int teamIndex)
{
    Movement* movements = BeeMovements[teamIndex];
    Vector3* directions = BeeDirections[teamIndex];
    float* sizes = BeeSize[teamIndex];
    int* targets = BeeTargets[teamIndex];
    float* deadTimers = DeadTimers[teamIndex];

    __int64* hasTargets = teamHasTargets[teamIndex];
    __int64* hasNoTargets = teamHasNoTargets[teamIndex];
    int aliveCount = AliveCount[teamIndex];

    int beeIndex1 = beeIndex;
    int beeIndex2 = aliveCount - 1; //Last alive bee
    AliveCount[teamIndex]--;
    DeadCount[teamIndex]++;   

    CopyBitValue(hasTargets, beeIndex2, beeIndex1);
    CopyBitValue(hasNoTargets, beeIndex2, beeIndex1);
    SetBitFalse(hasTargets, beeIndex2);
    SetBitFalse(hasNoTargets, beeIndex2);

    Movement tempM = movements[beeIndex1];
    tempM.velocity = Vector3Scale(tempM.velocity, .5f);
    movements[beeIndex1] = movements[beeIndex2];
    movements[beeIndex2] = tempM;


    Vector3 tempSD = directions[beeIndex1];
    directions[beeIndex1] = directions[beeIndex2];
    directions[beeIndex2] = tempSD;

    float tempS = sizes[beeIndex1];
    sizes[beeIndex1] = sizes[beeIndex2];
    sizes[beeIndex2] = tempS;

    targets[beeIndex1] = targets[beeIndex2];
    targets[beeIndex2] = -1;

    deadTimers[beeIndex1] = deadTimers[beeIndex2];
    deadTimers[beeIndex2] = 1;
}

void Attack(int teamIndex, int enemyTeamIndex, float deltaTime)
{
    __int64* hasEnemyTarget = teamHasTargets[teamIndex];
    __int64* noTargets = teamHasNoTargets[teamIndex];
    int* targets = BeeTargets[teamIndex];
    Movement* movements = BeeMovements[teamIndex];
    Movement* enemyMovements = BeeMovements[enemyTeamIndex];
    int aliveCount = AliveCount[teamIndex];

    for (int i = 0; i < aliveCount / 64 + 1; i++)
    {
        int mask = hasEnemyTarget[i];
        if (mask == 0)
        {
            continue;
        }

        do
        {
            int nextBitIndex = (int)_tzcnt_u64(mask);
            int beeIndex = i * 64 + nextBitIndex;

            int enemyIndex = targets[beeIndex];
            if (enemyIndex >= AliveCount[enemyTeamIndex])
            {
                //the target is dead
                targets[beeIndex] = -1;
                SetBitFalse(hasEnemyTarget, beeIndex);
                SetBitTrue(noTargets, beeIndex);
                mask ^= (1ULL << nextBitIndex); //clear bit we just handled
                continue;
            }

            Movement movement = movements[beeIndex];
            Movement enemyMovement = enemyMovements[enemyIndex];

            Vector3 delta = Vector3Subtract(enemyMovement.position, movement.position);
            float sqrDist = delta.x * delta.x + delta.y * delta.y + delta.z * delta.z;
            if (sqrDist > attackDistance * attackDistance)
            {
                movement.velocity = Vector3Add(movement.velocity, Vector3Scale(delta, (chaseForce * deltaTime / sqrtf(sqrDist))));
            }
            else
            {
                movement.velocity = Vector3Add(movement.velocity, Vector3Scale(delta, (attackForce * deltaTime / sqrtf(sqrDist))));
                if (sqrDist < hitDistance * hitDistance)
                {
                    KillBee(enemyIndex, enemyTeamIndex);
                    targets[beeIndex] = -1;
                    SetBitFalse(hasEnemyTarget, beeIndex);
                    SetBitTrue(noTargets, beeIndex);
                }
            }
            movements[beeIndex] = movement;

            mask ^= (1ULL << nextBitIndex); //clear bit we just handled

        } while (mask != 0);
    }
}

void UpdateAttack(float deltaTime)
{
    Attack(0, 1, deltaTime);
    Attack(1, 0, deltaTime);    
}

void DeleteBee(int beeIndex, int teamIndex)
{
    Movement* movements = BeeMovements[teamIndex];
    Vector3* directions = BeeDirections[teamIndex];
    float* sizes = BeeSize[teamIndex];
    float* deadTimers = DeadTimers[teamIndex];

    int beeIndex1 = beeIndex;
    int beeIndex2 = AliveCount[teamIndex] + DeadCount[teamIndex] - 1; //Last dead bee
    DeadCount[teamIndex]--;

    movements[beeIndex1] = movements[beeIndex2];
    movements[beeIndex2] = (Movement){0};

    directions[beeIndex1] = directions[beeIndex2];
    directions[beeIndex2] = (Vector3){0};

    sizes[beeIndex1] = sizes[beeIndex2];
    sizes[beeIndex2] = 0.0f;

    deadTimers[beeIndex1] = deadTimers[beeIndex2];
    deadTimers[beeIndex2] = 0;
}

void UpdateDeadTeam(int teamIndex, float deltaTime)
{
    int deadCount = DeadCount[teamIndex];
    int aliveCount = AliveCount[teamIndex];
    Movement* movements = BeeMovements[teamIndex];
    float* deadTimers = DeadTimers[teamIndex];

    for (int i = aliveCount; i < aliveCount + deadCount; i++)
    {
        int beeIndex = i;
        Movement m = movements[beeIndex];
        m.velocity.y += GRAVITY * deltaTime;
        float deadTimer = deadTimers[beeIndex];
        deadTimer -= deltaTime / 10.0f;
        if (deadTimer < 0.0f)
        {
            DeleteBee(beeIndex, teamIndex);
            continue;
        }
        deadTimers[beeIndex] = deadTimer;
        movements[beeIndex] = m;
    }

}

void UpdateDead(float deltaTime)
{
    UpdateDeadTeam(0, deltaTime);
    UpdateDeadTeam(1, deltaTime);
}