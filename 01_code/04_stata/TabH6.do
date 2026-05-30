* Appendix H: New affiliate entry by Brexit MFN risk group
* Goal:
*   - Use EU high-income countries as the comparison group
*   - Estimate PPML event-study coefficients and pooled Poisson QMLE ATT
*   - Report results with three row groups:
*       1. High MFN Risk
*       2. Low MFN Risk
*       3. Services

clear all
set more off

* ------------------------------------------------------------
* 0. File paths
* ------------------------------------------------------------

local data_path "../../03_data_output/EntryExit/N_affiliate_entry_country_industry_year.dta"
local map_path  "../../02_data_input/SectorCode2009_BrexitMFN3.csv"
local out_tex   "../../04_tex/main/TabH6.tex"

* ------------------------------------------------------------
* 1. Load entry-count panel
* ------------------------------------------------------------

use "`data_path'", clear

rename FA_SectorCode2009 FA_Sector

keep if inlist(year, 2010, 2012, 2014, 2016, 2018, 2020)
drop if FA_Sector == 0 | iso == ""

* ------------------------------------------------------------
* 2. Build balanced country-industry-year panel
* ------------------------------------------------------------

fillin iso FA_Sector year
replace N = 0 if missing(N)

* Recreate sample indicator after fillin.
gen byte sample_HI = inlist(iso, "AUT", "BEL", "DNK", "FIN", "FRA", "DEU", "IRL", "ITA") | ///
                     inlist(iso, "LUX", "NLD", "SWE", "GBR")

* Treatment and panel identifiers.
gen byte GBR = (iso == "GBR")
foreach y in 2010 2012 2016 2018 2020 {
    gen byte GBR_`y' = (iso == "GBR" & year == `y')
}
gen cohort = cond(iso == "GBR", 2016, 0)
egen iso_id = group(iso)
egen id = group(iso FA_Sector)
egen year_sector = group(year FA_Sector)

* ------------------------------------------------------------
* 3. Merge BrexitMFN3 classification
* ------------------------------------------------------------

tempfile mapfile

preserve
import delimited "`map_path'", clear varnames(1) stringcols(_all)
ds
local mapvars `r(varlist)'
local sectorvar : word 1 of `mapvars'
local groupvar  : word 3 of `mapvars'
keep `sectorvar' `groupvar'
rename `sectorvar' FA_Sector
rename `groupvar'  BrexitMFN3
destring FA_Sector, replace

gen byte mfn3_group = .
replace mfn3_group = 1 if lower(BrexitMFN3) == "high"
replace mfn3_group = 2 if lower(BrexitMFN3) == "low"
replace mfn3_group = 3 if lower(BrexitMFN3) == "service"

label define mfn3_group_lbl 1 "High MFN Risk" 2 "Low MFN Risk" 3 "Services"
label values mfn3_group mfn3_group_lbl

drop if missing(mfn3_group)
duplicates drop FA_Sector, force
save "`mapfile'", replace
restore

merge m:1 FA_Sector using "`mapfile'", nogen keep(match)

* Keep only the EU high-income comparison design.
keep if sample_HI == 1

* ------------------------------------------------------------
* 4. Estimate models by BrexitMFN3 group
* ------------------------------------------------------------

eststo clear

forvalues g = 1/3 {
    preserve
    keep if mfn3_group == `g'

    if `g' == 1 local gname high
    if `g' == 2 local gname low
    if `g' == 3 local gname service

    * PPML event study with year-sector fixed effects.
    eststo es_`gname': ppmlhdfe N GBR GBR_2010 GBR_2012 GBR_2016 GBR_2018 GBR_2020, ///
        absorb(year_sector) cluster(iso_id FA_Sector)

    estadd local mfn_group "`: label mfn3_group_lbl `g''"
    estadd local estimator "PPML Event Study"

    * Pooled Poisson QMLE ATT using jwdid.
    eststo att_`gname': jwdid N, ivar(id) tvar(year) gvar(cohort) ///
        method(ppmlhdfe) fevar(year_sector) cluster(id FA_Sector)

    estadd local mfn_group "`: label mfn3_group_lbl `g''"
    estadd local estimator "Pooled Poisson QMLE ATT"

    restore
}

* ------------------------------------------------------------
* 5. Export with esttab in Tab4 style
* ------------------------------------------------------------

