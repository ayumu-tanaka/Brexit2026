* ------------------------------------------------------------
* Table 4-style code (Stata do-file)
* Brexit referendum's impact on ENTRY and EXIT counts
* Unit: industry × country × year (biennial)
*
* Input:
*   03_data_output/EntryExit/N_affiliate_entry_exit.dta
*
* Output (LaTeX; not compiled here):
*   01_code/03_r_temp/Tab4_entry_exit_counts_ES.tex
*   01_code/03_r_temp/Tab4_entry_exit_counts_ETWFE.tex
* ------------------------------------------------------------

clear all
set more off

* Save console output to a log for easy inspection
capture log close _all
log using "Tab4_EntryExitCount_PooledPoissonQMLE.log", text replace

* 1. Load data
use "../../03_data_output/EntryExit/N_affiliate_entry_exit.dta", clear

* Basic cleaning
drop if iso == "" | missing(iso)
drop if missing(FASector) | FASector == 0
keep if inrange(year, 2010, 2020)

* Ensure integer years (biennial)
replace year = round(year)

* 2. Balanced panel: fill missing industry-country-year cells with zeros
sort iso FASector year
fillin iso FASector year
foreach v in N_entry_industry N_exit_industry N_total_industry {
    replace `v' = 0 if missing(`v')
}

* 3. Common variables for estimation
gen GBR = (iso == "GBR")

* Comparison group: EU high-income countries (incl. UK)
gen is_EU_HI = inlist(iso, "AUT", "BEL", "DNK", "FIN", "FRA", "DEU", "IRL", "ITA") | ///
               inlist(iso, "LUX", "NLD", "SWE", "GBR")
gen sample_HI = (is_EU_HI == 1)

* Extended comparison group: add non-EU high-income countries
* (consistent with Tab4.do)
gen is_NonEU_HI = inlist(iso, "CAN", "AUS", "CHE", "KOR", "NZL")
gen sample_ALL = (is_EU_HI == 1 | is_NonEU_HI == 1)

egen id = group(iso FASector)
egen year_sector = group(year FASector)

* Reference year for event study
local ref_year 2014

* UK × year indicators (exclude reference year)
local years_es ""
local order_es ""
local labels_es ""
forvalues y = 2010(2)2020 {
    if `y' != `ref_year' {
    gen GBR_`y' = (GBR == 1 & year == `y')
    local years_es "`years_es' GBR_`y'"
    local order_es "`order_es' GBR_`y'"
    local labels_es `"`labels_es' GBR_`y' "~~UK $\times$ Year `y' [ES]""'
    }
}

* cohort for jwdid (single treated cohort = 2016)
gen cohort = cond(GBR == 1, 2016, 0)

* --- Estimation section ---
* Requires: ppmlhdfe, jwdid, estout

* A. Entry count (EU high-income comparison)
* PPML event study with iso×industry FE (id) and year FE
ppmlhdfe N_entry_industry `years_es' if sample_HI, absorb(id year) cluster(iso FASector)
estadd local outcome "Entry"
estimates store m_entry_es

* Pooled Poisson QMLE DiD (dynamic ATT) with iso×industry FE via ivar(id)
* and year×sector FE via fevar(year_sector), as in DiD_notes15_NRY2024.qmd.
*
* - Default jwdid aggregation corresponds to heterogeneity-robust (ETWFE-style) aggregation.
* - Linear TWFE event study (OLS) is estimated with reghdfe and reported together with PPML ES.
jwdid N_entry_industry if sample_HI, ivar(id) tvar(year) gvar(cohort) method(ppmlhdfe) fevar(year_sector) cluster(iso FASector) never
estadd local het "ETWFE"
estimates store m_entry_att_etwfe

estadd local outcome "Entry"

* B. Exit count (EU high-income comparison)
ppmlhdfe N_exit_industry `years_es' if sample_HI, absorb(id year) cluster(iso FASector)
estadd local outcome "Exit"
estimates store m_exit_es

jwdid N_exit_industry if sample_HI, ivar(id) tvar(year) gvar(cohort) method(ppmlhdfe) fevar(year_sector) cluster(iso FASector) never
estadd local het "ETWFE"
estimates store m_exit_att_etwfe

estadd local outcome "Exit"

