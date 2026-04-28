use "$data/final_for_analysis.dta", clear
global controls_1950 "popolazione_residente_1930 popolazione_residente_1950 densita_demografica_1950 indice_vecchiaia_1950 inc_abitazioni_proprieta_1950 incidenza_analfabeti_1950 tasso_occ_agric_1950 tasso_occ_industr_1950 tasso_occ_comm_1950 tasso_occ_terz_1950 altitude area"
global controls "popolazione_residente densita_demografica indice_vecchiaia inc_abitazioni_proprieta incidenza_analfabeti tasso_occ_agric tasso_occ_industr tasso_occ_comm tasso_occ_terz altitude area"
eststo clear
cap gen omit = 1 if inlist(anno,1950,1960) & n_news_ >= 1
bys codcom (anno): carryforward omit, replace
recode omit .=0
cap estimates drop f_*
cap drop resid*
qui eststo: reghdfe ihs_d100f_tv_ confino_t $controls, a(i.codcom i.anno i.idprov#i.anno) vce(cluster codcom)  	 
gen sam1 = 1 if e(sample) == 1   
qui eststo: ppmlhdfe d100f_tv_ confino_t c.($controls_1950)#i.anno, a(i.codcom i.anno i.idprov#i.anno) vce(cluster codcom)  	    
gen sam2 = 1 if e(sample) == 1   
qui eststo: reghdfe ihs_d100f_tv_ confino_t if omit == 0, a(i.codcom i.anno c.($controls_1950)#i.anno i.idprov#i.anno) vce(cluster codcom)  	    
gen sam3 = 1 if e(sample) == 1   
qui eststo: reghdfe ihs_d100f_tvrad confino_t, a(i.codcom i.anno c.($controls_1950)#i.anno i.idprov#i.anno) vce(cluster codcom) 
forvalues n=1/3 {
qui summ d100f_tv_ if sam`n' == 1
local mean_`n': display %10.3f r(mean)	
}
qui summ d100f_tvrad if sam2 == 1
local mean_4: display %10.3f r(mean)
local panel_A_prehead "\begin{table}[!h]\centering\begin{threeparttable}" ///
 "\caption{Forced resettlement and TV tax compliance. Other specifications. \label{tab:rf-rob-other}}" ///
 "\begin{tabular}{lcccc} \hline\hline" 
local panel_A_posthead "\hline" 
local panel_A_prefoot "\hline"
local notes ="\textit{\underline{Notes}.} Column (1) employs contemporaneous controls. Column (2) employs a Poisson pseudo-likelihoo estimator and avoid the IHS transformation on the dependent variable. Column (3) excludes those municipalities that exhibit any organised crime related news in the 1950 decade. Column (4) uses as dependent variable the IHS of the ratio of the number of TV licences over the number of households * 100, which is summed with the ratio of the number of radios over the number of households." + ///
"In all columns but in column (1), controls include municipality population (1930, 1950), population density (1950), elderly index (1950), illiterate index (1950), owned house index (1950), and employment rate in agriculture, industry, commerce and tertiary (1950), altitude and area, all interacted with decade dummies. We include municipality and decade fixed effects. " + ///
"Municipality clustered standard errors in parentheses. * p$<$0.10, ** p$<$0.05, *** p$<$0.01. "
local panel_A_postfoot "Mean Y&`mean_1'&`mean_2'&`mean_3'&`mean_4' \\ \hline  " ///
"Municipality and decade FE &\checkmark&\checkmark&\checkmark&\checkmark\\ " ///
"Prov * decade FE &\checkmark&\checkmark&\checkmark&\checkmark\\ " ///
"Baseline controls &&\checkmark&\checkmark&\checkmark\\ " ///
"Contemp. controls &\checkmark&&&\\" ///
"Poisson estimator &&\checkmark&&\\" ///
"No mani. dest. &&&\checkmark&\\ " ///
"TV+radio &&&&\checkmark\\  \hline\hline " ///
"\end{tabular} \begin{tablenotes} \item \scriptsize{`notes'} \end{tablenotes} \end{threeparttable} \end{table}"
esttab using "$tables/Table-A3.tex", ///
tex compress nomtitles replace width(\hsize) b (3) se starlevels(* 0.10 ** 0.05 *** 0.01) keep(confino_t) coeflabels(confino_t "\textit{Confino\textsubscript{i,t}}") ///
prehead("`panel_A_prehead'") posthead("`panel_A_posthead'") prefoot("`panel_A_prefoot'") postfoot("`panel_A_postfoot'") gaps
