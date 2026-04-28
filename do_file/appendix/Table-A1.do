use "$data/final_for_analysis.dta", clear
keep codcom anno n_news_ popolazione_residente_1930 popolazione_residente_1950 densita_demografica_1950 indice_vecchiaia_1950 inc_abitazioni_proprieta_1950 incidenza_analfabeti_1950 tasso_occ_agric_1950 tasso_occ_industr_1950 tasso_occ_comm_1950 tasso_occ_terz_1950 altitude area confino sll2001 confisc_dum firms_confisc_dum reales_confisc_dum
bys codcom (anno): egen n_news_5090 = mean(n_news_) if inrange(anno,1950,1990)
bys codcom (anno): egen n_news_5000 = mean(n_news_)
bys codcom (anno): egen n_news_8000 = mean(n_news_) if inrange(anno,1980,2000)
collapse (mean) n_news_5090 n_news_5000 n_news_8000 popolazione_residente_1930 popolazione_residente_1950 densita_demografica_1950 indice_vecchiaia_1950 inc_abitazioni_proprieta_1950 incidenza_analfabeti_1950 tasso_occ_agric_1950 tasso_occ_industr_1950 tasso_occ_comm_1950 tasso_occ_terz_1950 altitude area confino confisc_dum firms_confisc_dum reales_confisc_dum (firstnm) sll2001, by(codcom)
gen ihs_n_news_5090 = log(n_news_5090+(n_news_5090^2 + 1)^0.5)
gen ihs_n_news_5000 = log(n_news_5000+(n_news_5000^2 + 1)^0.5)
gen ihs_n_news_8000 = log(n_news_8000+(n_news_8000^2 + 1)^0.5)
global controls_1950 "popolazione_residente_1930 popolazione_residente_1950 densita_demografica_1950 indice_vecchiaia_1950 inc_abitazioni_proprieta_1950 incidenza_analfabeti_1950 tasso_occ_agric_1950 tasso_occ_industr_1950 tasso_occ_comm_1950 tasso_occ_terz_1950 altitude area"
qui summ confisc_dum
local mean_1: display %10.3f r(mean)
qui summ firms_confisc_dum
local mean_2: display %10.3f r(mean)
qui summ reales_confisc_dum
local mean_3: display %10.3f r(mean)
local panelA1_prehead "\begin{table}[!h]\centering\small\begin{threeparttable}" ///
 "\caption{Correlation between mafia news indicator and confiscations dummies.\label{tab:treatment-takeup}}" ///
 "\begin{tabular}{lcccccc} \hline\hline" ///
