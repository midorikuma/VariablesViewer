#version 150

#moj_import <fog.glsl>

#define FSH
#moj_import <converter.glsl>

void main() {
    vec4 color = texture(Sampler0, texCoord0);
    if(color.a < 0.1) {
        discard;
    }
    color *= vertexColor * ColorModulator;
    color.rgb = mix(overlayColor.rgb, color.rgb, overlayColor.a);
    color *= lightMapColor;
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);

    #moj_import <func.glsl>
}
