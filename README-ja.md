日本語 | [English](https://github.com/midorikuma/VariablesViewer/blob/main/README.md)
# Variables Viewer
![2022-02-12_10 57 382](https://user-images.githubusercontent.com/39437361/153692863-3813a80b-f5dd-4547-9a0a-9af7e1f12d20.png)
このリソースパックでは、シェーダーで使われている変数を画面上に表示することができます。  
リソースパックを適用後、コマンド`give @p minecraft:carrot_on_a_stick{CustomModelData:1}`で  
入手したアイテムを手に持つと一人称視点で表示が ON になります。  



## 表示の変更について

このシェーダーでは文字を x64,y64 文字まで表示することができます  
文字座標は左上から`(0,0)`となっており右下は`(63,63)`となっています  
表示を変えるには`generate_tex.py`と`values.glsl`の編集を行って下さい  
ここでは表示される変数を追加する方法について紹介します。
  
  
  
### ・generate_tex.py

ファイルの dcsl リスト内にコメントアウトされている  
`["Text",xPos,yPos]`に`["表示テキスト",x 位置,y 位置]`を  
`[11,xSize,ySize]`に`[変数判別用番号(1 つ追加の場合は 11),x サイズ,y サイズ]`を入力します  
サイズに入れる数値は変数の種類により異なります  
例：  
-`vec3` の時:`[3,1]`  
-`mat4` の時:`[4,4]`
  
変数追加後に`generate_tex.py`を実行し`display.png`を生成します  
(`generate_tex.py`を実行するには Python と Pillow を導入して下さい)  
生成された`display.png`を`VariablesViewerRP\assets\minecraft\textures\item\custom_models\display.png`へ上書きします。
  
  
### ・values.glsl

`VariablesViewerRP\assets\minecraft\shaders\include\values.glsl`を編集します  
下部でコメントアウトされている`case 11..break;`の三行のうち  
`(Variable Name)`に表示する変数名を  
`(0:Float, 1:Integer)`をその変数の表示に合った番号(0 なら小数表示、1 なら整数表示)へ変えます。

※`(Variable Name)`は変数の種類によっては配列番号を指定する必要があります  
例：  
-`vec3` の時:`変数名[col.g]`  
-`mat4` の時:`変数名[col.b][col.g]`  
またこれらの表示を行いたい変数については、既に json や fsh ファイルで宣言済みであることを確認して下さい。  
  
最後に F3+T 等でリソースパックを再読み込みすることで表示が変更されます。