* C. Entry count (All high-income comparison: EU HI + non-EU HI)
ppmlhdfe N_entry_industry `years_es' if sample_ALL, absorb(id year) cluster(iso FASector)
estadd local outcome "Entry"
estimates store m_entry_es_all

jwdid N_entry_industry if sample_ALL, ivar(id) tvar(year) gvar(cohort) method(ppmlhdfe) fevar(year_sector) cluster(iso FASector) never
estadd local het "ETWFE"
estimates store m_entry_att_all_etwfe

estadd local outcome "Entry"

* D. Exit count (All high-income comparison: EU HI + non-EU HI)
ppmlhdfe N_exit_industry `years_es' if sample_ALL, absorb(id year) cluster(iso FASector)
estadd local outcome "Exit"
estimates store m_exit_es_all

jwdid N_exit_industry if sample_ALL, ivar(id) tvar(year) gvar(cohort) method(ppmlhdfe) fevar(year_sector) cluster(iso FASector) never
estadd local het "ETWFE"
estimates store m_exit_att_all_etwfe

estadd local outcome "Exit"

* --- Linear TWFE event studies (OLS) for comparison with PPML ES ---
* Requires: reghdfe
*
* Note: We cluster at the iso-by-industry level (id). Using two-way clustering
* on (iso, FASector) can lead to missing VCEs in some reghdfe versions when
* iso×industry FE is absorbed.

* EU high-income comparison
reghdfe N_entry_industry `years_es' if sample_HI, absorb(id year) vce(cluster id)
estimates store m_entry_es_ols
reghdfe N_exit_industry `years_es' if sample_HI, absorb(id year) vce(cluster id)
estimates store m_exit_es_ols

* All high-income comparison
reghdfe N_entry_industry `years_es' if sample_ALL, absorb(id year) vce(cluster id)
estimates store m_entry_es_all_ols
reghdfe N_exit_industry `years_es' if sample_ALL, absorb(id year) vce(cluster id)
estimates store m_exit_es_all_ols

* --- Output section (LaTeX) ---
local data_note "The unit of observation is industry-by-country-by-year (biennial). Columns (1)--(4) use EU high-income countries as the comparison group; columns (5)--(8) add non-EU high-income countries (CAN, AUS, CHE, KOR, NZL). Outcomes are counts of new Japanese affiliate entries and exits."
local model_note_etwfe "Dynamic ATT (ETWFE aggregation): pooled Poisson QMLE DiD (jwdid; Wooldridge 2023) with iso-by-industry fixed effects (ivar) and year-by-sector fixed effects (fevar(year_sector))."
local model_note_es "Columns labeled PPML ES use pooled Poisson QMLE (ppmlhdfe) with iso-by-industry fixed effects and year fixed effects. Columns labeled OLS ES use linear TWFE event-study (reghdfe) with the same fixed effects."
local separation_note "Because ppmlhdfe applies a separation (perfect prediction) procedure, the number of observations retained can differ substantially between entry and exit outcomes."
local fullwidth_note_start "\end{threeparttable}\par\medskip\parbox{\linewidth}{\footnotesize \textit{Notes:} "
local fullwidth_note_end "}\end{table}"

* Keep: UK×year coefficients for ES columns, and ATT terms from jwdid
* jwdid stores dynamic effects using interactions like: 2016.cohort#YYYY.year#c.__tr__
local keep_att "2016.cohort#2016.year#c.__tr__ 2016.cohort#2018.year#c.__tr__ 2016.cohort#2020.year#c.__tr__"

