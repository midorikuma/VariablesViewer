//https://github.com/midorikuma/VariablesViewer

//Load color data
vec4 load_color(sampler2D Sampler0, vec2 texCoord0, vec2 pos) {
    vec2 texsize = textureSize(Sampler0, 0);
    vec2 tpos = floor(texCoord0 * 1024.0 / 64.0) * 64.0 + mod(texCoord0 * texsize, 64.0) / 64.0 + pos;
    return texture(Sampler0, tpos / texsize) * 255.0;
}

//Convert(col -> Picture Pixels)
vec4 convert_picture(sampler2D Sampler, vec2 texCoord0, vec4 col) {
    vec2 tpos = col.yz + mod(texCoord0 * textureSize(Sampler, 0), 1.0);
    return texture(Sampler, tpos / (255 - col.a));
}

//Digit Calculation
float exdigit(float v, float d) {
    float n = floor(mod(v, pow(10, d)) / pow(10, d - 1));
    n += 48;
    return n;
}
//Convert(Values -> ASCII Number)
float convert_asciin(int type, vec4 vs) {
    float n = 32;
    float v = vs.x;
    float digi = vs.y;
    float digitl = vs.z;
    if(v < 0.0) {
        if(digi == 0) {
            n = 45;
        }
        v = abs(v);
    }
    if(digi != 0) {
        //Display Float(example:1.0,0.123)
        if(type == 0) {
            if(digi == 2) {
                n = 46;
            } else {
                if(v < 1.0) {
                    float d = (digi == 1) ? 1 : 3 - digi;
                    n = exdigit(v, d);
                } else if(floor(v) == 1) {
                    n = (digi == 1) ? 49 : 48;
                } else {
                    n = 42;
                }

            }
        //Display Integer(example:100,12345)
        } else if(type == 1) {
            float d = digitl - digi + 1;
            n = (pow(10, d - 1) <= v) ? exdigit(v, d) : 32;
            if(v < 1.0) {
                n = (digi == digitl) ? 48 : 32;
            }
        }
    }
    return n;
}

//Convert(ASCII Number -> Character Pixels)
vec4 convert_character(sampler2D Sampler, vec2 texCoord, float n) {
    vec2 dpos = vec2(mod(n, 16.0), floor(n / 16.0));
    dpos += mod(texCoord * textureSize(Sampler, 0), 1.0);
    return texture(Sampler, dpos / 128.0);
}