local note1 "The outcome is the biennial count of new Japanese affiliate entries in a host country by industry."
local note2 "The comparison group is restricted to EU high-income countries (AUT, BEL, DNK, FIN, FRA, DEU, IRL, ITA, LUX, NLD, SWE) with the UK as the treated unit."
local note3 "Columns (1)--(3) report PPML event-study coefficients from \texttt{ppmlhdfe} with year-sector fixed effects and a UK cohort dummy (GBR). The PPML reference year is 2014. Columns (4)--(6) report dynamic ATT estimates from \texttt{jwdid} following Wooldridge (2023)."
local note4 "Standard errors clustered two-way by country-industry cell and industry are reported in parentheses. * p \(<\) 0.05, ** p \(<\) 0.01, *** p \(<\) 0.001."
local note5 "Rows labeled [ES] correspond to PPML event-study coefficients; rows labeled [ATT] correspond to pooled Poisson QMLE ATT estimates."

esttab es_high es_low es_service att_high att_low att_service ///
    using "`out_tex'", replace label booktabs nonumbers nomtitles noobs ///
    keep(GBR_2010 GBR_2012 GBR_2016 GBR_2018 GBR_2020 ///
         2016.cohort#2016.year#c.__tr__ 2016.cohort#2018.year#c.__tr__ 2016.cohort#2020.year#c.__tr__) ///
    cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.05 ** 0.01 *** 0.001) ///
    collabels(none) ///
    coeflabels(GBR_2010                       "~~UK \$\times\$ Year 2010 [ES]" ///
               GBR_2012                       "~~UK \$\times\$ Year 2012 [ES]" ///
               GBR_2016                       "~~UK \$\times\$ Year 2016 [ES]" ///
               GBR_2018                       "~~UK \$\times\$ Year 2018 [ES]" ///
               GBR_2020                       "~~UK \$\times\$ Year 2020 [ES]" ///
               2016.cohort#2016.year#c.__tr__ "~~UK \$\times\$ Year 2016 [ATT]" ///
               2016.cohort#2018.year#c.__tr__ "~~UK \$\times\$ Year 2018 [ATT]" ///
               2016.cohort#2020.year#c.__tr__ "~~UK \$\times\$ Year 2020 [ATT]") ///
    order(GBR_2010 GBR_2012 GBR_2016 GBR_2018 GBR_2020 ///
          2016.cohort#2016.year#c.__tr__ 2016.cohort#2018.year#c.__tr__ 2016.cohort#2020.year#c.__tr__) ///
    stats(N, fmt(%9.0fc) labels("Observations")) ///
    prehead("\begin{table}[!htbp]\centering\caption{\label{tab:EntrySector}The Brexit Referendum's Impact on New Affiliate Entry Count by Brexit MFN Risk Group: PPML Event Study and Pooled Poisson QMLE ATT}\begin{threeparttable}\begin{tabular}{l*{6}{c}}\toprule" ///
            "\multicolumn{1}{c}{} & \multicolumn{3}{c}{PPML Event Study} & \multicolumn{3}{c}{Pooled Poisson QMLE ATT} \\" ///
            "\cmidrule(lr){2-4}\cmidrule(lr){5-7}" ///
            "\multicolumn{1}{c}{} & \multicolumn{1}{c}{High MFN Risk} & \multicolumn{1}{c}{Low MFN Risk} & \multicolumn{1}{c}{Services} & \multicolumn{1}{c}{High MFN Risk} & \multicolumn{1}{c}{Low MFN Risk} & \multicolumn{1}{c}{Services} \\" ///
            "\multicolumn{1}{c}{} & \multicolumn{1}{c}{(1)} & \multicolumn{1}{c}{(2)} & \multicolumn{1}{c}{(3)} & \multicolumn{1}{c}{(4)} & \multicolumn{1}{c}{(5)} & \multicolumn{1}{c}{(6)} \\" ///
            "") ///
    posthead("\midrule") ///
    postfoot("\bottomrule\end{tabular}\begin{tablenotes}[flushleft]\footnotesize\item \textit{Notes:} `note1' `note2' `note3' `note4' `note5' \end{tablenotes}\end{threeparttable}\end{table}")

display as text "Saved do-file output table to: `out_tex'"

exit
