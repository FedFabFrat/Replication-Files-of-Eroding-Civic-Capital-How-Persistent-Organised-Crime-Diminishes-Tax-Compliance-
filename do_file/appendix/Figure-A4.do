use "$data/final_for_analysis.dta", clear
preserve
collapse (max) popolazione_residente_1930 popolazione_residente_1950 densita_demografica_1950 inc_abitazioni_proprieta_1950 incidenza_analfabeti_1950 tasso_occ_agric_1950 tasso_occ_industr_1950 tasso_occ_terz_1950 tasso_occ_comm_1950 altitude area confino unita_30_1950 unita_31_1950 unita_40_1950 unita_50_1950 unita_60_1950 unita_70_1950 unita_80_1950 unita_90_1950 addetti_30_1950 addetti_31_1950 addetti_40_1950 addetti_50_1950 addetti_60_1950 addetti_70_1950 addetti_80_1950 addetti_90_1950 (firstnm) idreg, by(codcom)
global matching popolazione_residente_1930 popolazione_residente_1950 densita_demografica_1950 inc_abitazioni_proprieta_1950 incidenza_analfabeti_1950 tasso_occ_agric_1950 tasso_occ_industr_1950 tasso_occ_terz_1950 tasso_occ_comm_1950 altitude area unita_30_1950 unita_31_1950 unita_40_1950 unita_50_1950 unita_60_1950 unita_70_1950 unita_80_1950 unita_90_1950 addetti_30_1950 addetti_31_1950 addetti_40_1950 addetti_50_1950 addetti_60_1950 addetti_70_1950 addetti_80_1950 addetti_90_1950 i.idreg
psmatch2 confino $matching, common neigh(5)
pstest $matching if _support==1 & _weight!=.
keep if _support==1 & _weight!=.
gen nn5 = 1
keep codcom nn5
tempfile nn5
save `nn5'
restore
merge m:1 codcom using `nn5'
drop _merge
xtset codcom anno, del(10)
gen treated_t = d.confino_t 
ta treated_t
recode treated_t . = 0
forvalues x=1/4 {
	gen lead`x' = f`x'.treated_t
	recode lead`x' . = 0
	gen lag`x' = l`x'.treated_t
	recode lag`x' . = 0
}
gen cen = 0
forvalues x=1/4 {
	ta lead`x'
	ta lag`x'
}
label var lead2 "1950"
label var cen "1960"
label var treated_t "1970"
label var lag1 "1980"
label var lag2 "1990"
label var lag3 "2000"


** RF **
eststo clear
qui eststo es_rf_1: reghdfe ihs_d100f_tv_ lead2 cen treated_t lag1 lag2 lag3 if nn5 == 1, a(codcom anno) vce(cluster codcom)
qui eststo es_rf_2: reghdfe ihs_d100f_tv_ lead2 cen treated_t lag1 lag2 if nn5 == 1, a(codcom anno i.codcom#c.anno) vce(cluster codcom)
qui eststo es_rf_3: reghdfe ihs_d100f_tv_ lead2 cen treated_t lag1 lag2 lag3 if nn5 == 1, a(codcom anno i.idreg#i.anno) vce(cluster codcom)
qui eststo es_rf_4: reghdfe ihs_d100f_tv_ lead2 cen treated_t lag1 lag2 lag3 if nn5 == 1, a(codcom anno i.idprov#i.anno) vce(cluster codcom)
coefplot (es_rf_1), bylabel(Base FE) ///
		 || (es_rf_2), bylabel(Muni linear trends) ///	
		 || (es_rf_3), bylabel(Region * decade FE ) ///	
		 || (es_rf_4), bylabel(Province * decade FE) ///	
		 ||, vertical keep(lead2 cen treated_t lag1 lag2 lag3) ///
		 cirecast(rcap) recast(connected) levels(95) omitted ///
		 xtitle("Years", size(medsmall) margin(medsmall)) ///
		 ytitle("Coefficient Estimates", size(medsmall) margin(medsmall)) ///
		 xline(2, lcolor(red) lpattern(dash)) ///
		 yline(0, lcolor(gs8) lpattern(dash)) ///
		 mc(navy) msize(medium) lc(navy) ciopts(lc(navy)) ///
		 byopts(cols(2))
graph export "$figures\Figure-A4.pdf", as(pdf) replace 



