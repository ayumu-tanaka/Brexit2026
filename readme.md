# Brexit2026

このリポジトリは、Brexit が日本企業の海外直接投資（FDI）に与えた影響を分析する研究プロジェクトのうち、**子会社レベルの退出分析を中心に残した作業版**です。

主な分析対象は、Toyo Keizai Inc. の Overseas Japanese Companies Data に含まれる日本企業の欧州現地法人です。2010、2012、2014、2016、2018、2020 年の隔年調査データを用いて、Brexit referendum 後に英国所在の日本企業現地法人が他の欧州諸国と比べて退出しやすくなったか、また新規参入が弱まったかを検証します。

## 研究の位置づけ

この版では、Brexit referendum による政策不確実性と、FDI に伴う沈没費用・資産特殊性が企業行動に与える影響を重視しています。特に、既存の現地法人は沈没費用のため退出しにくい一方で、新規参入は延期・中止されやすい、という entry と exit の非対称性を検証する構成です。

`2024Brexit` が産業・国・年レベルの entry/exit count 分析へ整理された版であるのに対し、この `Brexit2026` は、子会社レベルの退出分析や異質性分析を本文・付録に多く残した版です。

## 関連プロジェクトとの違い

このプロジェクトの近い派生・整理版として、`2024Brexit` と `EntryExit2026` があります。3つの位置づけは以下の通りです。

| プロジェクト | 位置づけ | 主な分析単位 | 使いどころ |
| --- | --- | --- | --- |
| `Brexit2026` | 子会社レベルの退出分析を中心に残した作業版。 | 子会社レベルの退出確率、親会社 exposure、産業別異質性 | 既存 affiliate の退出、親会社の UK exposure、MFN risk、資産特殊性などを別論文・補助分析として使う場合。 |
| `2024Brexit` | 研究全体の作業リポジトリ。本線に近いが、過去の資料・補助文書・分離済み原稿も含む。 | 子会社、親会社、国×産業×年 | データ加工、図表生成、投稿用本文、過去の作業履歴をまとめて確認する場合。 |
| `EntryExit2026` | entry/exit count 論文用にスリム化した整理版。 | 国×産業×年の参入・退出件数 | `Anchored in Uncertainty` の本文・付録を再現し、参入・退出件数分析だけを扱う場合。 |

## 2024Brexit との主な違い

### 1. 論文本文の構成

- `Brexit2026/04_tex/main/brexit.tex` は、子会社レベルの退出分析を中心にした長い版です。
- `2024Brexit/04_tex/main/brexit.tex` は、国×産業×年の entry/exit count 分析を中心に整理された短い版です。
- `Brexit2026` の本文・付録には、affiliate-level exit、親会社の UK exposure、複数 UK affiliate 保有、MFN risk、資産特殊性などの追加分析が多く残っています。
- `2024Brexit` では、これらの子会社レベル退出分析の一部が別原稿・別フォルダに分離された構成になっています。

### 2. 分析単位

`Brexit2026` では、主に以下のような子会社レベルの分析が残っています。

- 子会社ごとの退出確率
- 既存 affiliate の Brexit 後の退出反応
- 親会社レベルの UK exposure による異質性
- 親会社が UK affiliate を 1 社だけ持つ場合と複数持つ場合の比較
- Brexit MFN tariff risk による産業別異質性

一方、`2024Brexit` は以下のような集計レベル分析へ寄せられています。

- host-country × industry × year の entry count
- host-country × industry × year の exit count
- PPML
- pooled Poisson QMLE dynamic ATT
- synthetic DiD

### 3. 主要スクリプトの違い

`01_code/03_r/Fig7.Rmd` の内容が大きく異なります。

- `Brexit2026`: affiliate-level panel を用いて、子会社退出 `exitit` に対する synthetic DiD を推定します。
- `2024Brexit`: `N_affiliate_exit_country_industry_year.dta` を用いて、国×産業×年の退出件数に対する synthetic DiD を推定します。

`01_code/02_data/Data11_Entry_Data.Rmd` も異なります。

- `Brexit2026`: entry count データに追加共変量を結合しない構成です。
- `2024Brexit`: `GDP_PPP`, `GDP_per_capita`, `Dist`, `Aff_size`, `EU_all` などを結合し、国×産業×年の count 分析に使いやすい形へ拡張しています。

### 4. Stata スクリプトと表番号

`01_code/04_stata/` の構成にも違いがあります。

- `Brexit2026`: `Tab4.do`, `TabE4_E5.do`, `TabH6.do`
- `2024Brexit`: `Tab2_TabD3.do`, `Tab5.do`, `TabE4_E5.do`, `TabH6.do`

この違いは、論文本文の表番号や、本文に残す分析対象を整理し直したことに対応しています。

### 5. 出力済み図表

`Brexit2026/04_tex/main/` には、子会社レベル退出や異質性分析に関連する出力が多く残っています。

