# AGENTS.md

このファイルは、このリポジトリでコードを扱う際の共通ガイドです。  
このプロジェクトの概要、ディレクトリ構成、実行順序、主要な図表生成元、未使用スクリプトの扱いをここに集約します。

## プロジェクト概要

これは、Brexit が日本企業の海外直接投資（FDI）に与えた影響を分析する実証研究です。  
主な関心は、日本企業の現地法人の撤退、出資比率、新規参入に対する Brexit の影響と、沈没費用・資産特殊性によるヒステリシス効果です。

主な分析手法:
- TWFE
- ETWFE
- SDiD
- 生存分析
- MICE による欠損値補完
- Pooled Poisson QMLE

## ディレクトリ構成

- `01_code/01_setup/`: 環境設定用スクリプト
- `01_code/02_data/`: データ加工用 R Markdown
- `01_code/03_r/`: 図表を生成する R Markdown
- `01_code/04_stata/`: Stata による推定・表出力
- `02_data_input/`: 現行パイプラインで使う生データ
- `03_data_output/`: 現行パイプラインで使う中間データ
- `04_tex/main/`: 本文原稿と本文で使う図表
- `04_tex/oa/`: オンライン付録と付録で使う図表
- `05_docs/`: メモ・履歴・補助ドキュメント
- `06_archive/unused_scripts/`: 現行パイプラインでは使わない旧スクリプト
- `06_archive/unused_data_raw/`: 未使用スクリプト用の旧生データ
- `06_archive/unused_output/`: 未使用スクリプトの出力先
- `06_archive/`: 過去スナップショット

## よく使うコマンド

### 環境セットアップ
```r
source("01_code/01_setup/00_mkdir.R")
source("01_code/01_setup/00_renv_setup.R")
source("01_code/01_setup/00_tinytex.R")
```

`00_mkdir.R` は、プロジェクトで使う基本フォルダを最初に作るためのスクリプトです。

### 個別スクリプトの実行
```r
rmarkdown::render("01_code/02_data/DataXX_*.Rmd")
rmarkdown::render("01_code/03_r/FigXX_*.Rmd")
rmarkdown::render("01_code/03_r/TabXX_*.Rmd")
```

### 本文の LaTeX コンパイル
```bash
cd 04_tex/main
pdflatex brexit.tex
bibtex brexit
pdflatex brexit.tex
pdflatex brexit.tex
```

### 付録の LaTeX コンパイル
```bash
cd 04_tex/oa
pdflatex brexit_OA.tex
```

### 一括実行
- 実行本体: `00_run.sh`
- macOS 用ラッパー: `00_run.command`

## データフロー

外部データ  
→ データ加工 (`01_code/02_data/`)  
→ 推定用中間データ (`03_data_output/`)  
→ 図表生成 (`01_code/03_r/`, `01_code/04_stata/`)  
→ 論文原稿 (`04_tex/main/`, `04_tex/oa/`)

## 実行順序

### 1. 環境設定

1. `01_code/01_setup/00_mkdir.R`
2. `01_code/01_setup/00_renv_setup.R`
3. `01_code/01_setup/00_tinytex.R`

### 2. データ加工

1. `01_code/02_data/Data01_WDI.Rmd`
2. `01_code/02_data/Data02_Import.Rmd`
3. `01_code/02_data/Data03_SectorCodes.Rmd`
4. `01_code/02_data/Data04_Affiliate_Country.Rmd`
5. `01_code/02_data/Data05_Affiliate_Parent.Rmd`
6. `01_code/02_data/Data06_Affiliate_Number.Rmd`
7. `01_code/02_data/Data07_Survival_data.Rmd`
8. `01_code/02_data/Data08_Country_level.Rmd`
9. `01_code/02_data/Data09_TWFE-Brexit-Affiliate.Rmd`
10. `01_code/02_data/Data10_Entry_Data.Rmd`
11. `01_code/02_data/Data11_Exit_Data.Rmd`
12. `01_code/02_data/Data12_Entry_Exit_Data.Rmd`

### 3. 本文の図表

