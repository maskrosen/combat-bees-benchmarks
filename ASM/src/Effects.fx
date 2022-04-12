#include "Matrix.hlsl"


Texture2D shadowMap : register (t0);            // shadowmap texture
Texture2D uiTexture : register (t1);            // ui texture

SamplerComparisonState shadowSampler : register (s0);
SamplerState uiSamplerState : register(s1);

cbuffer cbPerObject : register(b0)
{
	float4x4 WVP;
	float4x4 View;
	float4x4 Projection;
};

cbuffer skyquadBuffer : register(b4)
{    
    float4x4 ViewMatrixSkyQuad;
    float4x4 ProjectionMatrixSkyQuad;
}

cbuffer cameraBuffer : register(b1)
{
    float3 cameraPosition;
    float cameraPitch;
};

cbuffer directionalLightBuffer : register(b3)
{
    float3 lightDirection;
    float padding1;
	float4x4 directionalLightWVP; 
    float4 sunPosition;
};

cbuffer waterBuffer : register(b2)
{
    float waveTime;
    float3 padding2;
};

cbuffer mouseBuffer : register (b5)
{
    float4 mousePosition;
    float4 previewRotation;
    float4 previewColor;
}

struct VS_OUTPUT_ROAD
{
	float4 Pos : SV_POSITION;
	float4 Color : COLOR;
  	float4 Normal : NORMAL;
  	float3 viewDirection : TEXCOORD0;
  	float4 WorldPos : VERTEXPOSITION0;
  	float2 SpecularContribution : TEXCOORD1; //first is power, second is intensity
  	float2 UV : TEXCOORD2;
  	float Length : LENGTH;
	float4 LightSpacePosition :VERTEXPOSITION1;
    int RoadType : VERTEXPOSITION2; 
};

struct VS_OUTPUT
{
	float4 Pos : SV_POSITION;
	float4 Color : COLOR;
  	nointerpolation float4 Normal : NORMAL;
  	float3 viewDirection : TEXCOORD0;
  	float4 WorldPos : VERTEXPOSITION0;
  	float2 SpecularContribution : TEXCOORD1; //first is power, second is intensity
	float4 LightSpacePosition :VERTEXPOSITION1;
    int Type : VERTEXPOSITION2; //0 = terrain or roads, 1 = water, 2 = unlit, 3 = objects

};

struct VS_OUTPUT_SKY_QUAD
{
    float4 Pos : SV_POSITION;
	float4 Color : COLOR;
  	float2 UV : TEXCOORD0;
};

struct VS_OUTPUT_2D_TEXTURE
{
    float4 Pos : SV_POSITION;
	float4 Color : COLOR;
  	float2 UV : TEXCOORD0;
};

struct VS_OUTPUT_SUN
{
    float4 Pos : SV_POSITION;
  	float4 WorldPos : VERTEXPOSITION0;
	float4 Color : COLOR;
  	float2 UV : TEXCOORD0;
    float Radius : VERTEXPOSITION1;
    float SunYPos : VERTEXPOSITION2;
};



static float3 lightDirection2 = float3(0.0f, 0.5f, 0.25f);
static float4 lightAmbient = float4(0.0f, 0.0f, 0.0f, 1.0f);// * float4(0.26f, 0.63f, 1.0f, 1.0f);
static float4 lightDiffuse = float4(253.0f / 255.0f, 251.0f/255.0f, 211.0f/255.0f, 1.0f);
static float directionalLightIntensity = 1.0f;
static float hemisphereLightIntensity = 0.9f;
static float3 orangeLaneMarkerColor = float3(255.0f / 255.0f, 150.0f/255.0f, 64.0f/255.0f);
static float3 whiteLaneMarkerColor = float3(234.0f / 255.0f, 235.0f/255.0f, 210.0f/255.0f);
static float3 roadColor = float3(42.0f / 255.0f, 40.0f/255.0f, 44.0f/255.0f);
static float3 upperHemisphereColor = float3(0.686f, 0.863f, 0.922f);// * float3(0.23875f, 0.52925f, 0.93f);
static float3 lowerHemisphereColor = float3(0.661, 0.787f,0.687f);// * float3(0.306f, 0.443f,0.255f);
static float4 cliffGrey = float4(165, 148, 129, 255)/255.0;//float4(0.973, 0.863, 0.675, 1.0) * 0.75;
static float4 cliffBrown = float4(162, 101, 70, 255)/255.0;//float4(0.529, 0.35, 0.203, 1.0); 
static float4 grassColor = float4(0.322, 0.42, 0.184, 1.0) * 1.5f;
static float4 sandColor = float4(0.973, 0.863, 0.675, 1.0);//float4(0.761, 0.722, 0.553, 1.0); 
static float4 waterColor = float4(float3(69, 255, 241) / 255.0, 0.475);
//static float specularPower = 32.0f;
static float4 specularColor = lightDiffuse;//float4(1.0f,1.0f,1.0f,1.0f);
static float waveLength = 4.0f;
static float waveAmplitude = 0.6f;
static float waveTimeMultiplier = 0.2;
static const float PI = 3.14159265f;
static float4 up = float4(0,1,0,0); 
static const float waterYPos = 20.0;
static const float SQRT_2 = 1.4142135623730951;



