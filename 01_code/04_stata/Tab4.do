* Wooldridge (2023)の理論的枠組みに完全に整合するよう、国固定効果（`iso`）を排除し、代わりにコホートダミー（`GBR`）と国レベルの共変量（GDPや距離など）を明示的に投入する「プール化ポアソンQMLE（Pooled Poisson QMLE）」の仕様。


clear all
set more off

* 1. データの読み込み
use "../../03_data_output/EntryExit/N_affiliate_entry_country_industry_year.dta", clear
rename FA_SectorCode2009 FA_Sector 
keep if inlist(year, 2010, 2012, 2014, 2016, 2018, 2020)
drop if FA_Sector == 0 | iso == ""

* 2. 2010年時点の共変量を固定値として作成
sort iso FA_Sector year
foreach v in GDP_per_capita Dist {
    by iso: egen `v'_2010 = max(cond(year == 2010, `v', .))
}
by iso FA_Sector: egen Aff_size_median_2010 = max(cond(year == 2010, Aff_size_median, .))

gen log_GDP_pc = log(GDP_per_capita_2010)
gen log_Dist = log(Dist_2010)
replace Aff_size_median_2010 = 0 if missing(Aff_size_median_2010)

* 3. バランスドパネルの構築
fillin iso FA_Sector year
replace N = 0 if missing(N)

* fillin で追加された行にサンプル指標と固定共変量を再付与
gen is_EU_HI = inlist(iso, "AUT", "BEL", "DNK", "FIN", "FRA", "DEU", "IRL", "ITA") | ///
               inlist(iso, "LUX", "NLD", "SWE", "GBR")
gen is_NonEU_HI = inlist(iso, "CAN", "AUS", "CHE", "KOR", "NZL")
gen sample_HI = (is_EU_HI == 1)
gen sample_ALL = (is_EU_HI == 1 | is_NonEU_HI == 1)

foreach v in GDP_per_capita_2010 Dist_2010 {
    by iso: egen `v'_fill = max(`v')
    replace `v' = `v'_fill if missing(`v')
    drop `v'_fill
}
by iso FA_Sector: egen Aff_size_median_2010_fill = max(Aff_size_median_2010)
replace Aff_size_median_2010 = Aff_size_median_2010_fill if missing(Aff_size_median_2010)
replace Aff_size_median_2010 = 0 if missing(Aff_size_median_2010)
drop Aff_size_median_2010_fill

replace log_GDP_pc = log(GDP_per_capita_2010) if missing(log_GDP_pc) & !missing(GDP_per_capita_2010)
replace log_Dist = log(Dist_2010) if missing(log_Dist) & !missing(Dist_2010)

*  4. 推定用変数の共通作成
gen GBR = (iso == "GBR")
foreach y in 2010 2012 2016 2018 2020 {
    gen GBR_`y' = (iso == "GBR" & year == `y')
}
gen cohort = cond(iso == "GBR", 2016, 0)
egen id = group(iso FA_Sector)
egen year_sector = group(year FA_Sector)

*  --- 推定セクション ---

*  A. Full Sample (2010-2020) — 共変量なし・ありを同一ブロックで推定し、サンプルを統一
preserve
* 変更点1: absorb(iso year_sector) から iso を削除し、GBRダミーを明示的に追加
local covs log_GDP_pc log_Dist Aff_size_median_2010

* --- A-1. 共変量なし ---
ppmlhdfe N GBR GBR_2010 GBR_2012 GBR_2016 GBR_2018 GBR_2020 if sample_HI, absorb(year_sector) cluster(iso FA_Sector)
estadd local cov "No"
estimates store m1_twfe_full

jwdid N if sample_HI, ivar(id) tvar(year) gvar(cohort) method(ppmlhdfe) fevar(year_sector) cluster(iso FA_Sector)
estadd local cov "No"
estimates store m1_jwdid_full
gen byte sample_nosep_full_HI = e(sample)

