from PIL import Image

text = open('dots.txt', 'r', encoding='UTF-8').read().splitlines()
dot = [s for s in text if ':' not in s]
dot = [list(v) for v in dot]
#for i in range(len(dot)):
#    for j in range(4):
#        b=(1-int(dot[i][j]))*255
#        out.putpixel((j,i+int(i/4)), (b,b,b,255))
dots=[]
tmp=0
for i in range(len(dot)):
    for j in range(4):
        tmp+=int(dot[i][j])*(2**(i%4*4+j))
    if i%4==3:
        dots.append(tmp)
        tmp=0
#print(dots)
print([hex(v) for v in dots])

u=255
out = Image.new("RGBA", (4, 5*len(dots)), (u,u,u,u))
for i in range(len(dots)):
    val=dots[i]
    for j in range(16):
        nval=val%(2**(j+1))
        b=(1-int(nval/(2**j)))*255
        out.putpixel((j%4,i*5+int(j/4)), (b,b,b,255))
out.save("dots.png")