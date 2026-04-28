use "$data/final_for_analysis.dta", clear
gen popolazione_residente_1950_2 = popolazione_residente_1950^2 
global controls_1950_2 "popolazione_residente_1930 popolazione_residente_1950_2 popolazione_residente_1950 densita_demografica_1950 indice_vecchiaia_1950 inc_abitazioni_proprieta_1950 incidenza_analfabeti_1950 tasso_occ_agric_1950 tasso_occ_industr_1950 tasso_occ_comm_1950 tasso_occ_terz_1950 altitude area"
gen pop_cat = 1 if inrange(popolazione_residente_1950,0,1999)
replace pop_cat = 2 if inrange(popolazione_residente_1950,2000,9999)
replace pop_cat = 3 if inrange(popolazione_residente_1950,10000,99999)
replace pop_cat = 4 if popolazione_residente_1950 >= 100000
summ densita_demografica_1950, d
gen dd_cat = 1 if inrange(densita_demografica_1950,0,r(p25))
replace dd_cat = 2 if inrange(densita_demografica_1950,r(p25),r(p50))
replace dd_cat = 3 if inrange(densita_demografica_1950,r(p50),r(p75))
replace dd_cat = 4 if densita_demografica_1950 >= r(p75)
global controls_1950 "popolazione_residente_1930 popolazione_residente_1950 densita_demografica_1950 indice_vecchiaia_1950 inc_abitazioni_proprieta_1950 incidenza_analfabeti_1950 tasso_occ_agric_1950 tasso_occ_industr_1950 tasso_occ_comm_1950 tasso_occ_terz_1950 altitude area"
global controls_1950_3 "popolazione_residente_1930 densita_demografica_1950 indice_vecchiaia_1950 inc_abitazioni_proprieta_1950 incidenza_analfabeti_1950 tasso_occ_agric_1950 tasso_occ_industr_1950 tasso_occ_comm_1950 tasso_occ_terz_1950 altitude area"
global controls_1950_4 "popolazione_residente_1930 popolazione_residente_1950 indice_vecchiaia_1950 inc_abitazioni_proprieta_1950 incidenza_analfabeti_1950 tasso_occ_agric_1950 tasso_occ_industr_1950 tasso_occ_comm_1950 tasso_occ_terz_1950 altitude area"
eststo clear
qui eststo: reghdfe ihs_d100f_tv_ 1.confino_t, a(i.codcom i.anno c.($controls_1950_2)#i.anno i.idprov#i.anno) vce(cluster codcom) 
gen sam1 = 1 if e(sample) == 1
qui eststo: reghdfe ihs_d100f_tv_ 1.confino_t if popolazione_residente_1950 < 250000, a(i.codcom i.anno c.($controls_1950)#i.anno i.idprov#i.anno) vce(cluster codcom)  	     
gen sam2 = 1 if e(sample) == 1
qui eststo: reghdfe ihs_d100f_tv_ i.confino_t##i.pop_cat, a(i.codcom i.anno c.($controls_1950_3)#i.anno i.idprov#i.anno) vce(cluster codcom)  	    
qui eststo: reghdfe ihs_d100f_tv_ i.confino_t##i.dd_cat, a(i.codcom i.anno c.($controls_1950_4)#i.anno i.idprov#i.anno) vce(cluster codcom)  	    
qui summ d100f_tv_ if sam1 == 1
local mean_1: display %10.3f r(mean)
qui summ d100f_tv_ if sam2 == 1
local mean_2: display %10.3f r(mean)
local panel_A_prehead "\begin{table}[!h]\centering\begin{threeparttable}" ///
 "\caption{Forced resettlement and TV tax compliance. Population heterogeneity.\label{tab:rf-popheter}}" ///
 "\begin{tabular}{lcccc} \hline\hline"  ///
 "&\multicolumn{4}{c}{\textit{IHS(TV tax compliance rate)}} \\ \cmidrule(lr){2-5} "
local panel_A_posthead "\hline" 
local panel_A_prefoot "\hline"
local notes ="\textit{\underline{Notes}.} Dependent variable: the IHS of the ratio of the number of TV licences over the number of households * 100. " + ///
"The main variable of interest, \textit{Confino\textsubscript{i,t}}, is a dummy equal to 1 if a municipality \textit{i} received a confinato. It is equal to 0 pre-1970 and equal to 1 from 1970 onward. Column (1) additionaly controls for the quadratic of population in (1950). Column (2) excludes municipalities with baseline population (1950) higher than 250'000. In Column (3) \textit{Confino\textsubscript{i,t}} is then interacted with a categorical variable related to baseline population (1950), \textit{Pop\textsubscript{i,t}}. \textit{Pop\textsubscript{i,t}} = 1 gathers municipalities between 0 and 1'999; \textit{Pop\textsubscript{i,t}} = 2 gathers municipalities between 2'000 and 9'999; \textit{Pop\textsubscript{i,t}} = 3 gathers municipalities between 10'000 and 99'999; \textit{Pop\textsubscript{i,t}} = 4 gathers municipalities with population higher than 100'000. The reference category is \textit{Pop\textsubscript{i,t}} = 1. In Column (4) \textit{Confino\textsubscript{i,t}} is then interacted with a categorical variable related to baseline population density (1950), \textit{Pop Dens\textsubscript{i,t}}. \textit{Pop Dens\textsubscript{i,t}} = 1 gathers municipalities between 0 and the first quartile; \textit{Pop Dens\textsubscript{i,t}} = 2 gathers municipalities between the first and the second quartile; \textit{Pop Dens\textsubscript{i,t}} gathers municipalities between the second and the third quartile; \textit{Pop Dens\textsubscript{i,t}} gather municipalities with population higher than the third quartile. The reference category is \textit{Pop Dens\textsubscript{i,t}} = 1. " + ///
"Unless specified, controls include municipality population (1930) population (1950, not in column 3), population density (1950, not in column 4), elderly index (1950), illiterate index (1950), owned house index (1950), and employment rate in agriculture, industry, commerce and tertiary (1950), altitude and area, all interacted with decade dummies. Depending on the specification, we include municipality and decade fixed effects, municipality linear trends, region or province * decade fixed effects, respectively. " + ///
"Municipality clustered standard errors in parentheses. * p$<$0.10, ** p$<$0.05, *** p$<$0.01. "
local panel_A_postfoot "Mean TV tax&`mean_1'&`mean_2'&`mean_1'&`mean_1' \\ \hline  " ///
"Municipality and decade FE &\checkmark&\checkmark&\checkmark&\checkmark\\ " ///
"Prov * decade FE &\checkmark&\checkmark&\checkmark&\checkmark\\ " ///
"Baseline controls &\checkmark&\checkmark&\checkmark&\checkmark\\ " ///
"Quadratic baselin Pop. &\checkmark&&&\\ " ///
"No muni. > 250k &&\checkmark&&\\ " ///
"\textit{Pop} int. &&&\checkmark&\\ " ///
"\textit{Pop Dens} int. &&&&\checkmark\\ \hline\hline " ///
"\end{tabular} \begin{tablenotes} \item \scriptsize{`notes'} \end{tablenotes} \end{threeparttable} \end{table}"
esttab using "$tables/Table-A4.tex", ///
tex compress nomtitles replace width(\hsize) b (3) se starlevels(* 0.10 ** 0.05 *** 0.01) keep(1.confino_t 1.confino_t#2.pop_cat 1.confino_t#3.pop_cat 1.confino_t#4.pop_cat 1.confino_t#2.dd_cat 1.confino_t#3.dd_cat 1.confino_t#4.dd_cat) coeflabels(1.confino_t "\textit{Confino\textsubscript{i,t}}" 1.confino_t#2.pop_cat "\textit{Confino\textsubscript{i,t} * Pop\textsubscript{i,t} = 2}" 1.confino_t#3.pop_cat "\textit{Confino\textsubscript{i,t} * Pop\textsubscript{i,t} = 3}" 1.confino_t#4.pop_cat "\textit{Confino\textsubscript{i,t} * Pop\textsubscript{i,t} = 4}" 1.confino_t#2.dd_cat "\textit{Confino\textsubscript{i,t} * Pop Dens\textsubscript{i,t} = 2}" 1.confino_t#3.dd_cat "\textit{Confino\textsubscript{i,t} * Pop Dens\textsubscript{i,t} = 3}" 1.confino_t#4.dd_cat "\textit{Confino\textsubscript{i,t} * Pop Dens\textsubscript{i,t} = 4}") ///
prehead("`panel_A_prehead'") posthead("`panel_A_posthead'") prefoot("`panel_A_prefoot'") postfoot("`panel_A_postfoot'") gaps
