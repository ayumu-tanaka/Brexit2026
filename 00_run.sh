#!/bin/bash

# エラーが出たら停止
set -e

# このファイルがある場所に移動
cd "$(dirname "$0")"

# 初回セットアップでは、先に
# Rscript --vanilla -e "source('01_code/01_setup/00_mkdir.R')"
# を実行すると、必要な基本フォルダを作れます。

# Stata の実行ファイル
# 必要に応じて自分の環境に合わせて変更してください
STATA_BIN="${STATA_BIN:-/Applications/Stata/StataMP.app/Contents/MacOS/stata-mp}"

# R Markdown を、外部 CDN への依存を減らした形で実行する
render_rmd() {
  local rmd_file="$1"
  Rscript --vanilla -e "rmarkdown::render('${rmd_file}', output_format = 'html_document', output_options = list(self_contained = FALSE))"
}

echo "環境設定を実行します..."

# 1. renv 設定
Rscript --vanilla -e "source('01_code/01_setup/00_renv_setup.R')"

# 2. TinyTeX 設定
Rscript --vanilla -e "source('01_code/01_setup/00_tinytex.R')"

echo "データ加工を実行します..."

# 3. 世界開発指標
if [ -f "02_data_input/WDI.rds" ]; then
  echo "02_data_input/WDI.rds があるため、Data01_WDI.Rmd はスキップします..."
else
  render_rmd "01_code/02_data/Data01_WDI.Rmd"
fi

# 4. 海外進出企業データのインポート
render_rmd "01_code/02_data/Data02_Import.Rmd"

# 5. 産業コードの整理
render_rmd "01_code/02_data/Data03_SectorCodes.Rmd"

# 6. 現地法人と国データの接続
render_rmd "01_code/02_data/Data04_Affiliate_Country.Rmd"

# 7. 親会社データの作成
render_rmd "01_code/02_data/Data05_Affiliate_Parent.Rmd"

# 8. 現地法人数の集計
render_rmd "01_code/02_data/Data06_Affiliate_Number.Rmd"

# 9. 生存分析データの作成
render_rmd "01_code/02_data/Data07_Survival_data.Rmd"

# 10. 国レベルデータの作成
render_rmd "01_code/02_data/Data08_Country_level.Rmd"

# 11. TWFE 用データの作成
render_rmd "01_code/02_data/Data09_TWFE-Brexit-Affiliate.Rmd"

# 12. 新規参入データの作成
render_rmd "01_code/02_data/Data10_Entry_Data.Rmd"

# 13. 退出データの作成
render_rmd "01_code/02_data/Data11_Exit_Data.Rmd"

# 14. 新規参入・退出件数データの作成
render_rmd "01_code/02_data/Data12_Entry_Exit_Data.Rmd"

echo "本文の図表を実行します..."

# 15. Figure 1, X2
render_rmd "01_code/03_r/Fig2_X2.Rmd"

# 16. Figure 2a, Figure 2b
render_rmd "01_code/03_r/Fig3.Rmd"

# 17. Table 1
render_rmd "01_code/03_r/Tab1.Rmd"

# 18. Table 2, Figure 3, Figure 4
render_rmd "01_code/03_r/Tab2_Fig4_5.Rmd"

# 19. Table 3
render_rmd "01_code/03_r/Tab3.Rmd"

# 20. Figure 5
render_rmd "01_code/03_r/Fig6.Rmd"

# 21. Figure 6
render_rmd "01_code/03_r/Fig7.Rmd"

# 22. Figure 7
render_rmd "01_code/03_r/Fig8.Rmd"

# 23. Figure 8
render_rmd "01_code/03_r/Fig9.Rmd"

# 24. Table 4（Stata）
"$STATA_BIN" -b do "01_code/04_stata/Tab4.do"

# 25. Figure C1
render_rmd "01_code/03_r/FigC1.Rmd"

echo "付録の図表を実行します..."

# 26. Figure X1, Figure X3
render_rmd "01_code/03_r/FigX1_X3.Rmd"

# 27. Table A1, Table B2
render_rmd "01_code/03_r/TabA1_B2.Rmd"

# 28. Table D3
render_rmd "01_code/03_r/TabD3.Rmd"

# 29. Figure X4, Table X1, Figure X5
render_rmd "01_code/03_r/FigX4_TabX1_FigX5.Rmd"

# 30. Table E4, Table E5（Stata）
"$STATA_BIN" -b do "01_code/04_stata/TabE4_E5.do"

echo "すべての処理が終わりました。"
