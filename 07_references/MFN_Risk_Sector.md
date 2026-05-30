# MFN Risk に基づく産業分類メモ

このメモは、`SectorCode2009.xlsx` の `SectorCode2009` を、Brexit に伴う MFN tariff exposure の観点から

- `high`: 高 MFN Risk・Brexit インパクト大
- `low`: 低 MFN Risk・Brexit インパクト小
- `service`: サービス

の 3 区分に分類した方法を記録するものである。

## 参照データ

1. `07_references/SectorCode2009.xlsx`
2. `07_references/Graziano et al. - 2021 - Table A1 MFN Risk by Sector - UK and EU Trade.md`
3. 作成済み対応表: `07_references/SectorCode2009_BrexitMFN3.csv`

## 基本的な考え方

Graziano et al. (2021) の Table A1 には、EU-UK trade における sector 別の `MFN Risk (Mean)` が示されている。  
この表は財貿易ベースの 21 sector 分類であり、`SectorCode2009` の産業分類とは完全には一致しない。

## Table A1 の説明

本文とオンライン付録を踏まえると、Table A1 は単なる記述統計ではなく、Brexit 不確実性の影響がどの産業で強く出るかを示す基礎表である。

### 1. 本文における位置づけ

本文では、Brexit の確率上昇が輸出を減らす効果は、Brexit 後により高い通商障壁に直面する可能性が大きい産業ほど強い、という理論と実証が提示されている。  
その「産業ごとの露出度」を測る中心指標が `MFN risk` である。

論文の考え方は次の通りである。

1. EU に残る状態では、現行の EU 内市場アクセスが継続するため、企業は大きな追加的 tail risk を負わない
2. 一方で Brexit が起きると、EU-UK 間 trade は MFN tariff など、より不利な通商条件に移る可能性がある
3. そのとき、もともと MFN tariff が高い産業ほど、Brexit 確率の上昇に対して輸出・参入の先送りや縮小が起きやすい

本文では実際に、

- 高 MFN risk 財ほど Brexit 不確実性に対する輸出反応が大きい
- 平均的な不確実性効果の主要部分は MFN risk によって説明される
- trade war シナリオよりも MFN シナリオの方が実証的に支持される

と解釈されている。

したがって Table A1 は、どの sector が high-risk で、どの sector が low-risk かを一覧化した、論文全体の異質性分析の入口といえる。

### 2. Table A1 の MFN Risk の意味

オンライン付録の Table A1 の注では、`MFN risk` は

- `1 - (tau^MFN)^(-sigma)`

として定義されている。ここで、

- `tau^MFN = 1 + MFN ad valorem / 100`
- `sigma = 4`

である。

この指標は、Brexit 後に EU-UK 間 trade が MFN tariff に戻った場合に、どれだけ利潤や trade profitability が悪化しうるかを要約する、関税ベースの tail risk proxy と理解できる。  
MFN tariff が高いほど値は大きくなり、その産業は Brexit 不確実性に対してより脆弱だと解釈される。

### 3. Table A1 の集計単位

オンライン付録によると、Table A1 は以下の特徴をもつ。

- 対象は `EU-UK subsample`
- sector は HS の 21 section
- 各 section の輸出シェアは `2015` 年の total exports に占める割合
- MFN risk は HS6 レベルで計算した値を section 単位に要約したもの
- 集計対象の HS6 は、`8/15-6/16` の baseline sample に含まれる `continuing country-product HS-6 varieties`

ここで重要なのは、Table A1 が全 HS6 品目を単純に並べたものではなく、論文の基準サンプルで実際に継続的に観測される EU-UK trade 品目に限定して sector 別平均を作っている点である。  
したがって、これは「Brexit 前の実際の EU-UK trade 構成に即した MFN exposure の sector 別 summary」と理解するのが適切である。

### 4. なぜ sector 別平均を使うのか

本文の推定自体は HS6 レベルで行われるが、Table A1 は sector ごとの MFN exposure の直感を与えるための要約表である。  
たとえば、本文では low-risk products の輸出シェア推移を図示し、さらに回帰では `Pr(Brexit) × MFN risk` の交差項を使って、Brexit 確率の上昇が high-risk 財ほど trade を押し下げるかを検証している。

その意味で Table A1 は、

- どの産業が構造的に高関税リスクか
- その高低が sector 間でどれくらい異なるか
- 論文の推定結果を産業別にどう読むべきか

を読者に示す役割を持つ。

### 5. 本研究での利用方法との関係

本研究では `SectorCode2009` しか使えない場面があるため、論文の HS6 ベースの MFN risk をそのまま使うのではなく、Table A1 の sector-level information を用いて、`SectorCode2009` を

- `high`
- `low`
- `service`

に再分類した。

これは論文の元の識別単位より粗い集約だが、考え方そのものは本文と整合的である。  
すなわち、Brexit 後に MFN tariff への回帰で相対的に打撃が大きい財部門を `high`、小さい財部門を `low`、そして財 trade ベースの MFN risk を直接当てにくい部門を `service` とする整理である。

そのため、今回の分類では、