float generateOffset(float x, float z, float val1, float val2){
  	float waveTimeMultiplied = waveTime * waveTimeMultiplier;
	float radiansX = ((fmod(x+z*x*val1, waveLength)/waveLength) + waveTimeMultiplied * fmod(x * 0.8 + z, 1.5)) * 2.0 * PI;
	float radiansZ = ((fmod(val2 * (z*x +x*z), waveLength)/waveLength) + waveTimeMultiplied * 2.0 * fmod(x , 2.0) ) * 2.0 * PI;
	return waveAmplitude * 0.5 * (sin(radiansZ) + cos(radiansX));
}

float3 applyDistortion(float3 vertexPosition){
	float xDistortion = generateOffset(vertexPosition.x, vertexPosition.z, 0.2, 0.1);
	float yDistortion = generateOffset(vertexPosition.x, vertexPosition.z, 0.1, 0.3);
	float zDistortion = generateOffset(vertexPosition.x, vertexPosition.z, 0.15, 0.2);
	return float3(xDistortion, yDistortion, zDistortion);
}
//static float specularIntensity = 0.8f;

/*float4 when_eq(float4 x, float4 y) {
  return 1.0f - abs(sign(x - y));
}

float4 when_neq(float4 x, float4 y) {
  return abs(sign(x - y));
}

float4 when_gt(float4 x, float4 y) {
  return max(sign(x - y), 0.0f);
}

float4 when_lt(float4 x, float4 y) {
  return max(sign(y - x), 0.0f);
}

float4 when_ge(float4 x, float4 y) {
  return 1.0f - when_lt(x, y);
}

float4 when_le(float4 x, float4 y) {
  return 1.0f - when_gt(x, y);
}*/

float when_gt(float x, float y) {
  return max(sign(x - y), 0.0f);
}

float when_le(float x, float y) {
  return 1.0f - when_gt(x, y);
}

float4 CalculateLighting(VS_OUTPUT input)
{
    
    float3 nLightDirection = normalize(lightDirection);
	float3 psNormal = input.Normal.xyz;
    float4 diffuse = input.Color;
    float3 ambientColor = diffuse.xyz * lightAmbient.xyz;
    float w = 0.5 * (1.0 + dot(up, psNormal));
    float3 lowerColor = lowerHemisphereColor;
    if(input.Type == 0){
        lowerColor = float3(0.6f,0.6f,0.6f);
    }
    float3 hemisphereLighting = (w * upperHemisphereColor + (1.0 - w) * lowerColor) * diffuse.xyz * hemisphereLightIntensity; // * diffuse.xyz * 3;
	
	// Compute texture coordinates for the current point's location on the shadow map.
	float2 shadowTexCoords;
	shadowTexCoords.x = 0.5f + (input.LightSpacePosition.x / input.LightSpacePosition.w * 0.5f);
	shadowTexCoords.y = 0.5f - (input.LightSpacePosition.y / input.LightSpacePosition.w * 0.5f);
	float pixelDepth = input.LightSpacePosition.z / input.LightSpacePosition.w;

	float lighting = 1;


    float3 viewDirection = input.viewDirection;

    float lightIntensity = dot(nLightDirection, psNormal);

	float NdotL = lightIntensity;

    float3 adjustedLightDirection = nLightDirection;
    adjustedLightDirection.y *= 0.3;
    lightIntensity = saturate (3 * dot(psNormal, adjustedLightDirection));

	// Check if the pixel texture coordinate is in the view frustum of the 
	// light before doing any shadow work.
	if ((saturate(shadowTexCoords.x) == shadowTexCoords.x) &&
    (saturate(shadowTexCoords.y) == shadowTexCoords.y) &&
    (pixelDepth > 0) && (input.WorldPos.y > waterYPos || input.Type == 1))
	{
		// Use an offset value to mitigate shadow artifacts due to imprecise 
		// floating-point values (shadow acne).
		//
		// This is an approximation of epsilon * tan(acos(saturate(NdotL))):
		float margin = acos(saturate(NdotL));
		float epsilon = 0.0005 / margin;
		// Clamp epsilon to a fixed range so it doesn't go overboard.
		epsilon = clamp(epsilon, 0, 0.1);
		
		lighting = float(shadowMap.SampleCmpLevelZero(
			shadowSampler,
			shadowTexCoords,			
			pixelDepth - epsilon
			)
			);
	}
	float4 specular = 0;
    //Calc hemisphere lighting
    float3 diffuseReflection = 0;
	float specularIntensity = input.SpecularContribution.y;
	if(lighting > 0){

		diffuseReflection += saturate(lightIntensity * lightDiffuse * diffuse * directionalLightIntensity).xyz;
		// Calculate the reflection vector based on the light intensity, normal vector, and light direction.
		float3 reflection = normalize(2 * lightIntensity * psNormal - nLightDirection); 
		
        float3 halfVector = normalize(nLightDirection + viewDirection);

		float specularPower = input.SpecularContribution.x;

        float NdH = dot(psNormal, halfVector);

        specular.rgb = pow(saturate(NdH),specularPower) * (specularPower + 8)/8 * specularIntensity * specularColor; //TODO add specular color of light, currently assumes white

		// Determine the amount of specular light based on the reflection vector, viewing direction, and specular power.
		//specular = pow(saturate(dot(reflection, viewDirection)), specularPower) * specularIntensity;
		specular = saturate(specular);

        hemisphereLighting *= (1 - lightIntensity * 0.65);
	}
	//basicColor.x = lighting;
	//basicColor.y = lighting;
	//basicColor.z = lighting;
    float4 result = saturate(float4((1 - specularIntensity) * diffuseReflection + ambientColor + hemisphereLighting, diffuse.a));
    //result.xyz = min(result, diffuse * 1.2f);
    result = saturate(result + specular);
    //result.x = upperHemisphereColor.x;
    //result.y = upperHemisphereColor.y;
    //result.z = upperHemisphereColor.z;
    //result.xyz = hemisphereLighting;
    //result.xyz = hemisphereLighting * (1 - lightIntensity * 0.5);
    //result.xyz = diffuseReflection + hemisphereLighting;
    //result.xyz = min(result, diffuse * 1.2f);
    //result.xyz = lerp(psNormal, diffuse.xyz, 0.75);
    //result.rgb = specular.rgb;
    return result;
}

