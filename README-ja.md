日本語 | [English](https://github.com/midorikuma/VariablesViewer/blob/main/README.md)
# リソースパック
coreシェーダーで使われている変数を画面上に表示することができます。  
`Vertex Viewer`では各面の頂点番号を  
`Variables Viewer`ではcoreシェーダー内で使われている変数の値を表示することができます。  
デフォルトで変数を見ることのできるcoreシェーダーの対象物は  
・particle：パーティクル  
・rendertype_entity_cutout_no_cull：エンティティ  
・rendertype_entity_translucent_cull：一部透過アイテム  
・rendertype_solid：非透過ブロック  
の四種類となっています。  

## Vertex Viewer
Vertex Viewerでは頂点番号を見ることができます。  
中央には面番号(p)、四隅にはその面におけるローカルの頂点番号0-3(c)が表示されています。  
![2022-07-18_23 02 01](https://user-images.githubusercontent.com/39437361/179535824-e730874a-ca92-4f3d-8c44-31a376366dcf.png)
また以下の式から表示されている頂点のグローバルな頂点番号(gl_VertexID)を特定することができます。  
`グローバルの頂点番号(gl_VertexID) = 面番号(p) * 4 + ローカルの頂点番号(c)`  

## Variables Viewer
Variables Viewerではcoreシェーダーで使われている変数の値を見ることができます。  
![2022-07-18_23 05 53](https://user-images.githubusercontent.com/39437361/179535868-7936b712-80ab-4bc8-a7ec-1cdf69163f4d.png)
デフォルトで変数を見ることのできるcoreシェーダーの対象物は  
・歪んだ木材のblock_markerパーティクル  
・豚  
・特殊なニンジン付きの棒  
・歪んだ木材  
の四つとなっています。  
`get.mcfunction`のコマンドを使用することで対象物の入手、召喚を行うことができます。  


# 高度な設定
## coreシェーダーの追加
これらのリソースパックでは表示するcoreシェーダーを後から一部追加することができます。  
追加したいバニラのcoreシェーダーのファイル(json,vsh,fsh)をリソースパック内に追加後  
それぞれのファイルの変更、追記を行うことで追加できます。  
詳しくは各リソースパックcore内にある`add.txt`と既存のcoreシェーダーを参照してください。  


## 表示の変更について
Variable Viewerでは文字を縦横幅8-256文字分まで表示することができます。  
表示を変えるには`display.txt`と`values.glsl`の編集を行って下さい  
ここでは表示される変数を追加する方法について紹介します。  
  
### ・display.txt
画面上の表示は大まかに`display.txt`を元にして作られています。  
表記については以下のようになっています  
`[x位置,表示テキスト,変数判別用番号,xサイズ,yサイズ]`  
またy位置に関してはtxtファイルの行数位置から判別しています。  
![Comparison](https://user-images.githubusercontent.com/39437361/179535920-322bb81a-c4f8-45e9-af4b-23ebe09e8d51.png)
カンマが連続した場合(,,)は表記の終わりを表し、  
変数番号以降を省略した`[x位置,表示テキスト]`の場合はテキストのみの表示となります  
またxyサイズに入れる数値は変数の種類により異なります  
例：  
-`vec3` の時:`~,3,1]`  
-`mat4` の時:`~,4,4]`  
今回は以下の表記をtxtの末尾に追加して下さい  
`[22,"変数名",100,"xサイズ","yサイズ"]`  
以上の形式でtxtを保存し、generate_tex.pyから読み込みます。  
  
### ・generate_tex.py
`generate_tex.py`を実行し`display.png`を生成します  
(`generate_tex.py`を実行するには Python と Pillow を導入して下さい)  
生成された`display.png`を`VariablesViewerRP\assets\minecraft\textures\..`以下にある  
表示を変更したい対象物のテクスチャへ上書きします。  
  
### ・values.glsl
`VariablesViewerRP\assets\minecraft\shaders\include\values.glsl`を編集します  
下部でコメントアウトされている`case 100..break;`の三行のうち  
`(Variable Name)`に表示する変数名を  
`(vFloat, vInt)`をその変数の表示に合ったもの(小数表示はvFloat、整数表示はvInt)へ変えます。  

※`(Variable Name)`は変数の種類によっては配列番号を指定する必要があります  
例：  
-`vec3` の時:`(Variable Name)[ax]`  
-`mat4` の時:`(Variable Name)[ay][ax]`  
またこれらの表示を行いたい変数については、既にFSHファイルで宣言済みであることを確認して下さい。  
  
最後に F3+T 等でリソースパックを再読み込みすることで表示が変更されます。  