1. `SectorCode2009` のうち財部門に対応しやすい産業については、Graziano et al. の 21 sector のうち最も近い sector に対応づける
2. 対応づけた sector の `MFN Risk (Mean)` が overall mean を上回るか下回るかで `high` / `low` を決める
3. 財の MFN Risk を直接当てにくい部門は `service` とする

という手順をとった。

## high / low の閾値

`Graziano et al. - 2021 - Table A1 MFN Risk by Sector - UK and EU Trade.md` の Table A1 では、

- `Overall MFN Risk (Mean) = 0.145`

である。

このため、

- `MFN Risk (Mean) > 0.145` を `high`
- `MFN Risk (Mean) <= 0.145` を `low`

とした。

## 対応づけのルール

### 1. 高 MFN Risk・Brexit インパクト大

以下は `MFN Risk (Mean)` が overall mean を上回るため `high` とした。

| SectorCode2009 | SectorName2009 | 対応先 | MFN Risk (Mean) | 備考 |
| :--- | :--- | :--- | :--- | :--- |
| 1010 | 農林水産 | Animals / Vegetables / Fats & Oils | 0.2043 | 3 sector の平均 |
| 1310 | 食料品 | Prepared Foodstuffs | 0.3410 | Table A1 で最も高い |
| 1410 | 繊維・衣服 | Textiles & Articles / Footwear | 0.2505 | 2 sector の平均 |
| 1610 | 化学 | Chemicals | 0.1600 | overall mean 超 |
| 1710 | 医薬品 | Chemicals | 0.1600 | 医薬品を chemicals に対応 |
| 1910 | ゴム製品 | Plastics, Rubber & Articles | 0.1640 | overall mean 超 |
| 2610 | 輸送機器 | Vehicles, Aircraft, Vessels | 0.1540 | 閾値をわずかに上回る |

### 2. 低 MFN Risk・Brexit インパクト小

以下は `MFN Risk (Mean)` が overall mean 以下のため `low` とした。

| SectorCode2009 | SectorName2009 | 対応先 | MFN Risk (Mean) | 備考 |
| :--- | :--- | :--- | :--- | :--- |
| 1110 | 鉱業 | Minerals | 0.0136 | 低い |
| 1510 | パルプ・紙 | Pulp, Paper & Articles | 0.0000 | 0 |
| 1810 | 石油石炭 | Minerals | 0.0136 | 鉱物系として対応 |
| 2010 | ガラス・土石 | Stone, Plaster, Cement, other | 0.1270 | overall mean 以下 |
| 2110 | 鉄鋼 | Base Metals & Articles | 0.0732 | overall mean 以下 |
| 2210 | 非鉄金属 | Base Metals & Articles | 0.0732 | overall mean 以下 |
| 2310 | 金属製品 | Base Metals & Articles | 0.0732 | overall mean 以下 |
| 2410 | 機械 | Machinery; Elec. Equip.; Electronics | 0.0735 | overall mean 以下 |
| 2510 | 電気機器 | Machinery; Elec. Equip.; Electronics | 0.0735 | overall mean 以下 |
| 2710 | 精密機器 | Optical, Medical & other instruments | 0.0856 | overall mean 以下 |
| 2810 | 他製造業 | Miscellaneous Manufactures | 0.0968 | 幅広い区分のため暫定的 |

### 3. サービス

以下は、財 trade ベースの MFN Risk を直接対応させにくいため `service` とした。

- 0000 不明
- 1210 建設
- 2910 電力・ガス
- 3010 鉄道・バス
- 3110 貨物運送
- 3210 海運
- 3310 航空
- 3410 倉庫・物流関連
- 3510 通信・放送
- 3610 新聞・出版
- 3710 映像・音楽
- 3810 広告
- 3910 情報・システム・ソフト
- 4010-5210 卸売
- 5310-5710 小売
- 5810 飲食・外食
- 5910-6910 金融・保険
- 7010 不動産
- 7110-7910 各種サービス
- 8010 統括会社

`3610 新聞・出版` は Excel 上では manufacturing 扱いだが、今回の 3 区分ではサービス寄りと考えて `service` に入れている。

## 注意点

1. この分類は、Brexit の「実際の推定効果」を直接示すものではなく、MFN tariff exposure に基づく proxy である。
2. `SectorCode2009` と Graziano et al. の sector 分類は一致しないため、いくつかの割当てには裁量が入っている。
3. `2610 輸送機器` は `0.154` で、閾値 `0.145` をわずかに上回る境界的なケースである。
4. `2810 他製造業` は対応先が広いため、`low` は暫定的な扱いである。
5. 卸売や小売は財に関連するが、今回の 3 区分では一貫性を優先して `service` にまとめている。

## 実務上の利用

実際の作業では、`07_references/SectorCode2009_BrexitMFN3.csv` を `SectorCode2009` で結合し、

- `high`
- `low`
- `service`

の 3 区分ダミーまたはカテゴリ変数として使うことを想定している。

## 出典

Graziano, A. G., Handley, K., & Limão, N. (2021). *Brexit Uncertainty and Trade Disintegration*. The Economic Journal, 131(635), 1150-1185.