float Rectangle_float(float2 UV, float Width, float Height)
{
    float2 d = abs(UV * 2 - 1) - float2(Width, Height);
    d = 1 - d / fwidth(d);
    return saturate(min(d.x, d.y));
}

float2 TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset)
{
    return UV * Tiling + Offset;
}

float4x4 MakeRotationMatrix(float4 eye, float4 lookAt)
{


    float3 zaxis = normalize(lookAt - eye);
    
    float3 xaxis = normalize(cross(up, zaxis));

    float3 yaxis = cross(zaxis, xaxis);

    float4x4 result = float4x4(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);

    result[0][0] = xaxis.x; 
    result[1][0] = yaxis.x; 
    result[2][0] = zaxis.x; 
    result[3][0] = 0;

    result[0][1] = xaxis.y; 
    result[1][1] = yaxis.y; 
    result[2][1] = zaxis.y; 
    result[3][1] = 0; 

    result[0][2] = xaxis.z; 
    result[1][2] = yaxis.z; 
    result[2][2] = zaxis.z; 
    result[3][2] = 0; 

    result[0][3] = 0;
    result[1][3] = 0;
    result[2][3] = 0;
    result[3][3] = 1;

    return result;
}

[maxvertexcount(3)]
void GS_TerrainNormals(triangle VS_OUTPUT input[3], inout TriangleStream<VS_OUTPUT> OutputStream)
{
    float3 tangent = input[1].WorldPos.xyz - input[0].WorldPos.xyz;
    float3 biTangent = input[2].WorldPos.xyz - input[0].WorldPos.xyz;
    float3 normal = cross(tangent, biTangent);
    normal = normalize(normal); 
    float horizontalValue = abs(normal.x) + abs(normal.z);

    horizontalValue = 1.0 - abs(normal.y);
    float verticalValue = abs(normal.y);
    
    for(int i = 0; i < 3; i++)
    {
       
        float greyValue = horizontalValue - 0.7;
        float brownValue = max(max(horizontalValue, 0.8) - 0.5 - greyValue, 0.0);
        float groundValue = 1 - max(horizontalValue, 0.6) / 0.6;

       // input[i].Color = greyValue / 0.3 * cliffGrey +
       // brownValue / 0.3 * cliffBrown + groundValue * input[i].Color;

        //if(horizontalValue > 0.9){
        //    input[i].Color = cliffGrey;
        //}else if(horizontalValue > 0.7){
        //    input[i].Color = (0.9 - horizontalValue) / 0.2 * cliffBrown + (horizontalValue - 0.7) / 0.2 * cliffGrey; 
        //}else if(horizontalValue > 0.7){
        //    input[i].Color = cliffBrown;
        //}else if(horizontalValue > 0.4) {
        //    input[i].Color = (0.7 - horizontalValue) / 0.3 * input[i].Color + (horizontalValue - 0.4) / 0.3 * cliffBrown;             
        //}

        float smoothSpan = 2.0f;
        
        float sandBlendValue = saturate((waterYPos * 1.2f - input[0].WorldPos.y) / smoothSpan + 0.5f);
        float4 horizontalColor = grassColor * (1 - sandBlendValue) + sandBlendValue * sandColor;
        float4 dirtColor = cliffBrown * (1 - sandBlendValue) + sandBlendValue * sandColor;

        float grassBlend = 0.8;
        float grassThreshold = 0.1;

        float grassBlendHeight = grassThreshold * (1 - grassBlend);
        float grassWeight = 1 - saturate((horizontalValue - grassBlendHeight)/(grassThreshold-grassBlendHeight));
        input[i].Color = (horizontalColor * grassWeight + dirtColor * (1 - grassWeight)) * (1 - input[i].Type) + input[i].Color * input[i].Type;
        
        float rockBlend = 0.5;
        float rockThreshold = 0.5;

        float rockBlendHeight = rockThreshold * (1 - rockBlend);
        float rockWeight = 1 - saturate((verticalValue - rockBlendHeight)/(rockThreshold-rockBlendHeight));
        input[i].Color = (cliffGrey * rockWeight + input[i].Color * (1 - rockWeight)) * (1 - input[i].Type) + input[i].Color * input[i].Type;


        input[i].Normal = float4(normal, 0);   
        input[i].SpecularContribution.y = input[i].SpecularContribution.y * (1 - sandBlendValue) + 0.1f * sandBlendValue; //Set extra reflection on sand
        OutputStream.Append(input[i]);
    }
}