* --- Export: ETWFE-aggregated ATT table (ATT only) ---
esttab m_entry_att_etwfe m_exit_att_etwfe m_entry_att_all_etwfe m_exit_att_all_etwfe
esttab m_entry_att_etwfe m_exit_att_etwfe m_entry_att_all_etwfe m_exit_att_all_etwfe ///
    using "Tab4_entry_exit_counts_ETWFE.tex", replace label booktabs nonumbers ///
    keep(`keep_att') ///
    order(`keep_att') ///
    coeflabels(2016.cohort#2016.year#c.__tr__ "~~UK $\times$ Year 2016 [ATT]" ///
               2016.cohort#2018.year#c.__tr__ "~~UK $\times$ Year 2018 [ATT]" ///
               2016.cohort#2020.year#c.__tr__ "~~UK $\times$ Year 2020 [ATT]") ///
    cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.05 ** 0.01 *** 0.001) ///
    collabels(none) ///
    mtitle("(1)" "(2)" "(3)" "(4)") ///
    stats(N, fmt(%9.0fc) labels("Observations")) ///
    prehead("\begin{table}[!ht]\centering\caption{\label{tab:entryexit_counts_etwfe}The Brexit Referendum's Impact on Entry and Exit Counts: Pooled Poisson QMLE Dynamic ATT (ETWFE aggregation, 2010--2020)}\begin{threeparttable}\begin{tabular}{l*{4}{c}}\toprule" ///
            "\multicolumn{1}{c}{} & \multicolumn{2}{c}{EU High-Income Comparison} & \multicolumn{2}{c}{All High-Income Comparison} \\" ///
            "\cmidrule(lr){2-3}\cmidrule(lr){4-5}" ///
            "\multicolumn{1}{c}{} & \multicolumn{1}{c}{Entry count} & \multicolumn{1}{c}{Exit count} & \multicolumn{1}{c}{Entry count} & \multicolumn{1}{c}{Exit count} \\" ///
            "\midrule") ///
    postfoot("\bottomrule\end{tabular}`fullwidth_note_start' `data_note' `model_note_etwfe' `separation_note' Standard errors clustered at the country-by-industry level in parentheses. * \$p<0.05\$, ** \$p<0.01\$, *** \$p<0.001\$. `fullwidth_note_end'")

* --- Export: Event-study table (PPML ES + OLS-TWFE ES) ---
esttab m_entry_es m_entry_es_ols m_exit_es m_exit_es_ols m_entry_es_all m_entry_es_all_ols m_exit_es_all m_exit_es_all_ols
esttab m_entry_es m_entry_es_ols m_exit_es m_exit_es_ols m_entry_es_all m_entry_es_all_ols m_exit_es_all m_exit_es_all_ols ///
    using "Tab4_entry_exit_counts_ES.tex", replace label booktabs nonumbers ///
    keep(`years_es') ///
    order(`order_es') ///
    coeflabels(`labels_es') ///
    cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.05 ** 0.01 *** 0.001) ///
    collabels(none) ///
    mtitle("(1)" "(2)" "(3)" "(4)" "(5)" "(6)" "(7)" "(8)") ///
    stats(N, fmt(%9.0fc) labels("Observations")) ///
    prehead("\begin{table}[!ht]\centering\caption{\label{tab:entryexit_counts_es}The Brexit Referendum's Impact on Entry and Exit Counts: PPML ES vs OLS-TWFE ES (2010--2020)}\begin{threeparttable}\begin{tabular}{l*{8}{c}}\toprule" ///
            "\multicolumn{1}{c}{} & \multicolumn{4}{c}{EU High-Income Comparison} & \multicolumn{4}{c}{All High-Income Comparison} \\" ///
            "\cmidrule(lr){2-5}\cmidrule(lr){6-9}" ///
            "\multicolumn{1}{c}{} & \multicolumn{2}{c}{Entry count} & \multicolumn{2}{c}{Exit count} & \multicolumn{2}{c}{Entry count} & \multicolumn{2}{c}{Exit count} \\" ///
            "\cmidrule(lr){2-3}\cmidrule(lr){4-5}\cmidrule(lr){6-7}\cmidrule(lr){8-9}" ///
            "\multicolumn{1}{c}{} & \multicolumn{1}{c}{PPML ES} & \multicolumn{1}{c}{OLS ES} & \multicolumn{1}{c}{PPML ES} & \multicolumn{1}{c}{OLS ES} & \multicolumn{1}{c}{PPML ES} & \multicolumn{1}{c}{OLS ES} & \multicolumn{1}{c}{PPML ES} & \multicolumn{1}{c}{OLS ES} \\" ///
            "\midrule") ///
    postfoot("\bottomrule\end{tabular}`fullwidth_note_start' `data_note' `model_note_es' `separation_note' Standard errors clustered at the country-by-industry level in parentheses. * \$p<0.05\$, ** \$p<0.01\$, *** \$p<0.001\$. `fullwidth_note_end'")

log close
exit
