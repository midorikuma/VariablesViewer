from PIL import Image
#Texture Name
texname="display"
#Texture Size(8<=n<=256)
ts=(64,64)
#Digit Width
dw = 5
#Font Color (r,g,b)
fc = (255,255,255)

#Display Characters
#If you want to add variables to display,
#please add variables here and values.glsl.
# #Display Placement Text
#xPos,Text + (,VariableId,xSize,ySize)
display='display.txt'

dcsl = open(display, 'r', encoding='UTF-8').read().splitlines()
dcsl = [t.split(',,') for t in dcsl]
dcsl = [[t.split(',') for t in tt] for tt in dcsl]

#unused value
u=255
out = Image.new("RGBA", (64, 64), (u,u,u,u))

#main data output
fr=1
tsx=ts[0]-1
tsy=ts[1]-1
out.putpixel((0,0), (fr,tsx,tsy,u))
out.putpixel((tsx,0), (fr,tsx,tsy,u))
out.putpixel((0,tsy), (fr,tsx,tsy,u))
out.putpixel((tsx,tsy), (fr,tsx,tsy,u))

out.putpixel((1,0), (101,123,145,u))
out.putpixel((2,0), (dw,u,u,u))
out.putpixel((3,0), (tuple(fc)))

#convert
for i in range (0,len(dcsl)):
    oy=i+1
    for j in range (0,len(dcsl[i])):
        tmp=dcsl[i][j]
        ox=tmp[0]
        if ox!='':
            ox=int(ox)
            text=tmp[1]
            cs = [ord(c) for c in list(text)]
            cs = [39 if n==95 else n for n in cs] #_
            cs = [n-32 if 97<=n<=122 else n for n in cs] #a-z
            cs = [n-38 for n in cs]
            cs = [0 if n<0 or 52<n else n for n in cs] #SP
            lcs=len(cs)
            for k in range (0,lcs):
                #characters data output
                out.putpixel((ox+k,oy), (255,cs[k],u,u))
            if 2<len(tmp):
                ox=ox+lcs
                vn = int(tmp[2])
                ldx = int(tmp[3])
                ldy = int(tmp[4])
                if vn<200:
                    for dy in range (0,ldy):
                        y=oy+dy
                        for dx in range (0,ldx):
                            x=ox+dx*(dw+2)
                            for di in range (0,dw+1):
                                out.putpixel((x+di,y), (vn,dy*16+dx,di,u))
                            if dx<ldx-1:
                                out.putpixel((x+dw+1,y), (255,44-38,u,u))
                else:
                    vn=200+(vn-200)*2+1
                    for dy in range (0,ldy):
                        y=oy+dy
                        for dx in range (0,ldx):
                            x=ox+dx
                            if dx==dy==0:
                                out.putpixel((x,y), (vn-1,ldx,ldy,u))
                            else:
                                out.putpixel((x,y), (vn,dx,dy,u))

out.save(texname+".png")
