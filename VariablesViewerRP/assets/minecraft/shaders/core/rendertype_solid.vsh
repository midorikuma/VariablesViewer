#version 150

#moj_import <light.glsl>
#moj_import <fog.glsl>

#define VSH
#define PID 0
#moj_import <converter.glsl>

void main() {
    vec3 pos = Position + ChunkOffset;
    gl_Position = ProjMat * ModelViewMat * vec4(pos, 1.0);

    vertexDistance = fog_distance(ModelViewMat, pos, FogShape);
    vertexColor = Color * minecraft_sample_lightmap(Sampler2, UV2);
    texCoord0 = UV0;
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);

    #moj_import <func.glsl>
}
