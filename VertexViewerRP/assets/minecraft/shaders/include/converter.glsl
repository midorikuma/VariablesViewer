//https://github.com/midorikuma/VariablesViewer
#ifdef VSH
out float glVertexID;
out vec2 normaluv;
#endif

#ifdef FSH
in float glVertexID;
in vec2 normaluv;
#endif

const int dots[] = int[](0xfbdf, 0xf464, 0xf496, 0xf8ef, 0x4f51, 0xfc3f, 0xfd3f, 0x248f, 0x75ae, 0xfcbf, 0x0);

//Digit Calculation
int exdigit(float v, float d) {
    float n = floor(mod(v, pow(10, d)) / pow(10, d - 1));
    return int(n);
}
//Convert(Values -> ASCII Number)
int convert_asciin(vec3 vs) {
    int n = 0;
    float v = vs.x;
    float digi = vs.y;
    float digitl = vs.z;
    float d = digitl - digi + 1;
    n = (pow(10, d - 1) <= v) ? exdigit(v, d) : 10;
    if(v < 1.0) {
        n = (digi == digitl) ? 0 : 10;
    }
    return n;
}

bool convert_character(sampler2D Sampler, vec2 texCoord, vec2 uvs, float ts, int n) {
    vec2 tpos = texCoord * 16;
    bool tf = all(lessThan(uvs, tpos)) && all(lessThan(tpos, uvs + vec2(ts)));
    ivec2 p = ivec2(fract((tpos + uvs) / ts) * 5.0);
    bool pd = all(lessThan(p, vec2(4.0)));
    float j = p.y * 4 + p.x;
    float nval = mod(float(dots[n]), exp2(j + 1));
    bool nf = floor(nval / exp2(j)) == 1;
    return tf && pd && nf;
}
