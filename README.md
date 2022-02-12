English | [日本語](https://github.com/midorikuma/VariablesViewer/blob/main/README-ja.md)
# Variables Viewer

This resource pack allows you to display the variables used in the shader on the screen.    
After applying the resource pack, holding an item obtained with the command `give @p minecraft:carrot_on_a_stick{CustomModelData:1}` will turn on the first-person view.  


## Changing the display

This shader can display up to x64 and y64 characters.  
The character coordinates are `(0,0)` from the top left and `(63,63)` from the bottom right.  
To change the display, edit `generate_tex.py` and `values.glsl`.  
This section will show you how to add variables to be displayed.
  
  
  
### ・generate_tex.py
Change the commented out `["Text",xPos,yPos]` and `[11,xSize,ySize]` in the dcsl list of the file.  
The size is filled with a number according to the array of variables.  
Example:  
-`vec3`:`[3,1]`   
-`mat4`:`[4,4]`   
  
Run `generate_tex.py` to generate `display.png` after adding variables (To run `generate_tex.py`, install Python and Pillow)  
Overwrite the generated `display.png` with `VariablesViewerRP\assets\minecraft\textures\item\custom_models\display.png`.
  
  
### ・values.glsl
Change `(Variable Name)`\* and `(0:Float, 1:Integer)` in `case 11..break;`,  
which are commented out at the bottom of `VariablesViewerRP\assets\minecraft\shaders\include\values.glsl`  

\*`(Variable Name)` needs to be an array number depending on the type of variable.  
Example:  
-`vec3` :`Variable Name[col.g]`  
-`mat4` :`Variable Name[col.b][col.g]`  
Also, make sure that the variables you want to display have already been declared in the json or fsh file.  
  
Finally, use F3+T to reload the resource pack to change the display.