ppmlhdfe N GBR GBR_2010 GBR_2012 GBR_2016 GBR_2018 GBR_2020 if sample_ALL, absorb(year_sector) cluster(iso FA_Sector)
estadd local cov "No"
estimates store m2_twfe_full

jwdid N if sample_ALL, ivar(id) tvar(year) gvar(cohort) method(ppmlhdfe) fevar(year_sector) cluster(iso FA_Sector)
estadd local cov "No"
estimates store m2_jwdid_full
gen byte sample_nosep_full_ALL = e(sample)

* --- A-2. 共変量あり（A-1 の e(sample) に限定してサンプルを統一）---
ppmlhdfe N GBR GBR_2010 GBR_2012 GBR_2016 GBR_2018 GBR_2020 `covs' if sample_nosep_full_HI, absorb(year_sector) cluster(iso FA_Sector)
estadd local cov "Yes"
estimates store m1_twfe_full_cov

jwdid N `covs' if sample_nosep_full_HI, ivar(id) tvar(year) gvar(cohort) method(ppmlhdfe) fevar(year_sector) cluster(iso FA_Sector)
estadd local cov "Yes"
estimates store m1_jwdid_full_cov

ppmlhdfe N GBR GBR_2010 GBR_2012 GBR_2016 GBR_2018 GBR_2020 `covs' if sample_nosep_full_ALL, absorb(year_sector) cluster(iso FA_Sector)
estadd local cov "Yes"
estimates store m2_twfe_full_cov

jwdid N `covs' if sample_nosep_full_ALL, ivar(id) tvar(year) gvar(cohort) method(ppmlhdfe) fevar(year_sector) cluster(iso FA_Sector)
estadd local cov "Yes"
estimates store m2_jwdid_full_cov
restore


*  --- 出力セクション ---
local comparison_note_combined_2010 "Columns (1)--(4) use EU high-income countries as the comparison group; Columns (5) and (6) include additional non-EU high-income countries (CAN, AUS, CHE, KOR, NZL)."
local data_note "The outcome is the count of new Japanese affiliate entries into a host country by industry (biennial)."
local fullwidth_note_start "\end{threeparttable}\par\medskip\parbox{\linewidth}{\footnotesize \textit{Notes:} "
local fullwidth_note_end "}\end{table}"

* 変更点4: テーブルタイトルや注釈の "TWFE PPML" や "ETWFE" を "Pooled Poisson QMLE" に修正

*  (6) 2010-2020 統合テーブル: PPML Event Study + jwdid ATT を同一表に並列表示
*  列構成: (1)-(2) PPML Event Study（EU HI, 共変量なし・あり）
*         (3)-(4) jwdid ATT（EU HI, 共変量なし・あり）
*         (5)-(6) jwdid ATT（All HI, 共変量なし・あり）
*  行構成: PPML係数（GBR_XXXX）はcols 1-2のみ、jwdid ATT係数はcols 3-6のみに表示
local combined_note_2010 "Columns (1)--(2): PPML event study coefficients (\texttt{ppmlhdfe}) with year-sector fixed effects and a UK cohort dummy (GBR). Columns (3)--(6): dynamic ATT estimates from the pooled Poisson QMLE framework (\texttt{jwdid}; \citealt{wooldridge2023simple}). Reference year for PPML: 2014."

