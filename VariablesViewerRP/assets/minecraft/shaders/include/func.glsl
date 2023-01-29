//Function VSH
#ifdef VSH
//Get sizecol
vec4 sizecol;
int type = 0;
vec2 sampsize = textureSize(Sampler0, 0);
if(sampsize.x <= 256 && sampsize.y <= 256) {
type = 1;
sizecol = texture(Sampler0, vec2(0, 0));
} else if(1024 <= sampsize.x && 1024 <= sampsize.y) {
type = 2;
sizecol = texture(Sampler0, UV0 - UV0 / sampsize);
}
sizecol *= 255;
//Flag Judgment
flag = 0;
if(sizecol.r == 1 && Vdrn <= vertexDistance && vertexDistance <= Vdrf) {
texsize = sizecol.gb + 1.001;
if(vec3(101, 123, 145) == load_color(Sampler0, texCoord0, texsize, ivec2(1, 0))) {
flag = 1;
//Get aspect
vec2 aspect = vec2(ProjMat[1][1], ProjMat[0][0]);
bool minxy = min(aspect.x, aspect.y) == aspect.x;
aspect = min(aspect.x, aspect.y) / aspect;
//Set texCoord0
int glVID = (gl_VertexID + Rotate) % 4;
if(Flip) glVID = glVID / 2 * 2 + (1 - glVID % 2);
vec2 normaluv = vec2(glVID / 2, sign(glVID % 3));
if(type == 1) {
texCoord0 = normaluv;
} else if(type == 2) {
texCoord0 = mod(UV0 * sampsize, texsize) / sampsize + floor(UV0 * sampsize / texsize) * texsize / sampsize;
}
//Set offset
vec2 offset = vec2(0.0);
if(gl_VertexID / 4 == Pid) {
for(int i = 0;
i < 4;
i ++) {
int ivx = vposx[i];
int ivy = vposy[i];
float ivxf = ivx == 1 && ! minxy ? ivx * aspect.x * 2.0 - 1.0 : ivx;
float ivyf = ivy == - 1 && minxy ? ivy * aspect.y * 2.0 + 1.0 : ivy;
offset = normaluv == vuv[i] ? vec2(ivxf, ivyf) : offset;
}
}
//Set Position
if(offset != vec2(0.0) && Pid != - 1) {
gl_Position = vec4(offset, 0, 1);
}
}
}
//Set out Variables
outPosition = Position;
outColor = Color;
outUV0 = UV0;
outUV1 = UV1;
outUV2 = UV2;
outNormal = Normal;
glVertexID = gl_VertexID;
glInstanceID = gl_InstanceID;
#endif

//Function FSH
#ifdef FSH
if(flag != 0.0) {
vec4 col = texture(Sampler0, texCoord0) * 255.0;
vec2 tpos = mod(texCoord0 * textureSize(Sampler0, 0), texsize);
if(col.rgb == vec3(255.0) || tpos.y <= 1.01 || texsize.y - 1.01 <= tpos.y) {
//Background
discard;
} else {
//Display
vec3 dcfs = load_color(Sampler0, texCoord0, texsize, vec2(2.0, 0.0));
vec3 dcfc = load_color(Sampler0, texCoord0, texsize, vec2(3.0, 0.0));
int type;
int vFloat=0;
int vInt=1;
int vPicture=200;
vec4 vs;
ivec2 a;
int vn = int(col.r);
if(vn < 200) {
//Assign Digit and Digit Length
vs.y = col.b;
vs.z = dcfs.r;
a = ivec2(int(col.g) % 16, col.g / 16);
} else if(vn % 2 == 0) {
vn = 200 + (vn - 200) / 2;
a = ivec2(col.gb);
col.gb = vec2(0.0);
} else if(vn != 255) {
vn = 200 + (vn - 200 - 1) / 2;
a = ivec2(load_color(Sampler0, texCoord0, texsize, floor(tpos) - col.gb).gb);
}
//in(vec4 col) -> out(vec4 vs,int type)
#moj_import <values.glsl>

if(type < 200) {
//Character
int n = (vn == 255) ? int(col.g) : convert_asciin(type, vs);
fragColor = vec4(dcfc/255.0, convert_character(Sampler0, texCoord0, n));
} else {
//Picture
fragColor = vs;
}
}
if(fragColor.a < 0.1 || ! gl_FrontFacing) {
discard;
}
}
#endif