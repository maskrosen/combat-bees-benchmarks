#define PLATFORM_DESKTOP
#include "raylib.h"
#include "logic.h"
#include "data.h"
#include "gameUtils.h"
#include "raymath.h"


#include "taskRunner.h"

#include <process.h>  
#define NOGDI             // All GDI defines and routines
#define NOUSER            // All USER defines and routines
#include <windows.h>
#undef near
#undef far
#undef PlaySound

#define RLIGHTS_IMPLEMENTATION
#include "rlights.h"

void RenderTeam(int teamIndex, Material mat)
{
    int activeBees = AliveCount[teamIndex] + DeadCount[teamIndex];
    float16* transforms = teamIndex == 0 ? team1Transforms : team2Transforms;
    Movement* movements = BeeMovements[teamIndex];
    Vector3* directions = BeeDirections[teamIndex];
    float* sizes = BeeSize[teamIndex];

    for (int i = 0; i < activeBees; i++)
    {
        Vector3 pos = movements[i].position;
        Vector3 direction = directions[i];
        float size = sizes[i];
        Matrix transform = MatrixIdentity();
        transform = MatrixMultiply(transform, MatrixLookAt(Vector3Zero(), direction, (Vector3) { 0.0f, 1.0f, 0.0f }));
        transform = MatrixMultiply(transform, MatrixScale(size, size, size));
        transform = MatrixMultiply(transform, MatrixTranslate(pos.x, pos.y, pos.z));
        transforms[i] = MatrixToFloatV(transform);
    }

    DrawMeshInstancedNoAlloc(beeMesh, mat, transforms, activeBees);
}

void Render()
{
    RenderTeam(0, blueMat);
    RenderTeam(1, yellowMat);
}

void InitResources()
{
    beeMesh = GenMeshDoubleSidedQuad(2.0f, 1.0f);
    Shader instancedShader = LoadShader("assets/shaders/base_lighting_instanced.vs", "assets/shaders/lighting.fs");
    yellowMat = LoadMaterialDefault();
    yellowMat.maps[0].color = YELLOW; 
    yellowMat.shader = instancedShader;
    blueMat = LoadMaterialDefault();
    blueMat.maps[0].color = BLUE;
    blueMat.shader = instancedShader;

    int matLightNoNormalMap = GetShaderLocation(instancedShader, "matLight");
    instancedShader.locs[SHADER_LOC_MATRIX_MVP] = GetShaderLocation(instancedShader, "mvp");
    instancedShader.locs[SHADER_LOC_MATRIX_MODEL] = GetShaderLocationAttrib(instancedShader, "instanceTransform");
    instancedShader.locs[SHADER_LOC_VECTOR_VIEW] = GetShaderLocation(instancedShader, "viewPos");
}

void InitTaskThreads(int threadCount, TaskQueue* params)
{
    for (int i = 0; i < threadCount; i++)
    {
        _beginthread(&RunTasks, 0, (void*)params);
    }
}

static TaskQueue threadParam;

