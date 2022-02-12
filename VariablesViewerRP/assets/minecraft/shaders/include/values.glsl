//https://github.com/midorikuma/VariablesViewer

//in(vec4 col) -> out(vec4 v,int type)
int ax = int(col.g);
int ay = int(col.b);
switch(int(col.r)) {

//variables(col.r:0-199,type:0-199)
//If you want to add variables to display,
//please add variables here and generate_tex.py.
case 0 : vs.x = ModelViewMat[ay][ax];
type = 0;
break;
case 1 : vs.x = ProjMat[ay][ax];
type = 0;
break;
case 2 : vs.x = IViewRotMat[ay][ax];
type = 0;
break;
case 3 : vs.x = ColorModulator[ax] * 255;
type = 1;
break;
case 4 : vs.x = Light0_Direction[ax];
type = 0;
break;
case 5 : vs.x = Light1_Direction[ax];
type = 0;
break;
case 6 : vs.x = FogStart;
type = 1;
break;
case 7 : vs.x = FogEnd;
type = 1;
break;
case 8 : vs.x = FogColor[ax] * 255;
type = 1;
break;
case 9 : vs.x = ScreenSize[ax];
type = 1;
break;
case 10 : vs.x = GameTime * 24000;
type = 1;
break;
//case 11 : vs.x = (Variable Name);
//type = (0:Float, 1:Integer);
//break;

//samplers(col.r:200-254,type:200-254)
case 200 : vs = convert_picture(Sampler0, texCoord0, col);
type = 200;
break;
case 201 : vs = convert_picture(Sampler1, texCoord0, col);
type = 200;
break;
case 202 : vs = convert_picture(Sampler2, texCoord0, col);
type = 200;
break;

//texts(col.r:255,type:-1)
case 255 : vs.x = ax;
type = - 1;
break;
}

//Assign Digit and Digit Length
if(col.r < 200) {
vs.y = 255 - col.a;
vs.z = datacol.g;
}