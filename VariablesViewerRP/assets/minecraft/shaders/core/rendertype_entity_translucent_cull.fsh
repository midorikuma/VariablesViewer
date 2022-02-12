#version 150

#moj_import <fog.glsl>
#moj_import <converter.glsl>

uniform sampler2D Sampler0;
uniform sampler2D Sampler1;
uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat3 IViewRotMat;
uniform vec4 ColorModulator;
uniform vec3 Light0_Direction;
uniform vec3 Light1_Direction;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;
uniform vec2 ScreenSize;
uniform float GameTime;

in float vertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;
in vec4 normal;

in vec4 flagcol;
in vec4 datacol;
in vec4 fccol;
in vec2 outUV0;

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
    if(color.a < 0.1) {
        discard;
    }
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);

    if(flagcol == vec4(3.0, 90.0, 3.0, 115.0)) {
        vec4 col = texture(Sampler0, texCoord0) * 255.0;
        if(col == vec4(255.0) || 64.0 * min(ScreenSize.x, ScreenSize.y) / ScreenSize.x <= mod(outUV0.x * textureSize(Sampler0, 0).x, 64.0)) {
            //Background
            discard;
        } else {
            //Display
            int type;
            vec4 vs;
            //in(vec4 col) -> out(vec4 vs,int type)
            #moj_import <values.glsl>
            if(type < 200) {
                //Character
                //type(-1:Text, 0:Float, 1:Integer)
                float n = (type == -1) ? vs.x : convert_asciin(type, vs);
                fragColor = convert_character(Sampler0, texCoord0, n).a * fccol;
            } else {
                //Picture
                fragColor = vs;
            }
        }
    }
}
