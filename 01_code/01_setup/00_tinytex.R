# tinytex パッケージがなければ入れる
if (!requireNamespace("tinytex", quietly = TRUE)) {
  install.packages("tinytex")
}

# 既存の TeX 環境は削除せず、そのまま使う
library(tinytex)

# 論文コンパイルで必要な LaTeX パッケージだけを追加する
tinytex::tlmgr_install(c("tabularray", "ninecolors", "xparse"))
