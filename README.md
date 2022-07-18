English | [日本語](https://github.com/midorikuma/VariablesViewer/blob/main/README-ja.md)
# Resource Packs
This resource pack allows you to view the variables used in the shaders on the screen.  
`Vertex Viewer` shows the vertex numbers for each face.  
`Variables Viewer` allows you to view the values of the variables used in the core shader.   
Four core shader objects are available to view variables by default.  
・particle  
・rendertype_entity_cutout_no_cull  
・rendertype_entity_translucent_cull  
・rendertype_solid  

## Vertex Viewer
The Vertex Viewer allows you to see the vertex numbers.  
The face number (p) is displayed in the center, and the local vertex numbers 0-3 (c) for that face are displayed in the four corners.  
![2022-07-18_23 02 01](https://user-images.githubusercontent.com/39437361/179535824-e730874a-ca92-4f3d-8c44-31a376366dcf.png)
The global vertex number (gl_VertexID) of the displayed vertex can also be determined from the following formula.  
`Global vertex number(gl_VertexID) = Face number(p) * 4 + Local vertex number(c)`  

## Variable Viewer
The Variable Viewer allows you to see the values of variables used in core shaders.  
![2022-07-18_23 05 53](https://user-images.githubusercontent.com/39437361/179535868-7936b712-80ab-4bc8-a7ec-1cdf69163f4d.png)
Four core shader objects are available to view variables by default.  
・block_marker particle of wraped_planks  
・pig mob  
・customized carrot_on_a_stick  
・block of wraped_planks  
The command `get.mcfunction` can be used to obtain or summon an object.  


# Advanced Settings
## Addition of core shaders
These resource packs allow you to add some of the core shaders to be displayed later.  
After adding the vanilla core shader files (json, vsh, fsh) you wish to add to the resource pack, you can add them by modifying or appending the respective files.  
See `add.txt` in each resource pack core and existing core shaders for details.  


## Changing the display
Variable Viewer can display characters up to 8-256 characters in height and width.  
To change the display, edit `display.txt` and `values.glsl`.  
This section will show you how to add variables to be displayed.  
  
### display.txt
The display is made roughly based on `display.txt`.  
The notations are as follows  
`[xPos,Text,Variable identification number,xSize,ySize]`  
The yPos is determined from the number of lines in the txt file.  
![Comparison](https://user-images.githubusercontent.com/39437361/179535920-322bb81a-c4f8-45e9-af4b-23ebe09e8d51.png)
A comma followed by (,,) indicates the end of the notation, and a comma followed by  
In the case of `[xPos,Text]`, which omits the variable number and after, only the text is displayed.  
The number to be included in the xy size depends on the type of variable.  
Example:  
-`vec3`:`~,3,1]`   
-`mat4`:`~,4,4]`   
This time add the following notation to the end of the txt  
`[22,(Variable Name),100,(xSize),(ySize)]`  
Save the txt file in the above format and load it from generate_tex.py.  
  
### ・generate_tex.py
Run `generate_tex.py` to generate `display.png` after adding variables (To run `generate_tex.py`, install Python and Pillow)  
Overwrite the generated `display.png` with texture of the object whose display you want to change under `VariablesViewerRP\assets\minecraft\textures\..`  
  
### ・values.glsl
Change `(Variable Name)`\* and `(vFloat, vInt)` in `case 100..break;`,  
which are commented out at the bottom of `VariablesViewerRP\assets\minecraft\shaders\include\values.glsl`  
\*`(Variable Name)` needs to be an array number depending on the type of variable.  
Example:  
-`vec3` :`(Variable Name)[ax]`  
-`mat4` :`(Variable Name)[ay][ax]`  
Also, make sure that the variables you want to display have already been declared in the FSH file.  
  
Finally, use F3+T to reload the resource pack to change the display.  