VS_OUTPUT VSWater(float4 inPos : VERTEXPOSITION, float4 inColor : COLOR, float4 normal : NORMAL, float2 specularContribution : TEXCOORD0)
{
    VS_OUTPUT output;

    inPos.xyz += applyDistortion(inPos.xyz);

    output.Pos = mul(inPos, WVP);
    output.Color = waterColor;
    output.Normal = normal;
    output.viewDirection = cameraPosition.xyz - inPos.xyz;
    output.viewDirection = normalize(output.viewDirection);
    output.WorldPos = inPos;
    output.SpecularContribution = specularContribution;
	output.LightSpacePosition = mul(inPos, directionalLightWVP);
    output.Type = 1;

    return output;
}

VS_OUTPUT VSTerrain(float4 inPos : VERTEXPOSITION, float4 inColor : COLOR, float4 normal : NORMAL, float2 specularContribution : TEXCOORD0)
{
    VS_OUTPUT output;

    output.Pos = mul(inPos, WVP);
    output.Color = inColor;
    output.Normal = normal;
    output.viewDirection = cameraPosition.xyz - inPos.xyz;
    output.viewDirection = normalize(output.viewDirection);
    output.WorldPos = inPos;
    output.SpecularContribution = specularContribution;
	output.LightSpacePosition = mul(inPos, directionalLightWVP);
    output.Type = 0;

    return output;
}

VS_OUTPUT_ROAD VS(float4 inPos : VERTEXPOSITION0, float4 inColor : COLOR, float4 normal : NORMAL, 
float2 specularContribution : TEXCOORD0, float2 uv : TEXCOORD1, float length: LENGTH0,
uint roadType: TYPE)
{
    VS_OUTPUT_ROAD output;

    output.Pos = mul(inPos, WVP);
    output.Color = inColor;
    output.Normal = normal;
    output.viewDirection = cameraPosition.xyz - inPos.xyz;
    output.viewDirection = normalize(output.viewDirection);
    output.WorldPos = inPos;
    output.SpecularContribution = specularContribution;
    output.UV = uv;
    output.Length = length;
	output.LightSpacePosition = mul(inPos, directionalLightWVP);
    output.RoadType = roadType;

    return output;
}

float4 PS(VS_OUTPUT input) : SV_TARGET
{
    
    if(input.Type == 2){
        return input.Color;
    }
    float4 result = CalculateLighting(input);
    //specular.x = 0;
    //if(lightDirection.y == lightDirection2.y)
    //return float4(saturate(waveTime) ,0,0,1);
    //else 
    //return float4(0,1,0,1);
    //return float4(lightIntensity, 0,0,1);
    return result;
    //return diffuse;
    //return specular;
    //return float4(abs(specular.xyz), 1);
    //return float4(nLightDirection, 1.0f);
}

float filterwidth(float2 v)
{
  float2 fw = max(abs(ddx(v)), abs(ddy(v)));
  return max(fw.x, fw.y);
}

float rectangle(float2 uv, float width, float height){
    float leftSide = uv.x - (0.5 - width/2);
    float rightSide = 0.5 + width/2 - uv.x;

    float topSide = uv.y - (0.5 - height/2);
    float bottomSide = 0.5 + height/2 - uv.y;

    float xResult = max(leftSide, 0) / leftSide * max(rightSide, 0) / rightSide;
    float yResult = max(topSide, 0) / topSide * max(bottomSide, 0) / bottomSide;
    return xResult * yResult;
}

float2 rectangleIntegral(float2 uv, float width, float height) {
    float leftSide = uv.x - (0.5 - width/2);
    float xResult = min(max(leftSide, 0), width);
    float topSide = frac(uv.y) - (0.5 - height/2);
    float yResult = min(max(topSide, 0), height);
    return float2 (xResult, yResult);
}

float triangle1(float2 uv)
{
    if(uv.y*0.5 <= uv.x && uv.x <= 1 - 0.5*uv.y){
        return 1;        
    }
    else{
        return 0;
    }
}

/*
https://www.wolframalpha.com/input/?i=double+integral+calculator&assumption=%7B%22F%22%2C+%22DoubleIntegral%22%2C+%22integrand%22%7D+-%3E%22Piecewise%5B%7B%7B1%2Cy%2F2+%3C%3D+x+%3C%3D+1-y%2F2%7D%7D%5D%22&assumption=%7B%22F%22%2C+%22DoubleIntegral%22%2C+%22intvariable1%22%7D+-%3E%22x%22&assumption=%7B%22F%22%2C+%22DoubleIntegral%22%2C+%22intvariable2%22%7D+-%3E%22y%22
*/

float triangleIntegral(float2 uv){
    if(2*uv.x >= uv.y && 2*uv.x+uv.y <= 2){
        return uv.x;
    }
    else{
        return 0;
    }
}

float polygon(float2 UV, float Sides, float Width, float Height)
{
    UV = frac(UV);
    float pi = 3.14159265359;
    float aWidth = Width * cos(pi / Sides);
    float aHeight = Height * cos(pi / Sides);
    float2 uv = (UV * 2 - 1) / float2(aWidth, aHeight);
    uv.y *= -1;
    float pCoord = atan2(uv.x, uv.y);
    float r = 2 * pi / Sides;
    float distance = cos(floor(0.5 + pCoord / r) * r - pCoord) * length(uv);
    return saturate((1 - distance) / fwidth(distance));
}


