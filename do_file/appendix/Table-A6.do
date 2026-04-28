use "$data/final_for_analysis.dta", clear
preserve
collapse (max) popolazione_residente_1930 popolazione_residente_1950 densita_demografica_1950 inc_abitazioni_proprieta_1950 indice_vecchiaia_1950 incidenza_analfabeti_1950 tasso_occ_agric_1950 tasso_occ_industr_1950 tasso_occ_terz_1950 tasso_occ_comm_1950 altitude area confino unita_30_1950 unita_31_1950 unita_40_1950 unita_50_1950 unita_60_1950 unita_70_1950 unita_80_1950 unita_90_1950 addetti_30_1950 addetti_31_1950 addetti_40_1950 addetti_50_1950 addetti_60_1950 addetti_70_1950 addetti_80_1950 addetti_90_1950 (firstnm) idreg, by(codcom)
global matching popolazione_residente_1930 popolazione_residente_1950 densita_demografica_1950 inc_abitazioni_proprieta_1950 incidenza_analfabeti_1950 indice_vecchiaia_1950 tasso_occ_agric_1950 tasso_occ_industr_1950 tasso_occ_terz_1950 tasso_occ_comm_1950 altitude area unita_30_1950 unita_31_1950 unita_40_1950 unita_50_1950 unita_60_1950 unita_70_1950 unita_80_1950 unita_90_1950 addetti_30_1950 addetti_31_1950 addetti_40_1950 addetti_50_1950 addetti_60_1950 addetti_70_1950 addetti_80_1950 addetti_90_1950 i.idreg 
psmatch2 confino $matching, common neigh(5) 
pstest $matching if _support==1 & _weight!=.
tab _treated if _support==1 & _weight!=.
keep if _support==1 & _weight!=.
gen nn5 = 1
keep codcom nn5
tempfile nn5
save `nn5'
restore
merge m:1 codcom using `nn5'
drop _merge
qui summ d100f_tv_ if nn5
local mean_3: display %10.3f r(mean)
local panel_A_prehead "\begin{table}[!h]\centering\begin{threeparttable}" ///
 "\caption{Forced resettlement and TV tax compliance. PSM sample. \label{tab:rob-rf-matching}}" ///
 "\begin{tabular}{lcccc} \hline\hline"  ///
 "&\multicolumn{4}{c}{\textit{IHS(TV tax compliance rate)}} \\ \cmidrule(lr){2-5} "
local panel_A_posthead "\hline" 
local panel_A_prefoot "\hline" 
local notes ="\textit{\underline{Notes}.} Dependent variable: the IHS of the ratio of the number of TV licences over the number of households * 100. " + ///
"The main variable of interest, \textit{Confino\textsubscript{i,t}}, is a dummy equal to 1 if a municipality \textit{i} received a confinato. It is equal to 0 pre-1970 and equal to 1 from 1970 onward. " + ///
"The sample is restricted to one resulting from a nearest neighbout matching strategy. " + ///
"The matching strategy is based on the following variables: population (1930, 1950), population density (1950), elderly index (1950), illiterate index (1950), owned house index (1950), and employment rate in agriculture, industry, commerce and tertiary (1950), altitude, area, the number of employees by 2-digit sector (1950) and the number of firms by 2-digit sector (1950). Depending on the specification, we include municipality and decade fixed effects, municipality linear trends, region or province * decade fixed effects, respectively. " + ///
"Municipality clustered standard errors in parentheses. * p$<$0.10, ** p$<$0.05, *** p$<$0.01. "
local panel_A_postfoot "Mean TV tax&`mean_3'&`mean_3'&`mean_3'&`mean_3' \\ \hline  " ///
"Municipality and decade FE &\checkmark&\checkmark&\checkmark&\checkmark\\ " ///
"Municipality linear trends &&\checkmark&&\\ " ///
"Region * decade FE &&&\checkmark&\\ " ///
"Province * decade FE &&&&\checkmark\\ \hline\hline " ///
"\end{tabular} \begin{tablenotes} \item \scriptsize{`notes'} \end{tablenotes} \end{threeparttable} \end{table}"
eststo clear
qui eststo: reghdfe ihs_d100f_tv_ confino_t if nn5 == 1, a(i.codcom i.anno) vce(cluster codcom) 
qui eststo: reghdfe ihs_d100f_tv_ confino_t if nn5 == 1, a(i.codcom i.anno i.codcom#c.anno) vce(cluster codcom)  	     
qui eststo: reghdfe ihs_d100f_tv_ confino_t if nn5 == 1, a(i.codcom i.anno i.idreg#i.anno) vce(cluster codcom)  	    
qui eststo: reghdfe ihs_d100f_tv_ confino_t if nn5 == 1, a(i.codcom i.anno i.idprov#i.anno) vce(cluster codcom)  	    
esttab using "$tables/Table-A6.tex", ///
tex compress nomtitles replace width(\hsize) b (3) se starlevels(* 0.10 ** 0.05 *** 0.01) keep(confino_t) coeflabels(confino_t "\textit{Confino\textsubscript{i,t}}") ///
prehead("`panel_A_prehead'") posthead("`panel_A_posthead'") prefoot("`panel_A_prefoot'") postfoot("`panel_A_postfoot'") gaps
