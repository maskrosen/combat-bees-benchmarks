#version 330

// Input vertex attributes (from vertex shader)
in vec3 fragPosition;
in vec2 fragTexCoord;
in vec4 fragColor;
in vec3 fragNormal;
in vec4 shadowPos;

// Input uniform values
uniform sampler2D texture0;
uniform vec4 colDiffuse;

// Output fragment color
out vec4 finalColor;

// NOTE: Add here your custom variables

#define     MAX_LIGHTS              4
#define     LIGHT_DIRECTIONAL       0
#define     LIGHT_POINT             1

struct MaterialProperty {
    vec3 color;
    int useSampler;
    sampler2D sampler;
};

struct Light {
    int enabled;
    int type;
    float power;
    vec3 position;
    vec3 target;
    vec4 color;
};

// Input lighting values
uniform Light lights[MAX_LIGHTS];
uniform vec4 ambient;
uniform vec3 viewPos;


void main()
{
    // Texel color fetching from texture sampler
    float gamma = 2.2;
    vec4 texelColor = pow(texture(texture0, fragTexCoord), vec4(gamma));
    vec3 lightDot = vec3(0.0);
    vec3 normal = normalize(fragNormal);
    vec3 viewD = normalize(viewPos - fragPosition);
    vec3 specular = vec3(0.0);


    // NOTE: Implement here your fragment shader code

    for (int i = 0; i < MAX_LIGHTS; i++)
    {
        if (lights[i].enabled == 1)
        {
            vec3 light = vec3(0.0);
            vec3 lightRaw = lights[i].position - fragPosition;
	        vec3 lightVec = normalize(lightRaw);
            vec3 lightDir = -normalize(lights[i].target - lights[i].position);
            float lightCutoff = 1;

            if (lights[i].type == LIGHT_DIRECTIONAL)
            {
                light = -normalize(lights[i].target - lights[i].position);
            }

            if (lights[i].type == LIGHT_POINT)
            {
                vec3 diff = lights[i].position - fragPosition;
                light = normalize(diff) * min((lights[i].power * 1/length(diff)), 1.0);
            }

            
            // float theta = dot(-lightVec, normalize(lightDir));
            // float epsilon = lightCutoff - spotSoftness;
            // float spot = clamp((theta - lightCutoff) / epsilon, 0.0, 1.0);

            float NdotL = max(dot(normal, light), 0.0);
            lightDot += lights[i].color.rgb*NdotL;

            float specCo = 0.0;
            if (NdotL > 0.0) specCo = pow(max(0.0, dot(viewD, reflect(-(light), normal))), 16.0); // 16 refers to shine
            specular += specCo;
        }
    }


    vec4 color = (texelColor*((colDiffuse + vec4(specular, 0.0))*vec4(lightDot, 1.0)));    
    
    color += texelColor*(ambient/4.0)*colDiffuse;

    // Gamma correction
    finalColor = pow(color, vec4(1.0/2.2));
    //finalColor = vec4(lights[0].color.rgb,1);//vec4(normal, 1.0);
}