1. `01_code/03_r/Fig2_X2.Rmd`
2. `01_code/03_r/Fig3.Rmd`
3. `01_code/03_r/Tab1.Rmd`
4. `01_code/03_r/Tab2_Fig4_5.Rmd`
5. `01_code/03_r/Tab3.Rmd`
6. `01_code/03_r/Fig6.Rmd`
7. `01_code/03_r/Fig7.Rmd`
8. `01_code/03_r/Fig8.Rmd`
9. `01_code/03_r/Fig9.Rmd`
10. `01_code/04_stata/Tab4.do`
11. `01_code/03_r/FigC1.Rmd`

### 4. 付録の図表

1. `01_code/03_r/FigX1_X3.Rmd`
2. `01_code/03_r/TabA1_B2.Rmd`
3. `01_code/03_r/TabD3.Rmd`
4. `01_code/03_r/FigX4_TabX1_FigX5.Rmd`
5. `01_code/04_stata/TabE4_E5.do`

## 図表と生成元

### 本文の図

- `Fig2`: `01_code/03_r/Fig2_X2.Rmd`
- `Fig3a`, `Fig3b`: `01_code/03_r/Fig3.Rmd`
- `Fig4`, `Fig5`: `01_code/03_r/Tab2_Fig4_5.Rmd`
- `Fig6`: `01_code/03_r/Fig6.Rmd`
- `Fig7`: `01_code/03_r/Fig7.Rmd`
- `Fig8`: `01_code/03_r/Fig8.Rmd`
- `Fig9`: `01_code/03_r/Fig9.Rmd`
- `FigC1`: `01_code/03_r/FigC1.Rmd`

### 本文の表

- `Tab1`: `01_code/03_r/Tab1.Rmd`
- `Tab2`: `01_code/03_r/Tab2_Fig4_5.Rmd`
- `Tab3`: `01_code/03_r/Tab3.Rmd`
- `Tab4`: `01_code/04_stata/Tab4.do`

### 付録の図表

- `TabA1`, `TabB2`: `01_code/03_r/TabA1_B2.Rmd`
- `TabD3`: `01_code/03_r/TabD3.Rmd`
- `TabE4`, `TabE5`: `01_code/04_stata/TabE4_E5.do`
- `TabX1`, `FigX4`, `FigX5`: `01_code/03_r/FigX4_TabX1_FigX5.Rmd`
- `FigX1`, `FigX3`: `01_code/03_r/FigX1_X3.Rmd`
- `FigX2`: `01_code/03_r/Fig2_X2.Rmd`

## 現在は使わないスクリプト

以下は現行の論文パイプラインでは使いません。

- `06_archive/unused_scripts/Data01_Doing_Business.Rmd`
- `06_archive/unused_scripts/Data02_Worldwide Governance Indicators.Rmd`
- `06_archive/unused_scripts/Data23_Geocoding_Need_Fix.Rmd`
- `06_archive/unused_scripts/Data28_Entry.Rmd`
- `06_archive/unused_scripts/Des01_Check_Portugal.Rmd`
- `06_archive/unused_scripts/Est13_TWFE_Entry.Rmd`

未使用スクリプト用の入力は `06_archive/unused_data_raw/`、出力は `06_archive/unused_output/` に置きます。  
たとえば `06_archive/unused_scripts/Data01_Doing_Business.Rmd` は `06_archive/unused_data_raw/WB_Doing_Business/Historical-data.dta` を読むようにしてあります。

## プロジェクト固有の注意点

- R スクリプトは保存済みデータを読んで前段階を参照する
- LaTeX 原稿は図表ファイルを同じディレクトリから直接読む
- `04_tex/main/` と `04_tex/oa/` は投稿用の構成を意識して、原稿と図表を同じ場所に置いている
- SDiD の図 (`Fig7`, `Fig9`) は R の EPS 出力が不安定なことがあるため、`EPS` に加えて `PDF` も保存する
- 現行パイプラインに不要な raw データは `06_archive/unused_data_raw/` に退避している

## 技術スタック

- 言語: R, Stata, LaTeX
- パッケージ管理: `renv`
- 主な R パッケージ:
  - データ処理: `tidyverse`, `rio`, `countrycode`, `WDI`
  - 計量経済分析: `fixest`, `etwfe`, `synthdid`, `survival`, `mice`
  - 表・図: `modelsummary`, `kableExtra`, `ggplot2`, `sf`

## 出力方針

- 本文図表は `04_tex/main/` に保存
- 付録図表は `04_tex/oa/` に保存
- 中間データは `03_data_output/` に保存
- 現行論文で使わない中間生成物は作らない
