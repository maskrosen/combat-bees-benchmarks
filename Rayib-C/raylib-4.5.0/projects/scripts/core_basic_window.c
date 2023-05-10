#define PLATFORM_DESKTOP
#include "raylib.h"
#include "logic.h"
#include "data.h"
#include "gameUtils.h"
#include "raymath.h"

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


    while (!WindowShouldClose())    // Detect window close button or ESC key
    {
      
        //UpdateCamera(&camera, CAMERA_ORBITAL);
        float delta = GetFrameTime();
        delta = min(delta, 0.033f);
        //Update logic
        SpawnBeesUpdate();
        UpdateMovement(delta);
        UpdatePositions(delta);
        UpdateTargets();
        UpdateAttack(delta);
        UpdateDead(delta);
        UpdateCollisions();
        
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
    }



    CloseWindow();        // Close window and OpenGL context

    return 0;
}