float4 PSRoad(VS_OUTPUT_ROAD input) : SV_TARGET
{
    float roadWidth = 3.0;
    float lineDistance = 3.0;
    float numberOfLines = 1;
    float numberOfDashes = input.Length / lineDistance;

    float circleRadiusUVLength = roadWidth / input.Length * 0.5;

    float lineWidth = 0.04;
    float lineRatio = 0.6;
    float outerLinesDistance = 0.42;

    float3 markerColor = orangeLaneMarkerColor; 
    
    //float2 width = filterwidth(input.UV);
    //float2 p0 = input.UV - .5 * width, p1 = input.UV + .5 * width;

    float2 rectangleUV = TilingAndOffset_float(input.UV, float2(numberOfLines, numberOfDashes), float2(0,0));
    if(input.RoadType == 1){//One way road
        rectangleUV = TilingAndOffset_float(input.UV, float2(1, input.Length / 30), float2(0,0));
        markerColor = whiteLaneMarkerColor; 
        //rectangleUV = input.UV;
    }
    else if(input.RoadType == 2){//Parking road
        rectangleUV = TilingAndOffset_float(input.UV, float2(2, input.Length / 3.0), float2(0,0));
        markerColor = whiteLaneMarkerColor; 
    }
    //float2 rectangleUV2 = TilingAndOffset_float(p1, float2(numberOfLines, numberOfDashes), float2(0,0));

    //rectangleUV = frac(rectangleUV);
    

    //rectangleUV2 = frac(rectangleUV2);
    float2 width = fwidth(rectangleUV);

    float2 p0 = rectangleUV - .5 * width, p1 = rectangleUV + .5 * width;

    //p0 = saturate(p0);
    //p1 = saturate(p1);
    
    //float roadColor = (Rectangle_float(p0, lineWidth, lineRatio) + Rectangle_float(p1, lineWidth, lineRatio))/ width;
    //float roadColor = Rectangle_float(rectangleUV, lineWidth, lineRatio);
    //float roadColor = rectangle(rectangleUV, lineWidth, lineRatio);
    float2 i = (rectangleIntegral(p1, lineWidth, lineRatio) - rectangleIntegral(p0, lineWidth, lineRatio)) / width;
    if(input.RoadType == 1){       
        
        i = polygon(rectangleUV, 3, 0.3, 0.1);
        rectangleUV.y += 0.05;
        p0 = rectangleUV - .5 * width;
        p1 = rectangleUV + .5 * width;

        i += (rectangleIntegral(p1, 0.1, 0.06) - rectangleIntegral(p0, 0.1, 0.06)) / width;
    }
    else if(input.RoadType == 2){
        //p1.x = frac(p1.x);
        //p0.x = frac(p0.x);
        i = (rectangleIntegral(p1, 1.0, 0.1) - rectangleIntegral(p0, 1.0, 0.1)) / width;
    } 
    float markerValue = i.x  * i.y; //+ (1 - i.x) * (1 - i.y);
    //roadColor = rectangle(rectangleUV, lineWidth, lineRatio);
    markerValue = saturate(markerValue);
    //roadColor = p1.x;


    //rectangleUV = TilingAndOffset_float(input.UV, float2(numberOfLines, numberOfDashes), float2(0,0));
    //rectangleUV = frac(rectangleUV);
    //roadColor = rectangle(rectangleUV, lineWidth, lineRatio);

    if(input.UV.y < circleRadiusUVLength || input.UV.y > (1 - circleRadiusUVLength)){
      markerValue = 0;
    }

    
    width = fwidth(rectangleUV);
    rectangleUV = TilingAndOffset_float(input.UV, float2(1, 1), float2(outerLinesDistance,0));
    //roadColor += Rectangle_float(rectangleUV, lineWidth, 1 - 2 * circleRadiusUVLength);
    rectangleUV = TilingAndOffset_float(input.UV, float2(1, 1), float2(-outerLinesDistance,0));
    
    p0 = rectangleUV - .5 * width;
    p1 = rectangleUV + .5 * width;
    //roadColor += saturate((Rectangle_float(p0, lineWidth, 1 - 2 * circleRadiusUVLength) + 
    //Rectangle_float(p1, lineWidth, 1 - 2 * circleRadiusUVLength)) / width);

   
    input.Color.rgb = roadColor * (1 - markerValue) + markerValue * markerColor;

    VS_OUTPUT lightInput;

    lightInput.Color = input.Color;
    lightInput.Pos = input.Pos;
    lightInput.Normal = input.Normal;
    lightInput.viewDirection = input.viewDirection;
    lightInput.WorldPos = input.WorldPos;
    lightInput.SpecularContribution = input.SpecularContribution;
    lightInput.SpecularContribution.y = 0.05f * (1 - markerValue) + 0.1f * markerValue; //Set extra reflection on lane marker
	lightInput.LightSpacePosition = input.LightSpacePosition;
    lightInput.Type = 0;

    float4 result = CalculateLighting(lightInput);


    return result;

}


  
VS_OUTPUT VSCars(float4 inPos : VERTEXPOSITION, float4 inColor : COLOR, float4 normal : NORMAL,
 float2 specularContribution : TEXCOORD0, float4 instancePosition : INSTANCEPOSITION, float4 instanceRotation : INSTANCEROTATION)
{
    VS_OUTPUT output;

    float4x4 rotation = MakeRotationMatrix(float4(0,0,0,0), instanceRotation);

    float4x4 translation =
    {
        1.0, 0.0, 0.0, 0.0,
        0.0, 1.0, 0.0, 0.0,
        0.0, 0.0, 1.0, 0.0,
        instancePosition.x, instancePosition.y, instancePosition.z, 1.0

    };

    float4x4 composition = mul(rotation, translation);

    inPos = mul(inPos, composition);
    output.Pos = mul(inPos, WVP);
    output.Color = inColor;
    output.Normal = mul(normal, composition);
    output.viewDirection = cameraPosition.xyz - inPos.xyz;
    output.viewDirection = normalize(output.viewDirection);
    output.WorldPos = inPos;
    output.SpecularContribution = specularContribution;
	output.LightSpacePosition = mul(inPos, directionalLightWVP);
    output.Type = 3;
    //output.UV = float2(0,0);

    return output;
}


  
VS_OUTPUT VSTrafficLight(float4 inPos : VERTEXPOSITION, float4 inColor : COLOR, float4 normal : NORMAL,
 float2 specularContribution : TEXCOORD0, float4 instancePosition : INSTANCEPOSITION, float4 instanceRotation : INSTANCEROTATION, uint lightState : INSTANCELIGHTSTATE)
{
    VS_OUTPUT output;

    float4x4 rotation = MakeRotationMatrix(float4(0,0,0,0), instanceRotation);

    float4x4 translation =
    {
        1.0, 0.0, 0.0, 0.0,
        0.0, 1.0, 0.0, 0.0,
        0.0, 0.0, 1.0, 0.0,
        instancePosition.x, instancePosition.y, instancePosition.z, 1.0

    };

    float4x4 composition = mul(rotation, translation);

    int type = 0;

    //Set light color depending in light state

    if(lightState == 0){
        //Red
        if(inColor.r > (inColor.g + inColor.b) * 2){
            float factor = 1 / inColor.r;
            inColor *= factor;
            type = 2;
        }
    }
    if(lightState == 1 || lightState == 3){
        //Yellow
        if(inColor.r > inColor.b * 2 && inColor.g > inColor.b * 2){
            float factor = 1 / inColor.r;
            inColor *= factor;
            type = 2;
        }
    }
    if(lightState == 2){
        //Green
        if(inColor.g > inColor.b + inColor.r){
            float factor = 1 / inColor.g;
            inColor *= factor;
            type = 2;
        }
    }

    inPos = mul(inPos, composition);
    output.Pos = mul(inPos, WVP);
    output.Color = inColor;
    output.Normal = mul(normal, composition);
    output.viewDirection = cameraPosition.xyz - inPos.xyz;
    output.viewDirection = normalize(output.viewDirection);
    output.WorldPos = inPos;
    output.SpecularContribution = specularContribution;
	output.LightSpacePosition = mul(inPos, directionalLightWVP);
    output.Type = type;
    //output.UV = float2(0,0);

    return output;
}


  
VS_OUTPUT VSMalls(float4 inPos : VERTEXPOSITION, float4 inColor : COLOR, float4 normal : NORMAL,
 float2 specularContribution : TEXCOORD0, float4 instancePosition : INSTANCEPOSITION, float4 instanceRotation : INSTANCEROTATION)
{
    VS_OUTPUT output;

    //inPos *= float4(30, 10, 20, 1); 

    float4x4 rotation = MakeRotationMatrix(float4(0,0,0,0), instanceRotation);


    float4x4 translation =
    {
        1.0, 0.0, 0.0, 0.0,
        0.0, 1.0, 0.0, 0.0,
        0.0, 0.0, 1.0, 0.0,
        instancePosition.x, instancePosition.y, instancePosition.z, 1.0

    };
    float4x4 composition = mul(rotation, translation);

    inPos = mul(inPos, composition);

    output.Pos = mul(inPos, WVP);
    output.Color = inColor;
    output.Normal = normal;
    output.viewDirection = cameraPosition.xyz - inPos.xyz;
    output.viewDirection = normalize(output.viewDirection);
    output.WorldPos = inPos;
    output.SpecularContribution = specularContribution;
	output.LightSpacePosition = mul(inPos, directionalLightWVP);
    output.Type = 3;
    //output.UV = float2(0,0);

    return output;
}
  
