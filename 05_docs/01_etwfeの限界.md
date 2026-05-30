# etwfe パッケージの限界

## 非線形モデル（Poisson/Logit）における固定効果の非対応

### 問題

`etwfe::etwfe()` で `family = "poisson"` または `family = "logit"` を指定した場合、固定効果を制御できない。

- `fe` 引数はデフォルトで `"none"` になる（線形モデルのデフォルトは `"vs"`）
- `ivar` を指定しても、非線形ファミリーが検出された場合は自動的に `NULL` に設定される
- その結果、推定されるモデルには国固定効果・産業固定効果・年固定効果が**一切含まれない**

### 原因

`emfx()` による平均限界効果（AME）の計算において、非線形モデル + 固定効果の組み合わせでは標準誤差が正しく計算できないという既知の問題がある。

参照：https://github.com/vincentarelbundock/marginaleffects/issues/1487

etwfe ドキュメント（`?etwfe`）の `fe` 引数の説明：
> "for non-Gaussian families will default to 'none', since the downstream emfx function cannot compute standard errors for these models in the presence of fixed-effects."

### 確認方法

```r
library(etwfe); library(fixest)

m <- etwfe::etwfe(
  N ~ 1,
  tvar = year, gvar = first_year,
  ivar = pair_id,          # 指定しても無視される
  data = data_EU,
  family = "poisson",
  vcov = ~ iso
)

m$fixef_vars  # → NULL（固定効果なし）
```

### 影響を受けるファイル

| ファイル | モデル | 状況 |
|----------|--------|------|
| `Est13_TWFE_Entry.Rmd` | ETWFE Logit | `ivar = pair_id` は実質的に無効 |
| `Est14_TWFE_Entry_Industry.Rmd` | ETWFE PPML | 固定効果なし（FE なし ETWFE として推定） |
| `Est15_TWFE_Entry_Industry_Covariates.Rmd` | ETWFE PPML | 固定効果なし（FE なし ETWFE として推定） |

### 現在の対応方針

- **TWFE PPML**（`fixest::fepois`）に推計の重点を置く
  - `| iso + year_sector` で国FE + 産業×年FEを適切に制御
- **ETWFE PPML** は「固定効果なし」の AME 推計として位置づけ、GOF 表に明記
  - GOF 表：Industry × Year FE = No、Group FE = Yes（コホート×時間の処置ダミー）

### 代替案（未実装）

固定効果付きの ETWFE PPML が必要な場合：

1. **手動 ETWFE**：`fepois` でコホート×時間ダミーを手動作成し、FE を追加
   - `emfx` が使えないため AME は係数から手動計算が必要
2. **線形 ETWFE（OLS）**：`family = NULL` にすれば `fe = "feo"` で FE が使える
   - カウントデータへの適用は理論的に劣る

---

## jwdid（Stata）との比較

参照：https://friosavila.github.io/app_metrics/app_metrics11.html

### jwdid の概要

`jwdid` は Wooldridge (2021) の ETWFE 推定量を実装した **Stata コマンド**（R 版は CRAN に存在しない）。Fernando Rios-Avila 作。

### 非線形モデルでの固定効果の扱い

jwdid は Poisson/Logit 等の非線形モデル（`method(poisson)` 等）を指定した場合、**個体固定効果（individual FE）の代わりにグループ固定効果（group FE）を自動的に使用**する。

推定式：

$$E(Y_{i,t}|X, \xi_i, \xi_t) = H\!\left(\alpha + \sum_{g,t} \theta_{g,t} D_{i,g,t} + \xi_i + \xi_t\right)$$

| FE の種類 | 線形（OLS） | 非線形（Poisson/Logit） |
|-----------|------------|------------------------|
| Individual FE（個体別） | 使用可能 | 付随パラメータ問題あり → 使用不可 |
| **Group FE**（コホート別） | 線形と同値（バランスパネル） | **jwdid のデフォルト** |
| Time FE（時間別） | 使用可能 | 使用可能 |

**グループ固定効果** = 処置開始時期（コホート）ごとの固定効果。個体レベルより粗いが、付随パラメータ問題（incidental parameters problem）を回避できる。

### Poisson の推奨手法

jwdid ドキュメントは、グループ FE ではなく個体 FE が必要な Poisson 推計には **`ppmlhdfe`（高次元固定効果付き Poisson QMLE）を推奨**：

> "This is the state-of-the-art estimator for Poisson models with fixed effects, and it is the recommended estimator for trade analysis."

R における `ppmlhdfe` の相当品は `fixest::fepois`。

### etwfe（R）と jwdid（Stata）の比較

| 項目 | etwfe（R） | jwdid（Stata） |
|------|-----------|---------------|
| Poisson での FE | **不可**（fe="none" 強制） | グループ FE（コホート別）使用可 |
| Individual FE（Poisson） | Poisson では無効 | 非推奨（付随パラメータ問題） |
| Poisson 推奨手法 | `fepois` で別途推定 | `ppmlhdfe` を推奨 |
| AME 計算 | `emfx()` で可（FE なし時） | `estat event` 等で可 |
| R 版の有無 | あり（CRAN） | **なし**（Stata のみ） |

### 結論

- **jwdid（Stata）は Poisson ETWFE でコホート固定効果（グループ FE）を含められる**
- ただし個体固定効果ではなくコホート固定効果であり、etwfe（R）の「固定効果なし」よりは制御が強い
- etwfe（R）の制限は Poisson ETWFE の**本質的な問題**ではなく、`emfx()` の実装上の制約
- R での完全な代替は `fixest::fepois` による手動 ETWFE 実装（`ppmlhdfe` 相当）

### 発覚経緯

2026-03-28、Est14/Est15 に産業×年固定効果を追加しようとした際に判明。
`etwfe(N ~ 1 | year_sector, ...)` を試みたが `model.frame` でエラー。
調査の結果、`family = "poisson"` では `fe` が強制的に `"none"` になることを確認。