"&\multicolumn{2}{c}{\textit{\shortstack{Confisc.\\Overall\textsubscript{i,1980-2020}}}}&\multicolumn{2}{c}{\textit{\shortstack{Confisc.\\Firms\textsubscript{i,1980-2020}}}}&\multicolumn{2}{c}{\textit{\shortstack{Confisc.\\Real Estate\textsubscript{i,1980-2020}}}} \\" 
local panelA2_prehead "%%%"
local panelA3_prehead "%%%"
local panelA1_posthead "\hline  \\ &\multicolumn{6}{c}{\textit{Different periods}}\\ \cmidrule(lr){2-7} " 
local panelA2_posthead "\hline  \\ &\multicolumn{6}{c}{\textit{Overlapping periods, with Mafia from 1950s}}\\ \cmidrule(lr){2-7} " 
local panelA3_posthead "\hline  \\ &\multicolumn{6}{c}{\textit{Overlapping periods, with Mafia from 1980s}}\\ \cmidrule(lr){2-7} " 
local panel_B1_prefoot "\hline"
local panel_B2_prefoot "\hline"
local panel_B3_prefoot "\hline"
local notes ="\textit{Notes:} Dependent variables: a dummy equal to one if a municipality ever experienced a confiscation; a dummy equal to one if a firm registered in a municipality has ever been confiscated; a dummy equal to one if a real estate in a municipality has ever been confiscated. " + ///
"The endogenous variable, \textit{Mafia\textsubscript{i,t}}, refers to the log of the number of news related to the mafia in city \textit{i}. We average it over three different periods: between 1950s and 1990s; between 1950s and 2010s; between 1980s and 2000s." + ///
"Controls include city population (1936, 1950), population density (1950), illiterate index (1950), owned house index (1950), and employment rate in agriculture, industry, commerce and tertiary (1950), altitude and area. All columns include local labor markets areas fixed effects. " + ///
"Robust standard errors in parentheses. * p$<$0.10, ** p$<$0.05, *** p$<$0.01. "
local panel_B1_postfoot "Mean outcome&`mean_1'&`mean_1'&`mean_2'&`mean_2'&`mean_3'&`mean_3'\\ "
local panel_B2_postfoot "Mean outcome&`mean_1'&`mean_1'&`mean_2'&`mean_2'&`mean_3'&`mean_3'\\ "
local panel_B3_postfoot "Mean outcome&`mean_1'&`mean_1'&`mean_2'&`mean_2'&`mean_3'&`mean_3'\\ \hline " ///
"SLL FE &\checkmark&\checkmark&\checkmark&\checkmark&\checkmark&\checkmark\\ " ///
"Controls &&\checkmark&&\checkmark&&\checkmark\\ \hline\hline " ///
"\end{tabular} \begin{tablenotes} \item \scriptsize{`notes'} \end{tablenotes} \end{threeparttable} \end{table}"
eststo clear
foreach y of varlist confisc_dum firms_confisc_dum reales_confisc_dum {
	qui eststo: reg `y' ihs_n_news_5090 i.sll2001, vce(robust) 
	qui eststo: reg `y' ihs_n_news_5090 $controls_1950 i.sll2001, vce(robust)
}
esttab using "$tables/Table-A1.tex", tex nomtitles replace width(\hsize) b (3) se starlevels(* 0.10 ** 0.05 *** 0.01) keep(ihs_n_news_5090) coeflabels(ihs_n_news_5090 "\textit{Mafia\textsubscript{i,1950-1990}}") prehead("`panelA1_prehead'") posthead("`panelA1_posthead'") prefoot(`panel_B1_prefoot') postfoot(`panel_B1_postfoot')
eststo clear
foreach y of varlist confisc_dum firms_confisc_dum reales_confisc_dum {
	qui eststo: reg `y' ihs_n_news_5000 i.sll2001, vce(robust) 
	qui eststo: reg `y' ihs_n_news_5000 $controls_1950 i.sll2001, vce(robust)
}
esttab using "$tables/Table-A1.tex", tex nomtitles nonumbers append width(\hsize) b (3) se starlevels(* 0.10 ** 0.05 *** 0.01) keep(ihs_n_news_5000) coeflabels(ihs_n_news_5000 "\textit{Mafia\textsubscript{i,1950-2000}}") prehead("`panelA2_prehead'") posthead("`panelA2_posthead'") prefoot(`panel_B2_prefoot') postfoot(`panel_B2_postfoot')
eststo clear
foreach y of varlist confisc_dum firms_confisc_dum reales_confisc_dum {
	qui eststo: reg `y' ihs_n_news_8000 i.sll2001, vce(robust) 
	qui eststo: reg `y' ihs_n_news_8000 $controls_1950 i.sll2001, vce(robust)
}
esttab using "$tables/Table-A1.tex", tex nomtitles nonumbers append width(\hsize) b (3) se starlevels(* 0.10 ** 0.05 *** 0.01) keep(ihs_n_news_8000) coeflabels(ihs_n_news_8000 "\textit{Mafia\textsubscript{i,1980-2000}}") prehead("`panelA3_prehead'") posthead("`panelA3_posthead'") prefoot(`panel_B3_prefoot') postfoot(`panel_B3_postfoot')
