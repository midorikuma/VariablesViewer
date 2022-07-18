//Function VSH
#ifdef VSH
int glVID = gl_VertexID % 4;
normaluv = vec2(glVID / 2, sign(glVID % 3));
glVertexID = (gl_VertexID + 3) / 4;
#endif

//Function FSH
#ifdef FSH
vec4 charcol = vec4(1);
fragColor = convert_character(Sampler0, normaluv, vec2(0.0, 0.0), 2.0, 0) ? charcol : fragColor;
fragColor = convert_character(Sampler0, normaluv, vec2(0.0, 14.0), 2.0, 1) ? charcol : fragColor;
fragColor = convert_character(Sampler0, normaluv, vec2(14.0, 14.0), 2.0, 2) ? charcol : fragColor;
fragColor = convert_character(Sampler0, normaluv, vec2(14.0, 0.0), 2.0, 3) ? charcol : fragColor;

charcol = vec4(vec3(glVertexID / 1000), 1.0);
int dn = convert_asciin(vec3(glVertexID, 1.0, 3.0));
fragColor = convert_character(Sampler0, normaluv, vec2(2.0, 6.0), 4.0, dn) ? charcol : fragColor;
dn = convert_asciin(vec3(glVertexID, 2.0, 3.0));
fragColor = convert_character(Sampler0, normaluv, vec2(6.0, 6.0), 4.0, dn) ? charcol : fragColor;
dn = convert_asciin(vec3(glVertexID, 3.0, 3.0));
fragColor = convert_character(Sampler0, normaluv, vec2(10.0, 6.0), 4.0, dn) ? charcol : fragColor;

if(fragColor.a < 0.5) {
discard;
}
#endif