- `FigF2.eps`
- `FigG3.eps`
- `FigH4.eps`
- `TabE4.tex`
- `TabE5.tex`
- `TabH6.tex`

`2024Brexit/04_tex/main/` では、本文用の図表が count 分析中心に整理されています。

### 6. 管理ファイル

- `2024Brexit` には `AGENTS.md` とルートの `README.md` があります。
- `Brexit2026` には、これまでルート README がありませんでした。
- `Brexit2026` の `AGENTS.md` は git status 上では削除状態です。
- `00_run.sh` は両リポジトリで同一です。

## EntryExit2026 との主な違い

`EntryExit2026` は、参入・退出件数分析に絞った独立整理版です。`Brexit2026` と同じく Brexit が日本企業の FDI に与えた影響を扱いますが、分析の中心は大きく異なります。

`Brexit2026` は、既存現地法人が Brexit referendum 後に退出しやすくなったかを子会社レベルで検証する版です。本文・付録には、親会社の UK exposure、親会社が UK affiliate を複数持つかどうか、MFN tariff risk、資産特殊性など、退出反応の異質性を調べる分析が多く残っています。

一方、`EntryExit2026` は、国×産業×年に集計した新規参入件数と退出件数を主なアウトカムにします。Brexit の影響を、子会社ごとの退出確率ではなく、英国への新規参入件数と退出件数の非対称な変化として検証するためのリポジトリです。

主な違いは以下です。

- `Brexit2026`: affiliate-level exit を中心にした作業版。
- `EntryExit2026`: host-country × industry × year の entry/exit count を中心にした整理版。
- `Brexit2026`: 付録・本文に異質性分析が多く残る。
- `EntryExit2026`: 投稿用の entry/exit count 論文を再現しやすいよう、構成がスリム。
- `Brexit2026`: 子会社レベル退出分析を別論文や補助分析として再利用する際の出発点。
- `EntryExit2026`: `Anchored in Uncertainty` の本文・付録・図表を扱う際の出発点。

## ディレクトリ構成

```text
.
├── 00_run.sh                 # 一括実行スクリプト
├── 00_run.command            # macOS 用の一括実行ラッパー
├── 01_code/
│   ├── 01_setup/             # 環境設定
│   ├── 02_data/              # データ加工
│   ├── 03_r/                 # R による図表作成
│   └── 04_stata/             # Stata による推定・表作成
├── 02_data_input/            # 生データ
├── 03_data_output/           # 中間データ
├── 04_tex/
│   ├── main/                 # 本文原稿と本文図表
│   └── oa/                   # オンライン付録と付録図表
├── 05_docs/                  # メモ・参考資料・補助ドキュメント
├── 06_archive/               # 旧スクリプト、旧データ、過去出力
├── 07_references/            # 参考文献・関連資料
├── 08_coarse-output/         # レビュー・補助出力
└── renv.lock                 # R パッケージ環境の記録
```

## 実行方法

初回は、必要に応じて R 環境と LaTeX 環境を設定します。

```r
source("01_code/01_setup/00_mkdir.R")
source("01_code/01_setup/00_renv_setup.R")
source("01_code/01_setup/00_tinytex.R")
```

全体のパイプラインは、ルートディレクトリで次を実行します。

```bash
bash 00_run.sh
```

Stata の実行ファイルは `00_run.sh` の `STATA_BIN` で指定します。

```bash
STATA_BIN="/Applications/Stata/StataMP.app/Contents/MacOS/stata-mp" bash 00_run.sh
```

## LaTeX 原稿

本文原稿は `04_tex/main/brexit.tex` です。

```bash
cd 04_tex/main
pdflatex brexit.tex
bibtex brexit
pdflatex brexit.tex
pdflatex brexit.tex
```

オンライン付録は `04_tex/oa/brexit_OA.tex` です。

```bash
cd 04_tex/oa
pdflatex brexit_OA.tex
```

## 使い分けの目安

- `Brexit2026` は、子会社レベル退出分析や異質性分析を確認・再利用したい場合に参照します。
- `2024Brexit` は、研究全体の履歴、補助資料、分離済み原稿、データ加工の経緯を確認する場合に参照します。
- `EntryExit2026` は、産業・国・年レベルの entry/exit count 分析を中心にした整理済み本文を扱う場合に参照します。
- 今後、子会社レベル退出分析を別論文として展開する場合は、`Brexit2026` の本文・付録・図表出力が出発点になります。

## 注意点

- このリポジトリは、`2024Brexit` と非常に近い構成ですが、本文と主要分析の焦点が異なります。
- 出力済み PDF、EPS、LaTeX 補助ファイルが多く含まれています。
- `02_data_input/` には外部由来の生データが含まれる可能性があるため、共有時にはデータ利用条件を確認してください。
- `renv.lock` に R パッケージ環境が記録されています。
