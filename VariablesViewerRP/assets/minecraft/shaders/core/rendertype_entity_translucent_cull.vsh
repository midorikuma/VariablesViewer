#version 150

#moj_import <light.glsl>
#moj_import <fog.glsl>
#moj_import <converter.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in vec2 UV1;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat3 IViewRotMat;
uniform int FogShape;

uniform vec3 Light0_Direction;
uniform vec3 Light1_Direction;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out vec2 texCoord1;
out vec2 texCoord2;
out vec4 normal;

//Additional parameters

uniform sampler2D Sampler0;
uniform vec2 ScreenSize;

out vec4 flagcol;
out vec4 datacol;
out vec4 fccol;
out vec2 outUV0;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    vertexDistance = fog_distance(ModelViewMat, IViewRotMat * Position, FogShape);
    vertexColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, Color) * texelFetch(Sampler2, UV2 / 16, 0);
    texCoord0 = UV0;
    texCoord1 = UV1;
    texCoord2 = UV2;
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);

    //Load color data
    flagcol = load_color(Sampler0, texCoord0, vec2(0.0, 0.0));
    datacol = load_color(Sampler0, texCoord0, vec2(1.0, 0.0));
    fccol = load_color(Sampler0, texCoord0, vec2(2.0, 0.0));
    outUV0 = UV0;
    //Display layer
    float vertDist = length((ModelViewMat * vec4(Position, 1.0)).xyz);
    if(flagcol == vec4(3.0, 90.0, 3.0, 115.0) && 1.049 < vertDist && vertDist < 1.051) {
        vec2 texsize = textureSize(Sampler0, 0);
        vec2 normaluv = ScreenSize / min(ScreenSize.x, ScreenSize.y);
        texCoord0 = (floor(UV0 * texsize / 64.0) * 64.0 + normaluv * mod(UV0 * texsize, 64.0)) / texsize;

        //Fix the display texture to the screen
        vec2 offset = vec2(0.0);
        float fs = 1.0 / datacol.r;
        switch(gl_VertexID % 32) {
            case 4:
                offset = vec2(-1, 1);
                break;
            case 5:
                offset = vec2(-1, -fs);
                break;
            case 6:
                offset = vec2(fs, -fs);
                break;
            case 7:
                offset = vec2(fs, 1);
                break;
        }
        if(offset != vec2(0.0)) {
            gl_Position = vec4(offset + vec2(0.0, 2.0 / 64.0), 0, 1);
        };
    }

}
