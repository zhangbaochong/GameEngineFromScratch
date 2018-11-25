#version 400

struct skybox_vert_output
{
    vec4 pos;
    vec3 uvw;
};

struct Light
{
    float lightIntensity;
    uint lightType;
    int lightCastShadow;
    int lightShadowMapIndex;
    uint lightAngleAttenCurveType;
    uint lightDistAttenCurveType;
    vec2 lightSize;
    uvec4 lightGuid;
    vec4 lightPosition;
    vec4 lightColor;
    vec4 lightDirection;
    vec4 lightDistAttenCurveParams[2];
    vec4 lightAngleAttenCurveParams[2];
    mat4 lightVP;
    vec4 padding[2];
};

uniform samplerCubeArray SPIRV_Cross_Combinedskyboxsamp0;

in vec3 input_uvw;
layout(location = 0) out vec4 _entryPointOutput;

vec3 exposure_tone_mapping(vec3 color)
{
    return vec3(1.0) - exp((-color) * 1.0);
}

vec3 gamma_correction(vec3 color)
{
    return pow(max(color, vec3(0.0)), vec3(0.4545454680919647216796875));
}

vec4 _skybox_frag_main(skybox_vert_output _input)
{
    vec4 outputColor = textureLod(SPIRV_Cross_Combinedskyboxsamp0, vec4(_input.uvw, 0.0), 0.0);
    vec3 param = outputColor.xyz;
    vec3 _65 = exposure_tone_mapping(param);
    outputColor = vec4(_65.x, _65.y, _65.z, outputColor.w);
    vec3 param_1 = outputColor.xyz;
    vec3 _71 = gamma_correction(param_1);
    outputColor = vec4(_71.x, _71.y, _71.z, outputColor.w);
    return outputColor;
}

void main()
{
    skybox_vert_output _input;
    _input.pos = gl_FragCoord;
    _input.uvw = input_uvw;
    skybox_vert_output param = _input;
    _entryPointOutput = _skybox_frag_main(param);
}

