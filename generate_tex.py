from PIL import Image

#Font Size (1/size)
fs = 1
#Digit Width
dw = 5
#Font Color (r,g,b,a)
fc = [255,255,255,255]

#Display Characters
#text("Text",xPos,yPos)
#variable(DisplayVariableNumber,xSize,ySize)
#If you want to add variables to display,
#please add variables here and values.glsl.
dcsl = [
    ["Shader Variables",1,1],
    ["ModelViewMat:",1,2],[0,4,4],
    ["ProjMat:",1,6],[1,4,4],
    ["IViewRotMat:",1,10],[2,3,3],
    ["ColorModulator:",1,14],[3,4,1],
    ["Light0_Direction:",1,15],[4,3,1],
    ["Light1_Direction:",1,16],[5,3,1],
    ["FogStart:",1,17],[6,1,1],
    ["FogEnd:",1,18],[7,1,1],
    ["FogColor:",1,19],[8,4,1],
    ["ScreenSize:",1,20],[9,2,1],
    ["GameTime:",1,21],[10,1,1],
    #["Sampler:",1,23],
    #["0",1,24],[200,20,20],
    #["1",17,24],[201,10,10],
    #["2",28,24],[202,10,10],

    #["Text",xPos,yPos],[11,xSize,ySize]
]

#unused value
u=255
out = Image.new("RGBA", (64, 64), (u,u,u,u))

#main data output
out.putpixel((0,0), (3,90,3,115))
out.putpixel((1,0), (fs,dw,0,255))
out.putpixel((2,0), tuple(fc))

#convert
for i in range (0,len(dcsl)):
    text=dcsl[i][0]
    if isinstance(text, str):
        cs = [ord(c) for c in list(text)]
        #print(cs)
        ox = dcsl[i][1]
        oy = dcsl[i][2]+1
        for j in range (0,len(cs)):
            #characters data output
            out.putpixel((ox+j,oy), (255,cs[j],u,u))
    #variable
    else:
        #print(dcsl[i])
        ox = dcsl[i-1][1]+len(dcsl[i-1][0])
        oy = dcsl[i-1][2]+1
        vn = dcsl[i][0]
        ldx = dcsl[i][1]
        ldy = dcsl[i][2]
        if vn<200:
            for dy in range (0,ldy):
                y=oy+dy
                for dx in range (0,ldx):
                    x=ox+dx*(dw+2)
                    for di in range (0,dw+1):
                        out.putpixel((x+di,y), (vn,dx,dy,255-di))
                    out.putpixel((x+dw+1,y), (255,44,u,u))
            out.putpixel((ox+ldx*(dw+2)-1,oy+ldy-1), (u,u,u,u))
        else:
            for dy in range (0,ldy):
                y=oy+dy
                for dx in range (0,ldx):
                    x=ox+dx
                    out.putpixel((x,y), (vn,dx,dy,255-max([ldx,ldy])))

out.save("display.png")
print("Texture generation complete!")
