//Function VSH
#ifdef VSH
    //Get sizecol
    vec2 sampsize = textureSize(Sampler0, 0);
    vec2 offsetUV = 63*floor(UV0*sampsize/64)/sampsize;
    vec2 offuv0 = UV0/64+offsetUV;
    flag = float(texture(Sampler0, offuv0)*255==vec4(12, 34, 56, 78));
    texsize = vec2(texture(Sampler0, offuv0+vec2(1,0)/sampsize).g*255);
    
    if(flag != 0.0 && Vdrn <= vertexDistance && vertexDistance <= Vdrf) {
        //Get aspect
        vec2 aspect = vec2(ProjMat[1][1], ProjMat[0][0]);
        bool minxy = min(aspect.x, aspect.y) == aspect.x;
        aspect = min(aspect.x, aspect.y) / aspect;
        //Set texCoord0
        int glVID = (gl_VertexID + Rotate) % 4;
        if(Flip) glVID = glVID / 2 * 2 + (1 - glVID % 2);
        vec2 normaluv = vec2(glVID / 2, sign(glVID % 3));
        texCoord0 = offsetUV+normaluv*texsize/sampsize;
        
        //Set offset Vertex
        vec2 offsetV = vec2(0.0);
        if(gl_VertexID / 4 == Pid) {
            for(int i = 0; i < 4; i ++) {
                int ivx = vposx[i];
                int ivy = vposy[i];
                float ivxf = ivx == 1 && ! minxy ? ivx * aspect.x * 2.0 - 1.0 : ivx;
                float ivyf = ivy == - 1 && minxy ? ivy * aspect.y * 2.0 + 1.0 : ivy;
                offsetV = normaluv == vuv[i] ? vec2(ivxf, ivyf) : offsetV;
            }
            gl_Position = vec4(offsetV, 0, 1);
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
        if(col.rgb == vec3(255.0) || tpos.y <= 1.01 || texsize.y - 1.01 <= tpos.y || !gl_FrontFacing) {
            //Background
            discard;
        } else {
            //Display
            vec3 dcfs = load_color(Sampler0, texCoord0, texsize, vec2(1.0, 0.0));
            vec3 dcfc = load_color(Sampler0, texCoord0, texsize, vec2(2.0, 0.0));
            int type;
            int vFloat=0;
            int vInt=1;
            int vTexture=200;
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
        if(fragColor.a < 0.1) {
            discard;
        }
    }
#endif