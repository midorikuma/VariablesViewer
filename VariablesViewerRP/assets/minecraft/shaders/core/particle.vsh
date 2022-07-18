#version 150

#moj_import <fog.glsl>

#define VSH
#define PID 0
#define ROTATE 2
#moj_import <converter.glsl>

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    vertexDistance = fog_distance(ModelViewMat, Position, FogShape);
    texCoord0 = UV0;
    vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);

    #moj_import <func.glsl>
}
