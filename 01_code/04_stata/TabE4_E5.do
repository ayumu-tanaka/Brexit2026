* Kermani and Ma - 2022- Table
import excel "../../02_data_input/Kermani and Ma - 2022- Table.xlsx", sheet("Kermani and Ma - 2022- Table") firstrow clear
destring SIC, replace
sort SIC
tempfile kermani_table
save `kermani_table', replace


* OJC Industry to SIC
import excel "../../02_data_input/IndustryConvert.xlsx", sheet("Sheet1") firstrow clear
rename SIC AllSIC
reshape long SIC, i(OJCIndustryCode) j(code) 
sort SIC


* Combine
merge m:1 SIC using `kermani_table'

drop if _merge == 2
drop SIC2 _merge

* Reshape
reshape wide PPE SIC, i(OJCIndustryCode) j(code)
egen PPE = rowmean(PPE1 PPE2 PPE3 PPE4)
order PPE, before(SIC1)
keep OJCIndustryCode IndustryName AllSIC SICdescription PPE


* 固定資産（PPE）の清算回収率：平均35％（標準偏差13％）
g RecoveryRateHigh = PPE>0.35 & PPE<.
replace RecoveryRateHigh = . if PPE == .
order RecoveryRateHigh, after(PPE)


* Save
save "../../02_data_input/PPE.dta", replace
export excel "../../05_docs/asset_specificity/PPE.xlsx", replace first(var)


exit
