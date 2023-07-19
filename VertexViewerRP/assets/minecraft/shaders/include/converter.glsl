//https://github.com/midorikuma/VariablesViewer
#ifdef VSH
out vec2 glUV;
out float glFID;
#endif

#ifdef FSH
in vec2 glUV;
in float glFID;

const int dots[] = int[](0xfbdf, 0xf464, 0xf496, 0xf8ef, 0x4f51, 0xfc3f, 0xfd3f, 0x248f, 0x75ae, 0xfcbf, 0x0);

int convert_character(vec2 texCoord, vec2 uvs, float ts, int n) {
    vec2 tpos = texCoord * 16;
    bool tf = all(lessThan(uvs, tpos)) && all(lessThan(tpos, uvs + vec2(ts)));
    ivec2 p = ivec2(fract((tpos + uvs) / ts) * 5.0);
    bool pd = all(lessThan(p, vec2(4.0)));
    float j = p.y * 4 + p.x;
    float nval = mod(float(dots[n]), exp2(j + 1));
    bool nf = floor(nval / exp2(j)) == 1;
    return int(tf && pd && nf);
}
#endif
