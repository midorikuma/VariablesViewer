//https://github.com/midorikuma/VariablesViewer

switch(vn) {
//variables(vn:0-199,type:vFloat,vInt)
//If you want to add variables to display,
//please add variables here and display.txt
case 0 : vs.x = ModelViewMat[a.y][a.x];
type = vFloat;
break;
case 1 : vs.x = ProjMat[a.y][a.x];
type = vFloat;
break;
case 2 : vs.x = IViewRotMat[a.y][a.x];
type = vFloat;
break;
case 3 : vs.x = TextureMat[a.y][a.x];
type = vFloat;
break;
case 4 : vs.x = ScreenSize[a.x];
type = vInt;
break;
case 5 : vs.x = ColorModulator[a.x] * 255;
type = vInt;
break;
case 6 : vs.x = Light0_Direction[a.x];
type = vFloat;
break;
case 7 : vs.x = Light1_Direction[a.x];
type = vFloat;
break;
case 8 : vs.x = FogStart;
type = vInt;
break;
case 9 : vs.x = FogEnd;
type = vInt;
break;
case 10 : vs.x = FogColor[a.x] * 255;
type = vInt;
break;
case 11 : vs.x = FogShape;
type = vInt;
break;
case 12 : vs.x = LineWidth;
type = vInt;
break;
case 13 : vs.x = GameTime * 24000;
type = vInt;
break;
case 14 : vs.x = ChunkOffset[a.x];
type = vFloat;
break;

case 20 : vs.x = outPosition[a.x];
type = vFloat;
break;
case 21 : vs.x = outColor[a.x];
type = vFloat;
break;
case 22 : vs.x = outUV0[a.x];
type = vFloat;
break;
case 23 : vs.x = outUV1[a.x];
type = vInt;
break;
case 24 : vs.x = outUV2[a.x];
type = vInt;
break;
case 25 : vs.x = outNormal[a.x];
type = vFloat;
break;

case 30 : vs.x = vertexDistance;
type = vInt;
break;
case 31 : vs.x = vertexColor[a.x];
type = vFloat;
break;
case 32 : vs.x = texCoord0[a.x];
type = vFloat;
break;
case 33 : vs.x = texCoord1[a.x];
type = vFloat;
break;
case 34 : vs.x = texCoord2[a.x];
type = vFloat;
break;
case 35 : vs.x = normal[a.x];
type = vFloat;
break;

case 40 : vs.x = glVertexID / 4;
type = vInt;
break;
case 41 : vs.x = glInstanceID;
type = vInt;
break;
case 42 : vs.x = gl_FragCoord[a.x];
type = vFloat;
break;
case 43 : vs.x = gl_FrontFacing ? 1 : 0;
type = vInt;
break;
case 44 : vs.x = gl_PointCoord[a.x];
type = vFloat;
break;

//case 100 : vs.x = (Variable Name);
//type = (vFloat,vInt);
//break;

//samplers(vn:200-254,type:vPicture)
case 200 : vs = convert_picture(Sampler0, texCoord0, col.gb, a);
type = vPicture;
break;
case 201 : vs = convert_uvpos(Sampler0, texCoord0, outUV1, col.gb, a) ? vec4(0.0, 0.0, 0.0, 1.0) : convert_picture(Sampler1, texCoord0, col.gb, a);
type = vPicture;
break;
case 202 : vs = convert_uvpos(Sampler0, texCoord0, outUV2, col.gb, a) ? vec4(0.0, 0.0, 0.0, 1.0) : convert_picture(Sampler2, texCoord0, col.gb, a);
type = vPicture;
break;
}
