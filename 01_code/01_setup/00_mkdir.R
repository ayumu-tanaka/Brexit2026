# 00_mkdir.R
# このプロジェクトで使う基本フォルダを作るためのスクリプトです。
# 初めて環境を用意するときに実行することを想定しています。

# このスクリプトを、プロジェクトの一番上のフォルダ
# （2024Brexit フォルダ）で実行してください。


# 01_code ---------------------------------------------------------------
# コードを保存するフォルダ
dir.create("01_code", showWarnings = FALSE)

# 環境設定用のコード
dir.create("01_code/01_setup", showWarnings = FALSE)

# データ加工用のコード
dir.create("01_code/02_data", showWarnings = FALSE)

# R で図表を作るコード
dir.create("01_code/03_r", showWarnings = FALSE)

# Stata のコード
dir.create("01_code/04_stata", showWarnings = FALSE)

# 一時ファイル用
dir.create("01_code/temp", showWarnings = FALSE)


# 02_data_input ---------------------------------------------------------
# 元データを置くフォルダ
dir.create("02_data_input", showWarnings = FALSE)


# 03_data_output --------------------------------------------------------
# 中間データを置くフォルダ
dir.create("03_data_output", showWarnings = FALSE)


# 04_tex ---------------------------------------------------------------
# 論文原稿と図表を置くフォルダ
dir.create("04_tex", showWarnings = FALSE)

# 本文
dir.create("04_tex/main", showWarnings = FALSE)

# オンライン付録
dir.create("04_tex/oa", showWarnings = FALSE)


# 05_docs --------------------------------------------------------------
# 参考資料や補助文書を置くフォルダ
dir.create("05_docs", showWarnings = FALSE)

# 補助資料
dir.create("05_docs/2026-01-09-EER-reject", showWarnings = FALSE)
dir.create("05_docs/asset_specificity", showWarnings = FALSE)
dir.create("05_docs/etwfe-main", showWarnings = FALSE)
dir.create("05_docs/jwdid", showWarnings = FALSE)
dir.create("05_docs/marginaleffects-main", showWarnings = FALSE)


# 06_archive -----------------------------------------------------------
# 現在は使っていないスクリプトやデータを保存するフォルダ
dir.create("06_archive", showWarnings = FALSE)

# 未使用の元データ
dir.create("06_archive/unused_data_raw", showWarnings = FALSE)
dir.create("06_archive/unused_data_raw/WB_Doing_Business", showWarnings = FALSE)
dir.create("06_archive/unused_data_raw/geocoded_data", showWarnings = FALSE)
dir.create("06_archive/unused_data_raw/wgidataset-stata", showWarnings = FALSE)

# 未使用スクリプトの出力先
dir.create("06_archive/unused_output", showWarnings = FALSE)

# 未使用スクリプト
dir.create("06_archive/unused_scripts", showWarnings = FALSE)


# renv ---------------------------------------------------------------
# R パッケージ管理用フォルダ
dir.create("renv", showWarnings = FALSE)
dir.create("renv/library", showWarnings = FALSE)
dir.create("renv/staging", showWarnings = FALSE)


# 完了メッセージ --------------------------------------------------------
cat("必要なフォルダの作成が終わりました。\\n")