int main(void)
{
    // Initialization
    //--------------------------------------------------------------------------------------
    int screenWidth = 1920;
    int screenHeight = 1080;
    Vector3 lightTarget = { 0.0f, 0.0f, 0.0f };
    Vector3 lightPos = { -50.2f, 50.6f, 20.0f };
    Color sunLightColor = (Color){ 250, 247, 149, 255 };
    Color ambientColor = (Color){ 250, 247, 250, 255 };
    InitWindow(screenWidth, screenHeight, "Combat bees Raylib and C version");
    InitResources();
    Init();

    Light sun = CreateLight(LIGHT_DIRECTIONAL, lightPos, lightTarget, sunLightColor, blueMat.shader, 0);
    UpdateLightValues(blueMat.shader, sun);
    float* ambientColorLevel = (float[4]){ ambientColor.r / 255.0f, ambientColor.g / 255.0f, ambientColor.b / 255.0f, 1.0f };
    SetShaderValue(blueMat.shader, GetShaderLocation(blueMat.shader, "ambient"), ambientColorLevel, SHADER_UNIFORM_VEC4);

    Camera3D camera = { 0 };
    camera.position = (Vector3){ 0.0f, 10.0f, 120.0f }; // Camera position
    camera.target = (Vector3){ 0.0f, 0.0f, 0.0f };      // Camera looking at point
    camera.up = (Vector3){ 0.0f, 1.0f, 0.0f };          // Camera up vector (rotation towards target)
    camera.fovy = 45.0f;                                // Camera field-of-view Y
    camera.projection = CAMERA_PERSPECTIVE;             // Camera projection type

    InitTaskRunner();
    threadParam = (TaskQueue){ taskQueue, &queuedTasks };

    SYSTEM_INFO siSysInfo;

    GetSystemInfo(&siSysInfo);
    int numberOfThreads = siSysInfo.dwNumberOfProcessors - 1;
    numberOfThreads = max(numberOfThreads, 2);
    if (numberOfThreads % 2 != 0)
    {
        numberOfThreads++;
    }

    InitTaskThreads(numberOfThreads, &threadParam);
    frameCounter = 0;
    int beesPerThread = beeStartCount / numberOfThreads;
    int missedBees = beeStartCount - beesPerThread * numberOfThreads;

    for (int i = 0; i < numberOfThreads; i++)
    {
        int count = beesPerThread;
        int teamIndex = i >= numberOfThreads / 2 ? 1 : 0;
        int startIndex = teamIndex == 0 ? i * beesPerThread : i * beesPerThread - beeStartCount / 2;
        if (i == numberOfThreads - 1 || i == numberOfThreads/2 - 1)
        {
            count += missedBees / 2;
        }
        UpdateMovementData nextMovementData = { 0 };
        nextMovementData.taskData.frameCounter = frameCounter;
        nextMovementData.aliveBeesCount = &AliveCount[teamIndex];
        nextMovementData.count = count;
        nextMovementData.deltaTime = &lastFrameDelta;
        nextMovementData.directions = BeeDirections[teamIndex];
        nextMovementData.movements = BeeMovements[teamIndex];
        nextMovementData.startIndex = startIndex;

        Task nextMovementTask = { 0 };
        memcpy(nextMovementTask.data, &nextMovementData, sizeof(UpdateMovementData));
        nextMovementTask.function = &UpdateMovementTask;
        //AddTaskToQueue(nextMovementTask, taskQueue, &queuedTasks);
    }

    while (!WindowShouldClose())    // Detect window close button or ESC key
    {
      
        //UpdateCamera(&camera, CAMERA_ORBITAL);
        float delta = GetFrameTime();
        delta = min(delta, 0.033f);
        //Update logic

        /*
        * 
        * The bees handled in each task need to be aligned to 64 bees so the tasks writing to targeting does not end up writing data from two threads to same memory
        * Might need to align dead bees to 64 bees as well, leaving some empty space after the last alive bee before the first dead bee start
        
        SpawnBees queues UpdateMovement for all alive bees and queues UpdatePositions for all dead bees
        UpdateMovement queues UpdatePositions for the bees it just updated, as well as UpdateTargets for the same bees, needs to be divided in groups of 64
        UpdatePositions queues UpdateCollission for the bees it just updated
        
        
        */
        SpawnBeesUpdate();
        UpdateMovement(delta);
        UpdatePositions(delta);
       // UpdateTargets();
        //UpdateAttack(delta);
       // UpdateDead(delta);
       // UpdateCollisions();
        
        while (doneThreads < numberOfThreads)
        {
            Sleep(1);
        }

        BeginDrawing();

            ClearBackground(SKYBLUE);

            BeginMode3D(camera);

            Render();

            EndMode3D();
           

            DrawFPS(10, 10);

            DrawText(TextFormat("Blue team alive: %d", AliveCount[0]), 40, 900, 24, WHITE);
            DrawText(TextFormat("Blue team dead: %d", DeadCount[0]), 40, 930, 24, WHITE);
            DrawText(TextFormat("Yellow team alive: %d", AliveCount[1]), 40, 960, 24, WHITE);
            DrawText(TextFormat("Yellow team dead: %d", DeadCount[1]), 40, 990, 24, WHITE);

        EndDrawing();
        frameCounter++;
    }



    CloseWindow();        // Close window and OpenGL context

    return 0;
}
