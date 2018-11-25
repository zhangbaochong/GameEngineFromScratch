#version 400

struct a2v_pos_only
{
    vec3 inputPosition;
};

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

layout(std140) uniform PerFrameConstants
{
    mat4 viewMatrix;
    mat4 projectionMatrix;
    vec4 camPos;
    uint numLights;
} _31;

layout(location = 0) in vec3 a_inputPosition;
out vec3 _entryPointOutput_uvw;

skybox_vert_output _skybox_vert_main(a2v_pos_only a)
{
    skybox_vert_output o;
    o.uvw = a.inputPosition;
    mat4 _matrix = _31.viewMatrix;
    _matrix[3].x = 0.0;
    _matrix[3].y = 0.0;
    _matrix[3].z = 0.0;
    vec4 pos = _31.projectionMatrix * (_matrix * vec4(a.inputPosition, 1.0));
    o.pos = pos.xyww;
    return o;
}

void main()
{
    a2v_pos_only a;
    a.inputPosition = a_inputPosition;
    a2v_pos_only param = a;
    skybox_vert_output flattenTemp = _skybox_vert_main(param);
    gl_Position = flattenTemp.pos;
    _entryPointOutput_uvw = flattenTemp.uvw;
}