VS_OUTPUT VSMallPreview(float4 inPos : VERTEXPOSITION, float4 inColor : COLOR, float4 normal : NORMAL,
 float2 specularContribution : TEXCOORD0)
{
    VS_OUTPUT output;

    float4x4 rotation = MakeRotationMatrix(float4(0,0,0,0), previewRotation);


    //inPos *= float4(30, 10, 20, 1); 
    float4x4 translation =
    {
        1.0, 0.0, 0.0, 0.0,
        0.0, 1.0, 0.0, 0.0,
        0.0, 0.0, 1.0, 0.0,
        mousePosition.x, mousePosition.y, mousePosition.z, 1.0

    };

    float4x4 composition = mul(rotation, translation);

    inPos = mul(inPos, composition);

    output.Pos = mul(inPos, WVP);
    output.Color = inColor;
    output.Normal = normal;
    output.viewDirection = cameraPosition.xyz - inPos.xyz;
    output.viewDirection = normalize(output.viewDirection);
    output.WorldPos = inPos;
    output.SpecularContribution = specularContribution;
	output.LightSpacePosition = mul(inPos, directionalLightWVP);
    output.Type = 0;
    //output.UV = float2(0,0);

    return output;
}


VS_OUTPUT VSDebugSquares(float4 inPos : VERTEXPOSITION, float4 color : COLOR, float4 instancePosition : INSTANCEPOSITION)
{
    VS_OUTPUT output;

    float4x4 translation =
    {
        1.0, 0.0, 0.0, 0.0,
        0.0, 1.0, 0.0, 0.0,
        0.0, 0.0, 1.0, 0.0,
        instancePosition.x, instancePosition.y, instancePosition.z, 1.0

    };

    inPos = mul(inPos, translation);

    output.Pos = mul(inPos, WVP);
    output.Color = color;

    return output;
}

