//Function VSH
#ifdef VSH
    int glVID = gl_VertexID % 4;
    glUV = vec2(glVID / 2, sign(glVID % 3));
    glFID = (gl_VertexID + 3) / 4;
#endif

//Function FSH
#ifdef FSH
    int iCorner = 0;
    iCorner += convert_character(glUV, vec2(0, 0), 2.0, 0);
    iCorner += convert_character(glUV, vec2(0, 14), 2.0, 1);
    iCorner += convert_character(glUV, vec2(14, 14), 2.0, 2);
    iCorner += convert_character(glUV, vec2(14, 0), 2.0, 3);
    fragColor = mix(fragColor, vec4(1), sign(iCorner));

    int iglFID = int(glFID);
    ivec4 glFIDs = ivec4(iglFID/100,iglFID%100/10,iglFID%10,iglFID);
    glFIDs.y = glFIDs.xy==ivec2(0) ? 10 : glFIDs.y;
    glFIDs.x = glFIDs.x==0 ? 10 : glFIDs.x;
    int iCenter = 0;
    iCenter += convert_character(glUV, vec2(2, 6), 4.0, glFIDs.x);
    iCenter += convert_character(glUV, vec2(6, 6), 4.0, glFIDs.y);
    iCenter += convert_character(glUV, vec2(10, 6), 4.0, glFIDs.z);
    fragColor = mix(fragColor, vec4(vec3(glFIDs.w)/1000, 1), sign(iCenter));

    if(fragColor.a < 0.1) {
        discard;
    }
#endif