# sg_godot_graph_plotter
## ちゃんとしたのをあとで書く事!
## インストール
* sg_godot_graph_plotterフォルダをaddonフォルダに...
## 設定方法
* SGGodotGraphPlotterというNodeが作れるようになってます。
* グラフの全体設定はSGGodotGraphPlotterのインスペクタに(分かりづらい設定が)あり〼。
* グリッドの色、グラフの線幅等、スケールの文字等は該当のChildNodeで変更のこと。
## グラフの書き方
1. set_to_plot(value)に書きたい関数をラムダ式、もしくは配列で渡す。
  ### 例
  * set_to_plot(func(x): return sin(x))
  * set_to_plot([Vector2(-100, -100), Vector2(100, 100)])
  * など
2. plot()
3. 以上
## サンプルコードをそのうち書く。
