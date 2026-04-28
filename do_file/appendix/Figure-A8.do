use "$data/final_for_analysis.dta", clear
global controls_1950 "popolazione_residente_1930 popolazione_residente_1950 densita_demografica_1950 indice_vecchiaia_1950 inc_abitazioni_proprieta_1950 incidenza_analfabeti_1950 tasso_occ_agric_1950 tasso_occ_industr_1950 tasso_occ_comm_1950 tasso_occ_terz_1950 altitude area"
cap drop resid*
ivreghdfe ihs_d100f_tv_ (ihs_n_news_ = confino_t), a(i.codcom i.anno c.($controls_1950)#i.anno) vce(cluster codcom) 
reghdfe ihs_d100f_tv_, a(codcom anno  c.($controls_1950)#i.anno) resid vce(cluster codcom)
predict residy, resid
reghdfe ihs_n_news_, a(codcom anno c.($controls_1950)#i.anno) resid vce(cluster codcom)
predict residx, resid
reghdfe confino_t, a(codcom anno c.($controls_1950)#i.anno) resid vce(cluster codcom)
predict residz, resid
reg residy residx, vce(robust)
reg residy residz, vce(robust)
ivreg2 residy (residx=residz), robust
scalar beta = e(b)[1,1]
reg residx residz, vce(robust)
scalar beta_fs = e(b)[1,1]
forvalues delta = 0(1)50 {
preserve
local gmin =  beta*beta_fs*(`delta'/100) 
local gmax = -(beta*beta_fs*(`delta'/100)) 
plausexog uci residy (residx=residz), vce(cluster codcom) gmin(`gmin') gmax(`gmax') level(0.90)
scalar delta = (`delta'/100)
scalar cil=e(lb_residx)
scalar ciu=e(ub_residx)
matrix res=(delta,cil,ciu)
svmat res
keep res*
keep if res1!=.
ren res1 delta
ren res2 cil
ren res3 ciu
tempfile conley`delta'
save `conley`delta''
restore
}
clear
forvalues delta=0(1)50 {
	append using `conley`delta''
}
twoway (line ciu delta, lcolor(gs10) lwidth(thin) lpattern(solid)) ///
	   (line cil delta, lcolor(gs10) lwidth(thin) lpattern(solid)), ///
	   yline(0, lwidth(medium) lpattern(dash) lcolor(black)) yline( -.234, lwidth(thin) lpattern(solid) lcolor(navy)) ///
	   xtitle("delta", size(medlarge)) xlabel(0(0.1)0.50) ylabel(-1(0.25)0.5) legend(off)
graph export "$figures\Figure-A8a.pdf", as(pdf) replace 	 
drop resid*


use "$data/final_for_analysis.dta", clear
global controls_1950 "popolazione_residente_1930 popolazione_residente_1950 densita_demografica_1950 indice_vecchiaia_1950 inc_abitazioni_proprieta_1950 incidenza_analfabeti_1950 tasso_occ_agric_1950 tasso_occ_industr_1950 tasso_occ_comm_1950 tasso_occ_terz_1950 altitude area"
cap drop resid*
ivreghdfe ihs_d100f_tv_ (ihs_n_news_ = confino_t), a(i.codcom i.anno c.($controls_1950)#i.anno i.codcom#c.anno) vce(cluster codcom) 
reghdfe ihs_d100f_tv_, a(codcom anno  c.($controls_1950)#i.anno i.codcom#c.anno) resid vce(cluster codcom)
predict residy, resid
reghdfe ihs_n_news_, a(codcom anno c.($controls_1950)#i.anno i.codcom#c.anno) resid vce(cluster codcom)
predict residx, resid
reghdfe confino_t, a(codcom anno c.($controls_1950)#i.anno i.codcom#c.anno) resid vce(cluster codcom)
predict residz, resid
reg residy residx, vce(robust)
reg residy residz, vce(robust)
ivreg2 residy (residx=residz), robust
scalar beta = e(b)[1,1]
reg residx residz, vce(robust)
scalar beta_fs = e(b)[1,1]
forvalues delta = 0(1)50 {
preserve
local gmin =  beta*beta_fs*(`delta'/100) 
local gmax = -(beta*beta_fs*(`delta'/100)) 
plausexog uci residy (residx=residz), vce(cluster codcom) gmin(`gmin') gmax(`gmax') level(0.90)
scalar delta = (`delta'/100)
scalar cil=e(lb_residx)
scalar ciu=e(ub_residx)
matrix res=(delta,cil,ciu)
svmat res
keep res*
keep if res1!=.
ren res1 delta
ren res2 cil
ren res3 ciu
tempfile conley`delta'
save `conley`delta''
restore
}
clear
forvalues delta=0(1)50 {
	append using `conley`delta''
}
twoway (line ciu delta, lcolor(gs10) lwidth(thin) lpattern(solid)) ///
	   (line cil delta, lcolor(gs10) lwidth(thin) lpattern(solid)), ///
	   yline(0, lwidth(medium) lpattern(dash) lcolor(black)) yline( -.251, lwidth(thin) lpattern(solid) lcolor(navy)) ///
	   xtitle("delta", size(medlarge)) xlabel(0(0.1)0.50) ylabel(-1(0.25)0.5) legend(off)
graph export "$figures\Figure-A8b.pdf", as(pdf) replace 	 
drop resid*


use "$data/final_for_analysis.dta", clear
global controls_1950 "popolazione_residente_1930 popolazione_residente_1950 densita_demografica_1950 indice_vecchiaia_1950 inc_abitazioni_proprieta_1950 incidenza_analfabeti_1950 tasso_occ_agric_1950 tasso_occ_industr_1950 tasso_occ_comm_1950 tasso_occ_terz_1950 altitude area"
cap drop resid*
ivreghdfe ihs_d100f_tv_ (ihs_n_news_ = confino_t), a(i.codcom i.anno c.($controls_1950)#i.anno i.idreg#i.anno) vce(cluster codcom) 
reghdfe ihs_d100f_tv_, a(codcom anno  c.($controls_1950)#i.anno i.idreg#i.anno) resid vce(cluster codcom)
predict residy, resid
reghdfe ihs_n_news_, a(codcom anno c.($controls_1950)#i.anno i.idreg#i.anno) resid vce(cluster codcom)
predict residx, resid
reghdfe confino_t, a(codcom anno c.($controls_1950)#i.anno i.idreg#i.anno) resid vce(cluster codcom)
predict residz, resid
reg residy residx, vce(robust)
reg residy residz, vce(robust)
ivreg2 residy (residx=residz), robust
scalar beta = e(b)[1,1]
reg residx residz, vce(robust)
scalar beta_fs = e(b)[1,1]
forvalues delta = 0(1)50 {
preserve
local gmin =  beta*beta_fs*(`delta'/100) 
local gmax = -(beta*beta_fs*(`delta'/100)) 
plausexog uci residy (residx=residz), vce(cluster codcom) gmin(`gmin') gmax(`gmax') level(0.90)
scalar delta = (`delta'/100)
scalar cil=e(lb_residx)
scalar ciu=e(ub_residx)
matrix res=(delta,cil,ciu)
svmat res
keep res*
keep if res1!=.
ren res1 delta
ren res2 cil
ren res3 ciu
tempfile conley`delta'
save `conley`delta''
restore
}
clear
forvalues delta=0(1)50 {
	append using `conley`delta''
}
twoway (line ciu delta, lcolor(gs10) lwidth(thin) lpattern(solid)) ///
	   (line cil delta, lcolor(gs10) lwidth(thin) lpattern(solid)), ///
	   yline(0, lwidth(medium) lpattern(dash) lcolor(black)) yline( -.226, lwidth(thin) lpattern(solid) lcolor(navy)) ///
	   xtitle("delta", size(medlarge)) xlabel(0(0.1)0.50) ylabel(-1(0.25)0.5) legend(off)
graph export "$figures\Figure-A8c.pdf", as(pdf) replace 	 
drop resid*


use "$data/final_for_analysis.dta", clear
global controls_1950 "popolazione_residente_1930 popolazione_residente_1950 densita_demografica_1950 indice_vecchiaia_1950 inc_abitazioni_proprieta_1950 incidenza_analfabeti_1950 tasso_occ_agric_1950 tasso_occ_industr_1950 tasso_occ_comm_1950 tasso_occ_terz_1950 altitude area"
cap drop resid*
ivreghdfe ihs_d100f_tv_ (ihs_n_news_ = confino_t), a(i.codcom i.anno c.($controls_1950)#i.anno i.idprov#i.anno) vce(cluster codcom) 
reghdfe ihs_d100f_tv_, a(codcom anno  c.($controls_1950)#i.anno i.idprov#i.anno) resid vce(cluster codcom)
predict residy, resid
reghdfe ihs_n_news_, a(codcom anno c.($controls_1950)#i.anno i.idprov#i.anno) resid vce(cluster codcom)
predict residx, resid
reghdfe confino_t, a(codcom anno c.($controls_1950)#i.anno i.idprov#i.anno) resid vce(cluster codcom)
predict residz, resid
reg residy residx, vce(robust)
reg residy residz, vce(robust)
ivreg2 residy (residx=residz), robust
scalar beta = e(b)[1,1]
reg residx residz, vce(robust)
scalar beta_fs = e(b)[1,1]
forvalues delta = 0(1)50 {
preserve
local gmin =  beta*beta_fs*(`delta'/100) 
local gmax = -(beta*beta_fs*(`delta'/100)) 
plausexog uci residy (residx=residz), vce(cluster codcom) gmin(`gmin') gmax(`gmax') level(0.90)
scalar delta = (`delta'/100)
scalar cil=e(lb_residx)
scalar ciu=e(ub_residx)
matrix res=(delta,cil,ciu)
svmat res
keep res*
keep if res1!=.
ren res1 delta
ren res2 cil
ren res3 ciu
tempfile conley`delta'
save `conley`delta''
restore
}
clear
forvalues delta=0(1)50 {
	append using `conley`delta''
}
twoway (line ciu delta, lcolor(gs10) lwidth(thin) lpattern(solid)) ///
	   (line cil delta, lcolor(gs10) lwidth(thin) lpattern(solid)), ///
	   yline(0, lwidth(medium) lpattern(dash) lcolor(black)) yline( -.153, lwidth(thin) lpattern(solid) lcolor(navy)) ///
	   xtitle("delta", size(medlarge)) xlabel(0(0.1)0.50) ylabel(-1(0.25)0.5) legend(off)
graph export "$figures\Figure-A8d.pdf", as(pdf) replace 	 
drop resid*