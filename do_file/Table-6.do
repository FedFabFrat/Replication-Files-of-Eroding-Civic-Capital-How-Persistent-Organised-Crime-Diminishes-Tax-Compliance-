use "$data/final_for_analysis.dta", clear
global controls_1950 "popolazione_residente_1930 popolazione_residente_1950 densita_demografica_1950 indice_vecchiaia_1950 inc_abitazioni_proprieta_1950 incidenza_analfabeti_1950 tasso_occ_agric_1950 tasso_occ_industr_1950 tasso_occ_comm_1950 tasso_occ_terz_1950 altitude area"
eststo clear
qui eststo: reghdfe ihs_d100f_tv_ 1.confino_t, a(i.codcom i.anno c.($controls_1950)#i.anno i.idreg#i.anno) vce(cluster codcom) 
qui eststo: reghdfe ihs_d100f_tv_ 1.confino_t##c.share_s_migrants, a(i.codcom i.anno c.($controls_1950)#i.anno i.idreg#i.anno) vce(cluster codcom)  	     
qui eststo: reghdfe ihs_d100f_tv_ 1.confino_t##c.share_mi_migrants, a(i.codcom i.anno c.($controls_1950)#i.anno i.idreg#i.anno) vce(cluster codcom)  	     
qui summ d100f_tv_ if e(sample) == 1
local mean_3: display %10.3f r(mean)
local panel_A_prehead "\begin{table}[!h]\centering\begin{threeparttable}" ///
 "\caption{Forced resettlement and TV tax compliance. Migration heterogeneity. \label{tab:mech-migr}}" ///
 "\begin{tabular}{lccc} \hline\hline"  ///
 "&\multicolumn{3}{c}{\textit{IHS(TV tax compliance rate)}}\\ \cmidrule(lr){2-4} "
local panel_A_posthead "\hline" 
local panel_A_prefoot "\hline"
local notes ="\textit{\underline{Notes}.} Dependent variable: the IHS of the ratio of the number of TV licences over the number of households * 100. " + ///
"The main variable of interest, \textit{Confino\textsubscript{i,t}}, is a dummy equal to 1 if a municipality \textit{i} received a confinato. It is equal to 0 pre-1970 and equal to 1 from 1970 onward. Column (1) reports the main estimates. Column (2) interacts \textit{Confino\textsubscript{i,t}} with the share of migrants arriving from the South macro-area to province \textit{p} at decade \textit{t}. Column (3) interacts \textit{Confino\textsubscript{i,t}} with the share of migrants arriving from a province in the South of Italy with a Mafia Index (MI) higher than the median \citep{calderoni2011} to province \textit{p} at decade \textit{t}." + ///
"Controls include municipality population (1930, 1950), population density (1950), elderly index (1950), illiterate index (1950), owned house index (1950), and employment rate in agriculture, industry, commerce and tertiary (1950), altitude and area, all interacted with decade dummies. We include municipality and decade fixed effects. " + ///
"Municipality clustered standard errors in parentheses. * p$<$0.10, ** p$<$0.05, *** p$<$0.01. "
local panel_A_postfoot "Mean TV tax&`mean_3'&`mean_3'&`mean_3' \\ \hline  " ///
"Controls &\checkmark&\checkmark&\checkmark\\ " ///
"Municipality and decade FE &\checkmark&\checkmark&\checkmark\\ " ///
"Region * decade FE &\checkmark&\checkmark&\checkmark\\ \hline\hline " ///
"\end{tabular} \begin{tablenotes} \item \scriptsize{`notes'} \end{tablenotes} \end{threeparttable} \end{table}"
esttab using "$tables/Table-6.tex", ///
tex compress nomtitles replace width(\hsize) b (3) se starlevels(* 0.10 ** 0.05 *** 0.01) keep(1.confino_t 1.confino_t#c.share_s_migrants 1.confino_t#c.share_mi_migrants) coeflabels(1.confino_t "\textit{Confino\textsubscript{i,t}}" 1.confino_t#c.share_s_migrants "\textit{Confino\textsubscript{i,t} * Share South Migr\textsubscript{p,t}}" 1.confino_t#c.share_mi_migrants "\textit{Confino\textsubscript{i,t} * Share South MI Migr\textsubscript{p,t}}") ///
prehead("`panel_A_prehead'") posthead("`panel_A_posthead'") prefoot("`panel_A_prefoot'") postfoot("`panel_A_postfoot'") gaps
