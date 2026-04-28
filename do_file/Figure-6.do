use "$data/final_for_analysis.dta", clear
global controls_1950 "popolazione_residente_1930 popolazione_residente_1950 densita_demografica_1950 indice_vecchiaia_1950 inc_abitazioni_proprieta_1950 incidenza_analfabeti_1950 tasso_occ_agric_1950 tasso_occ_industr_1950 tasso_occ_comm_1950 tasso_occ_terz_1950 altitude area"
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
qui eststo es_rf_1: reghdfe nfirms_ lead2 cen treated_t lag1 lag2 lag3, a(codcom anno c.($controls_1950)#i.anno i.idprov#i.anno) vce(cluster codcom)
qui eststo es_rf_2: reghdfe nfirms_mining lead2 cen treated_t lag1 lag2 lag3, a(codcom anno c.($controls_1950)#i.anno i.idprov#i.anno) vce(cluster codcom)
qui eststo es_rf_3: reghdfe nfirms_manuf lead2 cen treated_t lag1 lag2 lag3, a(codcom anno c.($controls_1950)#i.anno i.idprov#i.anno) vce(cluster codcom)
qui eststo es_rf_4: reghdfe nfirms_energy lead2 cen treated_t lag1 lag2 lag3, a(codcom anno c.($controls_1950)#i.anno i.idprov#i.anno) vce(cluster codcom)
qui eststo es_rf_5: reghdfe nfirms_constr lead2 cen treated_t lag1 lag2 lag3, a(codcom anno c.($controls_1950)#i.anno i.idprov#i.anno) vce(cluster codcom)
qui eststo es_rf_6: reghdfe nfirms_services lead2 cen treated_t lag1 lag2 lag3, a(codcom anno c.($controls_1950)#i.anno i.idprov#i.anno) vce(cluster codcom)
qui eststo es_rf_7: reghdfe ihs_sh100_estor lead2 cen treated_t lag1 lag2 lag3, a(codcom anno c.($controls_1950)#i.anno i.idprov#i.anno) vce(cluster codcom)
qui eststo es_rf_8: reghdfe ihs_sh100_labor lead2 cen treated_t lag1 lag2 lag3, a(codcom anno c.($controls_1950)#i.anno i.idprov#i.anno) vce(cluster codcom)
coefplot (es_rf_1), bylabel(N. firms) ///
		 || (es_rf_2), bylabel(N. mining firms) ///	
		 || (es_rf_3), bylabel(N. manuf. firms) ///	
		 || (es_rf_4), bylabel(N. energy firms) ///	
		 || (es_rf_5), bylabel(N. construction firms) ///	
		 || (es_rf_6), bylabel(N. services firms) ///	
		 || (es_rf_7), bylabel(IHS of Extorsion news) ///	
		 || (es_rf_8), bylabel(IHS of Labour racketeering) ///	
		 ||, vertical keep(lead2 cen treated_t lag1 lag2 lag3) ///
		 cirecast(rcap) recast(connected) levels(95) omitted ///
		 xtitle("Years", size(medsmall) margin(medsmall)) ///
		 ytitle("Coefficient Estimates", size(medsmall) margin(medsmall)) ///
		 xline(2, lcolor(red) lpattern(dash)) ///
		 yline(0, lcolor(gs8) lpattern(dash)) ///
		 mc(navy) msize(medium) lc(navy) ciopts(lc(navy)) ///
		 xlabel(,alternate labsize(small)) ylabel(,labsize(small)) ///
		 byopts(cols(3) yrescale)
graph export "$figures\Figure-6.pdf", as(pdf) replace

