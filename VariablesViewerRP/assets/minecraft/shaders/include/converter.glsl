//https://github.com/midorikuma/VariablesViewer

//Uniform Variables
uniform sampler2D Sampler0;
uniform sampler2D Sampler1;
uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat3 IViewRotMat;
uniform mat4 TextureMat;
uniform vec2 ScreenSize;
uniform vec4 ColorModulator;
uniform vec3 Light0_Direction;
uniform vec3 Light1_Direction;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;
uniform int FogShape;
uniform float LineWidth;
uniform float GameTime;
uniform vec3 ChunkOffset;

//VSH Variables
#ifdef VSH
#ifdef PID
const int Pid = PID;
#else
const int Pid = -1;
#endif
#ifdef VDRn
const float Vdrn = VDRn;
#else
const float Vdrn = 0.0;
#endif
#ifdef VDRf
const float Vdrf = VDRf;
#else
const float Vdrf = 2000.0;
#endif
#ifdef FLIP
const bool Flip = FLIP;
#else
const bool Flip = false;
#endif
#ifdef ROTATE
const int Rotate = ROTATE;
#else
const int Rotate = 0;
#endif

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV1;
in ivec2 UV2;
in vec3 Normal;
out vec3 outPosition;
out vec4 outColor;
out vec2 outUV0;
out vec2 outUV1;
out vec2 outUV2;
out vec3 outNormal;
out float flag;
out vec2 texsize;
out float glVertexID;
out float glInstanceID;

out float vertexDistance;
out vec4 vertexColor;
out vec4 lightMapColor;
out vec4 overlayColor;
out vec2 texCoord0;
out vec2 texCoord1;
out vec2 texCoord2;
out vec4 normal;
#endif

//FSH Variables
#ifdef FSH
in vec3 outPosition;
in vec4 outColor;
in vec2 outUV0;
in vec2 outUV1;
in vec2 outUV2;
in vec3 outNormal;
in float flag;
in vec2 texsize;
in float glVertexID;
in float glInstanceID;

in float vertexDistance;
in vec4 vertexColor;
in vec4 lightMapColor;
in vec4 overlayColor;
in vec2 texCoord0;
in vec2 texCoord1;
in vec2 texCoord2;
in vec4 normal;

out vec4 fragColor;
#endif

//Construct Variables
const ivec4 vposx = ivec4(-1, -1, 1, 1);
const ivec4 vposy = ivec4(1, -1, -1, 1);
const vec2 vuv[] = vec2[](vec2(0, 0), vec2(0, 1), vec2(1, 1), vec2(1, 0));
const int dots[] = int[](0x0, 0xf000, 0x4224, 0x2442, 0xa4a, 0x4e40, 0x4400, 0xe00, 0x400, 0x1248, 0xfbdf, 0xf464, 0xf496, 0xf8ef, 0x4f51, 0xfc3f, 0xfd3f, 0x248f, 0x75ae, 0xfcbf, 0x404, 0x4404, 0x424, 0xf0f, 0x242, 0x4496, 0xedb6, 0x9f96, 0xfb57, 0xe11e, 0x7997, 0xf17f, 0x171f, 0xed1e, 0x99f9, 0x7227, 0x254f, 0x9535, 0x7111, 0x99df, 0x9db9, 0x6996, 0x1797, 0xed96, 0x9797, 0x7c3e, 0x222f, 0x6999, 0x2255, 0xfd99, 0x9669, 0x22f9, 0xf24f);


//Converters
//Load color data
vec3 load_color(sampler2D Sampler0, vec2 texCoord0, vec2 texsize, vec2 pos) {
    vec2 sampsize = textureSize(Sampler0, 0);
    vec2 tpos = floor(texCoord0 * sampsize / texsize) * texsize + pos;
    return texture(Sampler0, tpos / sampsize).rgb * 255.0;
}

//Convert(col -> Texture Pixels)
vec4 convert_texture(sampler2D Sampler, vec2 texCoord0, vec2 p, vec2 pl) {
    vec2 tpos = p + mod(texCoord0 * textureSize(Sampler, 0), 1.0);
    return texture(Sampler, vec2(tpos / pl));
}

//Convert(col -> Texture Pixels)
bool convert_uvpos(sampler2D Sampler0, vec2 texCoord0, vec2 outUV, vec2 p, vec2 pl) {
    vec2 tpos = (p + mod(texCoord0 * textureSize(Sampler0, 0), 1.0)) / pl;
    bool f1 = outUV.x / (16 * 16) < tpos.x && outUV.y / (16 * 16) < tpos.y;
    bool f2 = tpos.x < (outUV.x + 16) / (16 * 16) && tpos.y < (outUV.y + 16) / (16 * 16);
    return (f1 && f2);
}

//Digit Calculation
int exdigit(float v, float d) {
    float n = floor(mod(v, pow(10, d)) / pow(10, d - 1));
    n += 10;
    return int(n);
}
//Convert(Values -> ASCII Number)
int convert_asciin(int type, vec4 vs) {
    int n = 0;
    float v = vs.x;
    float digi = vs.y;
    float digitl = vs.z;
    if(v < 0.0) {
        if(digi == 0) {
            n = 7;
        }
        v = abs(v);
    }
    if(digi != 0) {
        //Display Float(example:1.0,0.123)
        if(type == 0) {
            if(digi == 2) {
                n = 8;
            } else {
                if(fract(v) < 0.0 || 0.0 < fract(v)) {
                    float d = (digi == 1) ? 1 : 3 - digi;
                    n = exdigit(v, d);
                } else {
                    n = (digi == 1) ? int(v) % 10 + 10 : 10;
                }

            }
        //Display Integer(example:100,12345)
        } else if(type == 1) {
            float d = digitl - digi + 1;
            n = (pow(10, d - 1) <= v) ? exdigit(v, d) : 0;
            if(v < 1.0) {
                n = (digi == digitl) ? 10 : 0;
            }
        }
    }
    return n;
}

//Convert(ASCII Number -> Character Pixels)
float convert_character(sampler2D Sampler, vec2 texCoord, int n) {
    ivec2 p = ivec2(fract(texCoord * textureSize(Sampler, 0)) * 5.0);
    bool pd = p.x < 4.0 && p.y < 4.0;
    float j = p.y * 4 + p.x;
    float nval = mod(float(dots[n]), exp2(j + 1));
    return pd ? floor(nval / exp2(j)) : 0;
}
