from PIL import Image

# Texture Name
texname = "display"
# Digit Width
dw = 5
# Font Color (r,g,b)
fc = (255, 255, 255)

# If you want to add variables to display,
# please add variables to .txt and values.glsl.
# Display Text Format
# xPos,Text + ,VariableId,xSize,ySize
display = texname + ".txt"
dcsl = open(display, "r", encoding="UTF-8").read().splitlines()
dcsl = [t.split(",,") for t in dcsl]
dcsl = [[t.split(",") for t in tt] for tt in dcsl]

# auto setting texture size
dlxs = []
dlys = []
for y, tt in enumerate(dcsl):
    for t in tt:
        if 1 < len(t):
            dly = y + 1
            dlx = int(t[0]) + len(t[1])
            if 2 < len(t):
                dly += int(t[4]) - 1
                if 200 <= int(t[2]):
                    dlx += int(t[3])
                else:
                    dlx += int(t[3]) * (dw + 2)
                if int(t[4]) < 2:
                    dlx -= 1
            dlys.append(dly + 2)
            dlxs.append(dlx)
dl = max(max(dlys), max(dlxs))
dl += (8 - dl % 8) % 8

# main data output
u = 255
out = Image.new("RGBA", (64, 64), (u, u, u, u))

out.putpixel((0, 0), (12, 34, 56, 78))
out.putpixel((1, 0), (dw, dl, u, u))
out.putpixel((2, 0), (tuple(fc)))

# convert
for i in range(0, len(dcsl)):
    oy = i + 1
    for j in range(0, len(dcsl[i])):
        tmp = dcsl[i][j]
        ox = tmp[0]
        if ox != "":
            ox = int(ox)
            text = tmp[1]
            cs = [ord(c) for c in list(text)]
            cs = [39 if n == 95 else n for n in cs]  # _
            cs = [n - 32 if 97 <= n <= 122 else n for n in cs]  # a-z
            cs = [n - 38 for n in cs]
            cs = [0 if n < 0 or 52 < n else n for n in cs]  # SP
            lcs = len(cs)
            for k in range(0, lcs):
                # characters data output
                out.putpixel((ox + k, oy), (255, cs[k], u, u))
            if 2 < len(tmp):
                ox = ox + lcs
                vn = int(tmp[2])
                ldx = int(tmp[3])
                ldy = int(tmp[4])
                if vn < 200:
                    for dy in range(0, ldy):
                        y = oy + dy
                        for dx in range(0, ldx):
                            x = ox + dx * (dw + 2)
                            for di in range(0, dw + 1):
                                out.putpixel((x + di, y), (vn, dy * 16 + dx, di, u))
                            if dx < ldx - 1:
                                out.putpixel((x + dw + 1, y), (255, 44 - 38, u, u))
                else:
                    vn = 200 + (vn - 200) * 2 + 1
                    for dy in range(0, ldy):
                        y = oy + dy
                        for dx in range(0, ldx):
                            x = ox + dx
                            if dx == dy == 0:
                                out.putpixel((x, y), (vn - 1, ldx, ldy, u))
                            else:
                                out.putpixel((x, y), (vn, dx, dy, u))

out.save(texname + ".png")