VS_OUTPUT VSLines(float4 inPos : VERTEXPOSITION, float4 color : COLOR)
{
    VS_OUTPUT output;

    output.Pos = mul(inPos, WVP);
    output.Color = color;

    return output;
}

float4 PSLines(VS_OUTPUT input) : SV_TARGET
{   
    return input.Color;
}

[maxvertexcount(4)]
void GS_Billboard(point VS_OUTPUT_SUN input[1], inout TriangleStream<VS_OUTPUT_SUN> OutputStream)
{
    // The point passed in is in the horizontal center of the billboard, and at the bottom vertically. Because of this,
    // we will take the trees width and divide it by two when finding the x axis for the quads vertices.
    float halfWidth = input[0].Radius;

    // The billboard will only be rotated on the y axis, so it's up vector will always be 0,1,0. Because of this, we can
    // find the billboards vertices using the cameras position and the billboards position. We start by getting the billboards
    // plane normal:
    float3 planeNormal = input[0].WorldPos - cameraPosition;
    planeNormal.y = 0.0f;
    planeNormal = normalize(planeNormal);

    // Now we need to find the billboards right vector, so we can easily find the billboards vertices from the input point
    float3 rightVector = normalize(cross(planeNormal, up)); // Cross planes normal with the up vector (+y) to get billboards right vector

    rightVector = rightVector * halfWidth; // change the length of the right vector to be half the width of the billboard

    // Get the billboards "height" vector which will be used to find the top two vertices in the billboard quad
    float3 upVector = float3(0, input[0].Radius * 2, 0);

    // Create the billboards quad
    float3 vert[4];

    // We get the points by using the billboards right vector and the billboards height
    vert[0] = float3(1, -1, 0);//input[0].WorldPos - rightVector; // Get bottom left vertex
    vert[1] = float3(-1, -1, 0);//input[0].WorldPos + rightVector; // Get bottom right vertex
    vert[2] = float3(1, 1, 0);//input[0].WorldPos - rightVector + upVector; // Get top left vertex
    vert[3] = float3(-1, 1, 0);//input[0].WorldPos + rightVector + upVector; // Get top right vertex

    // Get billboards texture coordinates
    float2 texCoord[4];
    texCoord[0] = float2(0, 1);
    texCoord[1] = float2(1, 1);
    texCoord[2] = float2(0, 0);
    texCoord[3] = float2(1, 0);

    //Remove camera position from WVP so the sun won't move 
    float4x4 editedView = View;

    editedView[3][0] = 0;
    editedView[3][1] = 0;
    editedView[3][2] = 0;

    float4x4 modelMatrix = IDENTITY_MATRIX;
    modelMatrix = m_translate(modelMatrix, input[0].WorldPos);

    modelMatrix[0][0] = View[0][0];
    modelMatrix[0][1] = View[1][0];
    modelMatrix[0][2] = View[2][0];
    modelMatrix[1][0] = View[0][1];
    modelMatrix[1][1] = View[1][1];
    modelMatrix[1][2] = View[2][1];
    modelMatrix[2][0] = View[0][2];
    modelMatrix[2][1] = View[1][2];
    modelMatrix[2][2] = View[2][2];

    float4x4 modelView = mul(modelMatrix, editedView);
    float scale = input[0].Radius * 2;
    modelView = m_scale(modelView, float3(scale, scale, scale));

    // Now we "append" or add the vertices to the outgoing stream list
    VS_OUTPUT_SUN outputVert;
    for(int i = 0; i < 4; i++)
    {
        outputVert.Pos = mul(mul(float4(vert[i],1),modelView), Projection);
        outputVert.WorldPos = float4(vert[i], 0.0f);
        outputVert.UV = texCoord[i];
        outputVert.Radius = input[0].Radius;
        outputVert.Color = float4(1,0,1,1);
        outputVert.SunYPos = input[0].SunYPos;

        OutputStream.Append(outputVert);
    }
}

VS_OUTPUT_SUN VSPoints(float4 inPos : VERTEXPOSITION, float4 color : COLOR)
{
    VS_OUTPUT_SUN output;

    output.WorldPos = inPos * 0.1f;
    output.Pos = mul(inPos, WVP);
    output.Color = color;
    output.Radius = 1000;
    output.UV = float2(0,0);
    output.SunYPos = inPos.y;

    return output;
}