esttab m1_twfe_full m1_twfe_full_cov m1_jwdid_full m1_jwdid_full_cov m2_jwdid_full m2_jwdid_full_cov ///
    using "../../04_tex/main/Tab4.tex", replace label booktabs nonumbers ///
    keep(GBR_2010 GBR_2012 GBR_2016 GBR_2018 GBR_2020 ///
         2016.cohort#2016.year#c.__tr__ 2016.cohort#2018.year#c.__tr__ 2016.cohort#2020.year#c.__tr__) ///
    cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.05 ** 0.01 *** 0.001) ///
    collabels(none) ///
    mtitle("(1)" "(2)" "(3)" "(4)" "(5)" "(6)") ///
    coeflabels(GBR_2010                          "~~UK \$\times\$ Year 2010 [ES]" ///
               GBR_2012                          "~~UK \$\times\$ Year 2012 [ES]" ///
               GBR_2016                          "~~UK \$\times\$ Year 2016 [ES]" ///
               GBR_2018                          "~~UK \$\times\$ Year 2018 [ES]" ///
               GBR_2020                          "~~UK \$\times\$ Year 2020 [ES]" ///
               2016.cohort#2016.year#c.__tr__    "~~UK \$\times\$ Year 2016 [ATT]" ///
               2016.cohort#2018.year#c.__tr__    "~~UK \$\times\$ Year 2018 [ATT]" ///
               2016.cohort#2020.year#c.__tr__    "~~UK \$\times\$ Year 2020 [ATT]") ///
    order(GBR_2010 GBR_2012 GBR_2016 GBR_2018 GBR_2020 ///
          2016.cohort#2016.year#c.__tr__ 2016.cohort#2018.year#c.__tr__ 2016.cohort#2020.year#c.__tr__) ///
    stats(cov N, fmt(0 %9.0fc) labels("Covariates" "Observations")) ///
    prehead("\begin{table}[!ht]\centering\caption{\label{tab:entry2010combined}The Brexit Referendum's Impact on New Affiliate Entry Count: PPML Event Study and Pooled Poisson QMLE (2010--2020)}\begin{threeparttable}\begin{tabular}{l*{6}{c}}\toprule" ///
            "\multicolumn{1}{c}{} & \multicolumn{2}{c}{PPML Event Study} & \multicolumn{4}{c}{Pooled Poisson QMLE ATT} \\" ///
            "\cmidrule(lr){2-3}\cmidrule(lr){4-7}" ///
            "\multicolumn{1}{c}{} & \multicolumn{4}{c}{EU High-Income} & \multicolumn{2}{c}{All High-Income} \\" ///
            "\cmidrule(lr){2-5}\cmidrule(lr){6-7}" ///
            "") ///
    posthead("\midrule") ///
    postfoot("\bottomrule\end{tabular}`fullwidth_note_start' `comparison_note_combined_2010' `data_note' `combined_note_2010' Within each estimator, columns without and with covariates are estimated on the same sample retained by \texttt{ppmlhdfe}'s separation algorithm (no-covariate specification). Standard errors clustered at the country-by-industry level in parentheses. * \$p<0.05\$, ** \$p<0.01\$, *** \$p<0.001\$. `fullwidth_note_end'")


exit

/*
### 理論的整合性をもたせるための主な修正点

1.  **国固定効果（`iso`）の完全な排除**:
    Wooldridge (2023) が警告するように、非線形モデルにフルセットのユニット固定効果（国ダミー）を含めると、ATT（レベル）の計算や有効な標準誤差の導出が著しく困難になります。そのため、`absorb(iso year_sector)` の部分を `absorb(year_sector)` のみに修正しました。
2.  **コホートダミー（`GBR`）の明示的な追加**:
    国固定効果を外した代わりに、ベースラインの処置群（イギリス）を識別するためのコホートダミー変数 `GBR` を、手動の `ppmlhdfe` モデル全てに追加しています（`jwdid` は `gvar(cohort)` を通じて内部的に自動処理します）。
3.  **国レベル共変量の復活と投入**:
    以前のコードでは、国レベルの共変量（`log_GDP_pc`, `log_Dist`）は国固定効果（`iso`）に吸収される前提で `local covs` から省略されていました。今回 `iso` を外したことで、これらは**コントロール群と処置群のベースライン規模の違い（scale differences）を調整する極めて重要な変数**として機能します。そのため、セクションCの `covs` マクロにこれらを明示的に追加しました。
4.  **出力ラベル（用語）の統一**:
    LaTeXへのエクスポート部分（出力セクション）において、"TWFE PPML" や、線形モデルの用語である "ETWFE" となっていた箇所を、すべて非線形DiDの正確な呼称である "**Pooled Poisson QMLE**" に修正し、本文との完璧な整合性を確保しました。
*/
