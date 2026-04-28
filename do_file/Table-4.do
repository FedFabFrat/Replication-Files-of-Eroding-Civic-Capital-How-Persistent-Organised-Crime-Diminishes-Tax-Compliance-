use "$data/final_for_analysis.dta", clear
global controls_1950 "popolazione_residente_1930 popolazione_residente_1950 densita_demografica_1950 indice_vecchiaia_1950 inc_abitazioni_proprieta_1950 incidenza_analfabeti_1950 tasso_occ_agric_1950 tasso_occ_industr_1950 tasso_occ_comm_1950 tasso_occ_terz_1950 altitude area"
eststo clear
qui eststo: reghdfe nfirms_ confino_t, a(i.codcom i.anno c.($controls_1950)#i.anno i.idprov#i.anno) vce(cluster codcom) 
gen sam1 = e(sample)
qui eststo: reghdfe nfirms_mining confino_t, a(i.codcom i.anno c.($controls_1950)#i.anno i.idprov#i.anno) vce(cluster codcom)  	     
gen sam2 = e(sample)
qui eststo: reghdfe nfirms_manuf confino_t, a(i.codcom i.anno c.($controls_1950)#i.anno i.idprov#i.anno) vce(cluster codcom)  	     
gen sam3 = e(sample)
qui eststo: reghdfe nfirms_energy confino_t, a(i.codcom i.anno c.($controls_1950)#i.anno i.idprov#i.anno) vce(cluster codcom)  	     
gen sam4 = e(sample)
qui eststo: reghdfe nfirms_constr confino_t, a(i.codcom i.anno c.($controls_1950)#i.anno i.idprov#i.anno) vce(cluster codcom)  	     
gen sam5 = e(sample)
qui eststo: reghdfe nfirms_services confino_t, a(i.codcom i.anno c.($controls_1950)#i.anno i.idprov#i.anno) vce(cluster codcom)  	     
qui eststo: reghdfe ihs_sh100_estor confino_t, a(i.codcom i.anno c.($controls_1950)#i.anno i.idprov#i.anno) vce(cluster codcom)  
gen sam6 = e(sample) 	    
qui eststo: reghdfe ihs_sh100_labor confino_t, a(i.codcom i.anno c.($controls_1950)#i.anno i.idprov#i.anno) vce(cluster codcom)  	    
qui summ nfirms_ if sam1 == 1
local mean_1: display %10.3f r(mean)
qui summ nfirms_mining if sam2 == 1
local mean_2: display %10.3f r(mean)
qui summ nfirms_manuf if sam3 == 1
local mean_3: display %10.3f r(mean)
qui summ nfirms_energy if sam4 == 1
local mean_4: display %10.3f r(mean)
qui summ nfirms_constr if sam5 == 1
local mean_5: display %10.3f r(mean)
qui summ nfirms_services if sam1 == 1
local mean_6: display %10.3f r(mean)
qui summ sh100_estor if sam6 == 1
local mean_7: display %10.3f r(mean)
qui summ sh100_labor if sam6 == 1
local mean_8: display %10.3f r(mean)
local panel_A_prehead "\begin{table}[!h]\centering\begin{threeparttable}\small" ///
 "\caption{Forced resettlement, economic development and criminal activity.\label{tab:mech-econ-allsect}}" ///
 "\begin{tabular}{lcccccccc} \hline\hline"  ///
 "&\multicolumn{1}{c}{\textit{N firms}} &\multicolumn{1}{c}{\textit{\shortstack{N firms \\mining}}}&\multicolumn{1}{c}{\textit{\shortstack{N firms \\ manuf.}}} &\multicolumn{1}{c}{\textit{\shortstack{N firms \\ energy}}} &\multicolumn{1}{c}{\textit{\shortstack{N firms \\ constr.}}} &\multicolumn{1}{c}{\textit{\shortstack{N firms \\ services}}}&\multicolumn{1}{c}{\textit{\shortstack{IHS(share\\ news\\extorsion)}}}&\multicolumn{1}{c}{\textit{\shortstack{IHS(share\\ news labor \\racket)}}} \\ \cmidrule(lr){2-2} \cmidrule(lr){3-3} \cmidrule(lr){4-4} \cmidrule(lr){5-5} \cmidrule(lr){6-6} \cmidrule(lr){7-7} \cmidrule(lr){8-8} \cmidrule(lr){9-9} "
local panel_A_posthead "\hline" 
local panel_A_prefoot "\hline"
local notes ="\textit{\underline{Notes}.} Dependent variables: the number of firms; the number of firms in mining; the number of firms in manufacturing; the number of firms in energy; the number of firms in construction; the number of firms in services; the IHS of the share of news related to extorsion; the IHS of the share of news related to labour racketeering. " + ///
"The main variable of interest, \textit{Confino\textsubscript{i,t}}, is a dummy equal to 1 if a municipality \textit{i} received a confinato. It is equal to 0 pre-1970 and equal to 1 from 1970 onward. " + ///
"Controls include municipality population (1930, 1950), population density (1950), elderly index (1950), illiterate index (1950), owned house index (1950), and employment rate in agriculture, industry, commerce and tertiary (1950), altitude and area, all interacted with decade dummies. We include municipality and decade fixed effect. " + ///
"Municipality clustered standard errors in parentheses. * p$<$0.10, ** p$<$0.05, *** p$<$0.01. "
local panel_A_postfoot "Mean Y&`mean_1'&`mean_2'&`mean_3'&`mean_4'&`mean_5'&`mean_6'&`mean_7'&`mean_8' \\ \hline  " ///
"Controls &\checkmark&\checkmark&\checkmark&\checkmark&\checkmark&\checkmark&\checkmark&\checkmark\\ " ///
"Municipality &&&&&&&&\\ " ///
"and decade FE &\checkmark&\checkmark&\checkmark&\checkmark&\checkmark&\checkmark&\checkmark&\checkmark\\ " ///
"Prov * &&&&&&&&\\ " ///
"decade FE &\checkmark&\checkmark&\checkmark&\checkmark&\checkmark&\checkmark&\checkmark&\checkmark\\ \hline\hline " ///
"\end{tabular} \begin{tablenotes} \item \scriptsize{`notes'} \end{tablenotes} \end{threeparttable} \end{table}"
esttab using "$tables/Table-4.tex", ///
tex compress nomtitles replace width(\hsize) b (3) se starlevels(* 0.10 ** 0.05 *** 0.01) keep(confino_t) coeflabels(confino_t "\textit{Confino\textsubscript{i,t}}") ///
prehead("`panel_A_prehead'") posthead("`panel_A_posthead'") prefoot("`panel_A_prefoot'") postfoot("`panel_A_postfoot'") gaps