float3 getSun(float2 uv, float2 pos){
	float sun = 1.0 - distance(uv,pos);
    
    sun = clamp(sun,0.0,1.0);
    
    float glow = sun;
    glow = clamp(glow,0.0,1.0);
    
    sun = pow(sun,100.0);
    sun *= 100.0;
    sun = clamp(sun,0.0,1.0);
    
    glow = pow(glow,6.0) * 1.0;
    glow = pow(glow,(uv.y));
    glow = clamp(glow,0.0,1.0);
    
    sun *= pow(dot(uv.y, uv.y), 1.0 / 1.65);
    
    glow *= pow(dot(uv.y, uv.y), 1.0 / 2.0);
    
    sun += glow;
    
    float3 sunColor = float3(1.0,0.6,0.05) * sun;
    
    return sunColor;
}

float3 getSky(float2 uv, float3 color, float yPos)
{
    float atmosphere = sqrt(1.0-uv.y);
    
    float scatter = pow(yPos,1.0 / 15.0);
    scatter = 1.0 - clamp(scatter,0.8,1.0);
    
    float3 scatterColor = lerp(float3(1.0,1.0,1.0),float3(1.0,0.3,0.0) * 1.5,scatter);
    return lerp(color,float3(scatterColor),atmosphere / 1.3);
    
}

float easing(float x) {
    return lerp(4 * x * x * x, 1 - pow(-2 * x + 2, 3) / 2, x);
}

float4 PSPoints(VS_OUTPUT_SUN input) : SV_TARGET
{   
    
    float l =length(input.UV - float2(0.5, 0.5)) * 1.22;

    float factor = 1 - easing(l + 0.15);

    factor = pow(factor, 1.5);    

    float4 result;

    result.xyz = lightDiffuse * factor * 1.3;
    
    float x = l + 0.2;

    float alpha = factor * 1.3 * (1 - 4 * x * x * x);
    
    result.a = alpha * alpha;//factor * factor * factor * factor;

    //result = float4(getSun(input.UV, input.SunYPos / 100000.0f), alpha);

    //result = float4(1,1,0,1);
    return result;
}

VS_OUTPUT VSPreview(float4 inPos : VERTEXPOSITION, float4 inColor : COLOR, float3 normal : NORMAL)
{
    VS_OUTPUT output;

    output.Pos = mul(inPos, WVP);
    output.Color = inColor;

    return output;
}

float4 PSPreview(VS_OUTPUT input) : SV_TARGET
{
   
    float4 result = input.Color;
    result = previewColor;
    return result;
}

VS_OUTPUT_SKY_QUAD VSQuads(float4 inPos : VERTEXPOSITION, float4 inColor : COLOR, float2 uv : TEXCOORD0)
{
    VS_OUTPUT_SKY_QUAD output;

    float4x4 editedView = ViewMatrixSkyQuad;

    editedView[3][0] = 0;
    editedView[3][1] = 0;
    editedView[3][2] = 0;

    output.Pos = mul(mul(inPos, editedView), ProjectionMatrixSkyQuad);//mul(inPos, WVP);
    output.Color = inColor;
    output.UV = uv;

    return output;
}

float4 PSQuads(VS_OUTPUT_SKY_QUAD input) : SV_TARGET
{   
    float4 result = input.Color;
    return result;
}

VS_OUTPUT_2D_TEXTURE VS2DTexture(float4 inPos : VERTEXPOSITION, float4 inColor : COLOR, float2 uv : TEXCOORD0, uint vertexID : SV_VertexID)
{
    VS_OUTPUT_2D_TEXTURE output;

    // vert id 0 = 0000, uv = (0, 0)
    // vert id 1 = 0001, uv = (1, 0)
    // vert id 2 = 0010, uv = (0, 1)
    // vert id 3 = 0011, uv = (1, 1)
    float2 uvNew = float2(vertexID & 1, (vertexID >> 1) & 1);

    // set the position for the vertex based on which vertex it is (uv)
    output.Pos = float4(inPos.x + (inPos.z * uvNew.x), inPos.y - (inPos.w * uvNew.y), 1, 1);
    output.Color = inColor;

    // set the texture coordinate based on which vertex it is (uv)
    output.UV = uvNew;

    return output;
}

VS_OUTPUT_2D_TEXTURE VSFont(float4 inPos : VERTEXPOSITION, float4 inColor : COLOR, float4 texCoord : TEXCOORD2, uint vertexID : SV_VertexID)
{
    VS_OUTPUT_2D_TEXTURE output;

    vertexID = vertexID % 4;

    // vert id 0 = 0000, uv = (0, 0)
    // vert id 1 = 0001, uv = (1, 0)
    // vert id 2 = 0010, uv = (0, 1)
    // vert id 3 = 0011, uv = (1, 1)
    float2 uv = float2(vertexID & 1, (vertexID >> 1) & 1);

    // set the position for the vertex based on which vertex it is (uv)
    output.Pos = float4(inPos.x + (inPos.z * uv.x), inPos.y - (inPos.w * uv.y), 1, 1);
    output.Color = inColor;

    // set the texture coordinate based on which vertex it is (uv)
    //float2(input.texCoord.x + (input.texCoord.z * uv.x), input.texCoord.y + (input.texCoord.w * uv.y));
    output.UV = float2(texCoord.x + (texCoord.z * uv.x), texCoord.y + (texCoord.w * uv.y));

    //output.UV = float2(0.2636 + 0.0898 * uv.x, 0.2207 + 0.0937 * uv.y);

    return output;
}

float4 PS2DTexture(VS_OUTPUT_2D_TEXTURE input) : SV_TARGET
{
    return /*float4(input.UV,0.0,1.0);*/uiTexture.Sample(uiSamplerState, input.UV) * input.Color;
}

