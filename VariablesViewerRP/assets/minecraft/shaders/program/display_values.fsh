#version 150

uniform sampler2D DiffuseSampler;
uniform sampler2D InputSampler;

uniform mat4 ProjMat;
uniform vec2 InSize;
uniform vec2 OutSize;
uniform float Time;
uniform vec2 ScreenSize;

in vec2 texCoord;

out vec4 fragColor;

//Construct Variables
const int dots[] = int[](0x0, 0xf000, 0x4224, 0x2442, 0xa4a, 0x4e40, 0x4400, 0xe00, 0x400, 0x1248, 0xfbdf, 0xf464, 0xf496, 0xf8ef, 0x4f51, 0xfc3f, 0xfd3f, 0x248f, 0x75ae, 0xfcbf, 0x404, 0x4404, 0x424, 0xf0f, 0x242, 0x4496, 0xedb6, 0x9f96, 0xfb57, 0xe11e, 0x7997, 0xf17f, 0x171f, 0xed1e, 0x99f9, 0x7227, 0x254f, 0x9535, 0x7111, 0x99df, 0x9db9, 0x6996, 0x1797, 0xed96, 0x9797, 0x7c3e, 0x222f, 0x6999, 0x2255, 0xfd99, 0x9669, 0x22f9, 0xf24f);

//Converters
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


void main() {
    vec4 ScaledTexel = texture2D(DiffuseSampler, texCoord);
    vec2 size = min(ScreenSize.x,ScreenSize.y)/ScreenSize;
    vec2 texCoord0 = (vec2(texCoord.x*2.0,1.0)-texCoord)/size;
    vec4 col = texture2D(InputSampler, texCoord0) * 255.0;
    vec4 sizecol = texture(InputSampler, vec2(0, 0)) * 255.0;
    vec2 texsize = sizecol.gb + 1.001;
    vec2 tpos = texCoord0*texsize;
    if(col.rgb != vec3(255.0) && texCoord.x<size.x && 1.01 < tpos.y && tpos.y<texsize.y-1.01){
        vec3 dcfs = texture(InputSampler, vec2(2.01, 0.0)/texsize).rgb*255.0;
        vec3 dcfc = texture(InputSampler, vec2(3.01, 0.0)/texsize).rgb;
        int vn = int(col.r);
        int type;
        int vFloat = 0;
        int vInt = 1;
        vec4 vs;
        ivec2 a;
        vs.y = col.b;
        vs.z = dcfs.r;
        a = ivec2(int(col.g) % 16, col.g / 16);
        switch(vn) {
            case 1 : vs.x = ProjMat[a.y][a.x];
            type = vFloat;
            break;
            case 2 : vs.x = InSize[a.x];
            type = vInt;
            break;
            case 3 : vs.x = OutSize[a.x];
            type = vInt;
            break;
            case 4 : vs.x = Time;
            type = vFloat;
            break;
            case 5 : vs.x = ScreenSize[a.x];
            type = vInt;
            break;
        }
        int n = (vn == 255) ? int(col.g) : convert_asciin(type, vs);
        fragColor = vec4(dcfc, convert_character(InputSampler, texCoord0, n));
        if(fragColor.a==0.0) fragColor = ScaledTexel;
    }else{
        fragColor = ScaledTexel;
    }
}
