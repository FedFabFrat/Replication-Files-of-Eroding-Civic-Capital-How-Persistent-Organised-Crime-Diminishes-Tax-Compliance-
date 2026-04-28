use "$data/final_for_analysis.dta", clear
global controls_1950 "popolazione_residente_1930 popolazione_residente_1950 densita_demografica_1950 indice_vecchiaia_1950 inc_abitazioni_proprieta_1950 incidenza_analfabeti_1950 tasso_occ_agric_1950 tasso_occ_industr_1950 tasso_occ_comm_1950 tasso_occ_terz_1950 altitude area"
cap estimates drop f_*
cap drop resid*
eststo clear
qui foreach y of varlist ihs_d100f_tv_ {
	// column (1) main estimate
	qui eststo: ivreghdfe `y' (ihs_n_news_ = confino_t), a(i.codcom i.anno c.($controls_1950)#i.anno) cl(codcom) savefirst savefprefix(f_) saverf saverfprefix(r_)    
	// AR CI
	qui do "$do\arci_poly"
	matrix list ar_l
	scalar sarl1 = ar_l[1,1]
	local larl1: display %6.3f sarl1
	matrix list ar_u
	scalar saru1 = ar_u[1,1]
	local laru1: display %6.3f saru1
	// Nevo and Rosen
	qui reghdfe `y', a(codcom anno  c.($controls_1950)#i.anno) resid nocons vce(cluster codcom)
	predict residy1, resid
	qui reghdfe ihs_n_news_, a(codcom anno  c.($controls_1950)#i.anno) resid nocons vce(cluster codcom)
	predict residx1, resid
	qui reghdfe confino_t, a(codcom anno  c.($controls_1950)#i.anno) resid nocons vce(cluster codcom)
	predict residz1, resid
	qui imperfectiv residy1 (residx1=residz1), vce(boot, reps(100))
	scalar uCIs1 = e(LRbounds)[1,4]
	local uCI1: display %6.3f uCIs1
	// FS coeff
	est restore f_ihs_n_news_
	scalar pval = (2 * ttail(e(df_r), abs(e(b)[1,1]/e(V)[1,1]^0.5)))
	scalar coeff = e(b)[1,1] 
	local cdis: display %6.3f coeff
	if pval <= 0.10 & pval > 0.05 {
		local star = "*"
	} 
	else if pval <= 0.05 & pval > 0.01 {
		local star = "**"
	} 
	else if pval <= 0.01 {
		local star = "***"
	} 
	else {
		local star = ""
	}
	local fsc1 `cdis'`star'
	est drop f_ihs_n_news_

	// column (2) main estimate
	qui eststo: ivreghdfe `y' (ihs_n_news_ = confino_t), a(i.codcom i.anno c.($controls_1950)#i.anno i.codcom#c.anno) cl(codcom) savefirst savefprefix(f_) saverf saverfprefix(r_)
	// AR CI
	qui do "$do\arci_poly"
	matrix list ar_l
	scalar sarl2 = ar_l[1,1]
	local larl2: display %6.3f sarl2
	matrix list ar_u
	scalar saru2 = ar_u[1,1]
	local laru2: display %6.3f saru2
	// Nevo and Rosen
	qui reghdfe `y', a(codcom anno  c.($controls_1950)#i.anno i.codcom#c.anno) resid nocons vce(cluster codcom)
	predict residy2, resid
	qui reghdfe ihs_n_news_, a(codcom anno  c.($controls_1950)#i.anno i.codcom#c.anno) resid nocons vce(cluster codcom)
	predict residx2, resid
	qui reghdfe confino_t, a(codcom anno  c.($controls_1950)#i.anno i.codcom#c.anno) resid nocons vce(cluster codcom)
	predict residz2, resid
	qui imperfectiv residy2 (residx2=residz2), vce(boot, reps(100))
	scalar uCIs2 = e(LRbounds)[1,4]
	local uCI2: display %6.3f uCIs2
	// FS coeff
	est restore f_ihs_n_news_
	scalar pval = (2 * ttail(e(df_r), abs(e(b)[1,1]/e(V)[1,1]^0.5)))
	scalar coeff = e(b)[1,1] 
	local cdis: display %6.3f coeff
	if pval <= 0.10 & pval > 0.05 {
		local star = "*"
	} 
	else if pval <= 0.05 & pval > 0.01 {
		local star = "**"
	} 
	else if pval <= 0.01 {
		local star = "***"
	} 
	else {
		local star = ""
	}
	local fsc2 `cdis'`star'
	est drop f_ihs_n_news_

	// column (3) main estimate
	qui eststo: ivreghdfe `y' (ihs_n_news_ = confino_t), a(i.codcom i.anno c.($controls_1950)#i.anno i.idreg#i.anno) cl(codcom) savefirst savefprefix(f_) saverf saverfprefix(r_)
	// AR CI
	qui do "$do\arci_poly"
	matrix list ar_l
	scalar sarl3 = ar_l[1,1]
	local larl3: display %6.3f sarl3
	matrix list ar_u
	scalar saru3 = ar_u[1,1]
	local laru3: display %6.3f saru3
	// Nevo and Rosen
	qui reghdfe `y', a(codcom anno  c.($controls_1950)#i.anno i.idreg#i.anno) resid nocons vce(cluster codcom)
	predict residy3, resid
	qui reghdfe ihs_n_news_, a(codcom anno  c.($controls_1950)#i.anno i.idreg#i.anno) resid nocons vce(cluster codcom)
	predict residx3, resid
	qui reghdfe confino_t, a(codcom anno  c.($controls_1950)#i.anno i.idreg#i.anno) resid nocons vce(cluster codcom)
	predict residz3, resid
	qui imperfectiv residy3 (residx3=residz3), vce(boot, reps(100))
	scalar uCIs3 = e(LRbounds)[1,4]
	local uCI3: display %6.3f uCIs3
	// FS coeff
	est restore f_ihs_n_news_
	scalar pval = (2 * ttail(e(df_r), abs(e(b)[1,1]/e(V)[1,1]^0.5)))
	scalar coeff = e(b)[1,1] 
	local cdis: display %6.3f coeff
	if pval <= 0.10 & pval > 0.05 {
		local star = "*"
	} 
	else if pval <= 0.05 & pval > 0.01 {
		local star = "**"
	} 
	else if pval <= 0.01 {
		local star = "***"
	} 
	else {
		local star = ""
	}
	local fsc3 `cdis'`star'
	est drop f_ihs_n_news_

	// column (4) main estimate
	qui eststo: ivreghdfe `y' (ihs_n_news_ = confino_t), a(i.codcom i.anno c.($controls_1950)#i.anno i.idprov#i.anno) cl(codcom) savefirst savefprefix(f_) saverf saverfprefix(r_)
	// AR CI
	qui do "$do\arci_poly"
	matrix list ar_l
	scalar sarl4 = ar_l[1,1]
	local larl4: display %6.3f sarl4
	matrix list ar_u
	scalar saru4 = ar_u[1,1]
	local laru4: display %6.3f saru4
	// Nevo and Rosen
	qui reghdfe `y', a(codcom anno  c.($controls_1950)#i.anno i.idprov#i.anno) resid nocons vce(cluster codcom)
	predict residy4, resid
	qui reghdfe ihs_n_news_, a(codcom anno  c.($controls_1950)#i.anno i.idprov#i.anno) resid nocons vce(cluster codcom)
	predict residx4, resid
	qui reghdfe confino_t, a(codcom anno  c.($controls_1950)#i.anno i.idprov#i.anno) resid nocons vce(cluster codcom)
	predict residz4, resid
	qui imperfectiv residy4 (residx4=residz4), vce(boot, reps(100))
	scalar uCIs4 = e(LRbounds)[1,4]
	local uCI4: display %6.3f uCIs4
	// FS coeff
	est restore f_ihs_n_news_
	scalar pval = (2 * ttail(e(df_r), abs(e(b)[1,1]/e(V)[1,1]^0.5)))
	scalar coeff = e(b)[1,1] 
	local cdis: display %6.3f coeff
	if pval <= 0.10 & pval > 0.05 {
		local star = "*"
	} 
	else if pval <= 0.05 & pval > 0.01 {
		local star = "**"
	} 
	else if pval <= 0.01 {
		local star = "***"
	} 
	else {
		local star = ""
	}
	local fsc4 `cdis'`star'
	est drop f_ihs_n_news_
}
ivreghdfe ihs_d100f_tv_ (ihs_n_news_ = confino_t), a(i.codcom i.anno c.($controls_1950)#i.anno) vce(cluster codcom) 
gen sample=e(sample)
qui summ d100f_tv_ if sample==1
local mean_3: display %10.3f r(mean)
local panel_ols_prehead "\begin{table}[!h]\centering\begin{threeparttable}" ///
 "\caption{Organized crime news and TV tax compliance.\label{tab:mainres-2sls}}" ///
 "\begin{tabular}{lcccc} \hline\hline" ///
 "&\multicolumn{4}{c}{\textit{IHS(TV tax compliance rate)}} \\ \cmidrule(lr){2-5} " 
local panel_ols_posthead "\hline &\multicolumn{4}{c}{\textit{Panel A - OLS}}\\ \cmidrule(lr){2-5} " 
local panel_ols_prefoot "%%" 
local panel_ols_postfoot "%%"
local panel_iv_prehead "%%"
local panel_iv_posthead "\hline &\multicolumn{4}{c}{\textit{Panel B - 2SLS}}\\ \cmidrule(lr){2-5} " 
local panel_iv_prefoot "&[`larl1',`laru1']&[`larl2',`laru2']&[`larl3',`laru3']&[`larl4',`laru4'] \\ \hline" 
local notes ="\textit{\underline{Notes}:} Dependent variable: the IHS of the ratio of the number of TV licences over the number of households * 100. " + ///
"The endogenous variable, \textit{Mafia\textsubscript{i,t}}, refers to the IHS of the number of news related to the mafia in municipality \textit{i} at \textit{t}. " + ///
"The instrumental variable, \textit{Confino\textsubscript{i,t}}, is a dummy equal to 1 if a municipality \textit{i} received a confinato. It is equal to 0 pre-1970 and equal to 1 from 1970 onward. " + ///
"\textit{Panel A} shows the OLS estimates, while \textit{Panel B} shows the 2SLS estimates. " + ///
"The Kleibergen-Paap (KP) and Cragg-Donald (CD) F statistic for weak identification, as well as the first stage coefficient, refer to \textit{Panel B} estimates. Upper bound confidence intervals are constructed following \citet{nevo2012identification}. " + ///
"In \textit{Panel B} confidence intervals based on inversion of the Anderson-Rubin test are shown in square brackets. " + ///
"Controls include municipality population (1930, 1950), population density (1950), elderly index (1950), illiterate index (1950), owned house index (1950), and employment rate in agriculture, industry, commerce and tertiary (1950), all interacted with decade dummies. Depending on the specification, we include municipality and decade fixed effects, municipality linear trends, region or province * decade fixed effects, respectively. " + ///
"Municipality clustered standard errors in parentheses. * p$<$0.10, ** p$<$0.05, *** p$<$0.01. "
local panel_iv_postfoot "NR Upper bound CI &`uCI1'&`uCI2'&`uCI3'&`uCI4' \\ FS coeff. &`fsc1'&`fsc2'&`fsc3'&`fsc4' \\  " ///
"Mean TV tax&`mean_3'&`mean_3'&`mean_3'&`mean_3' \\ \hline " ///
"Controls &\checkmark&\checkmark&\checkmark&\checkmark\\ " ///
"Municipality and decade FE &\checkmark&\checkmark&\checkmark&\checkmark\\ " ///
"Municipality linear trends &&\checkmark&&\\ " ///
"Region * decade FE &&&\checkmark&\\ " ///
"Province * decade FE &&&&\checkmark\\ \hline\hline " ///
"\end{tabular} \begin{tablenotes} \item \scriptsize{`notes'} \end{tablenotes} \end{threeparttable} \end{table}"
// first panel
eststo clear
qui eststo ihs_d100f_tv__ols_a: reghdfe ihs_d100f_tv_ ihs_n_news_, a(codcom anno c.($controls_1950)#i.anno) vce(cluster codcom) 
qui eststo ihs_d100f_tv__ols_d: reghdfe ihs_d100f_tv_ ihs_n_news_, a(codcom anno c.($controls_1950)#i.anno i.codcom#c.anno) vce(cluster codcom) 
qui eststo ihs_d100f_tv__ols_c: reghdfe ihs_d100f_tv_ ihs_n_news_, a(codcom anno c.($controls_1950)#i.anno i.idreg#i.anno) vce(cluster codcom) 
qui eststo ihs_d100f_tv__ols_b: reghdfe ihs_d100f_tv_ ihs_n_news_, a(codcom anno c.($controls_1950)#i.anno i.idprov#i.anno) vce(cluster codcom) 
esttab ihs_d100f_tv__ols_a ihs_d100f_tv__ols_d ihs_d100f_tv__ols_c ihs_d100f_tv__ols_b using "$tables/Table-A8.tex", /// 
tex compress nomtitles replace width(\hsize) b (3) se starlevels(* 0.10 ** 0.05 *** 0.01) keep(ihs_n_news_) coeflabels(ihs_n_news_ "\textit{IHS(Mafia\textsubscript{i,t}})") ///
prehead("`panel_ols_prehead'") posthead("`panel_ols_posthead'") prefoot(`panel_ols_prefoot') postfoot(`panel_ols_postfoot') gaps noobs
// other panel
eststo clear
qui eststo ihs_d100f_tv__ss_a: ivreghdfe ihs_d100f_tv_ (ihs_n_news_ = confino_t), a(i.codcom i.anno c.($controls_1950)#i.anno) vce(cluster codcom) 
qui eststo ihs_d100f_tv__ss_d: ivreghdfe ihs_d100f_tv_ (ihs_n_news_ = confino_t), a(i.codcom i.anno c.($controls_1950)#i.anno i.codcom#c.anno) vce(cluster codcom) 
qui eststo ihs_d100f_tv__ss_c: ivreghdfe ihs_d100f_tv_ (ihs_n_news_ = confino_t), a(i.codcom i.anno c.($controls_1950)#i.anno i.idreg#i.anno) vce(cluster codcom) 
qui eststo ihs_d100f_tv__ss_b: ivreghdfe ihs_d100f_tv_ (ihs_n_news_ = confino_t), a(i.codcom i.anno c.($controls_1950)#i.anno i.idprov#i.anno) vce(cluster codcom) 
esttab ihs_d100f_tv__ss_a ihs_d100f_tv__ss_d ihs_d100f_tv__ss_c ihs_d100f_tv__ss_b using "$tables/Table-A8.tex", /// 
tex compress nomtitles append nonumbers width(\hsize) b (3) se starlevels(* 0.10 ** 0.05 *** 0.01) keep(ihs_n_news_) coeflabels(ihs_n_news_ "\textit{IHS(Mafia\textsubscript{i,t}})") ///
prehead("`panel_iv_prehead'") posthead("`panel_iv_posthead'") prefoot(`panel_iv_prefoot') postfoot(`panel_iv_postfoot') scalar("rkf KP F-Stat" "cdf CD F-Stat") gaps
