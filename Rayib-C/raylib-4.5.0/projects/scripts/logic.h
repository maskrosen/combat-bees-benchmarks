#ifndef LOGIC_H
#define LOGIC_H

void SpawnBeesUpdate();
void UpdateMovement(float deltaTime);
void UpdatePositions(float deltaTime);
void UpdateCollisions();
void UpdateTargets();
void UpdateAttack(float deltaTime);
void UpdateDead(float deltaTime);

#endif // !LOGIC_H