use "$data/final_for_analysis.dta", clear
global controls_1950 "popolazione_residente_1930 popolazione_residente_1950 densita_demografica_1950 indice_vecchiaia_1950 inc_abitazioni_proprieta_1950 incidenza_analfabeti_1950 tasso_occ_agric_1950 tasso_occ_industr_1950 tasso_occ_comm_1950 tasso_occ_terz_1950 altitude area"
eststo clear
summ indice_vecchiaia_1950, d 
gen idvec_p50 = 1 if indice_vecchiaia_1950 < r(p50) & indice_vecchiaia_1950 != .
recode idvec_p50 .=0
qui eststo id_vec: reghdfe ihs_d100f_tv_ i.confino_t##i.idvec_p50, a(i.codcom i.anno c.(popolazione_residente_1930 popolazione_residente_1950 densita_demografica_1950 inc_abitazioni_proprieta_1950 incidenza_analfabeti_1950 tasso_occ_agric_1950 tasso_occ_industr_1950 tasso_occ_comm_1950 tasso_occ_terz_1950 altitude area)#i.anno i.idprov#i.anno) vce(cluster codcom)  	    
gen sam1 = 1 if e(sample) == 1
summ inc_abitazioni_proprieta_1950 , d 
gen incab_p50 = 1 if inc_abitazioni_proprieta_1950  < r(p50) & inc_abitazioni_proprieta_1950  != .
recode incab_p50 .=0
qui eststo inc_ab: reghdfe ihs_d100f_tv_ i.confino_t##i.incab_p50, a(i.codcom i.anno c.(popolazione_residente_1930 popolazione_residente_1950 densita_demografica_1950 indice_vecchiaia_1950 incidenza_analfabeti_1950 tasso_occ_agric_1950 tasso_occ_industr_1950 tasso_occ_comm_1950 tasso_occ_terz_1950 altitude area)#i.anno i.idprov#i.anno) vce(cluster codcom)  	    
summ incidenza_analfabeti_1950, d 
gen incanalf_p50 = 1 if incidenza_analfabeti_1950  < r(p50) & incidenza_analfabeti_1950  != .
recode incanalf_p50 .=0
qui eststo analf: reghdfe ihs_d100f_tv_ i.confino_t##i.incanalf_p50, a(i.codcom i.anno c.(popolazione_residente_1930 popolazione_residente_1950 densita_demografica_1950 indice_vecchiaia_1950 inc_abitazioni_proprieta_1950 tasso_occ_agric_1950 tasso_occ_industr_1950 tasso_occ_comm_1950 tasso_occ_terz_1950 altitude area)#i.anno i.idprov#i.anno) vce(cluster codcom)  	    
merge m:1 idprov using "$data\ads_main_1980.dta", gen(ads)
drop if ads==2
drop ads
gen popolazione_1980 = popolazione_residente if anno == 1980
while missing(popolazione_1980) {
    bysort codcom: replace popolazione_1980 = popolazione_1980[_n-1] if missing(popolazione_1980)
    bysort codcom: replace popolazione_1980 = popolazione_1980[_n+1] if missing(popolazione_1980)
}
egen tag_prov_comune = tag(codcom idprov)
bys idprov: egen popolazione_totale_provincia = total(cond(tag_prov_comune, popolazione_1980, .))
egen tag_reg_prov = tag(idprov idreg)
gen copie_per_capita_prov=(NCopie/popolazione_totale_provincia)*100
summ copie_per_capita_prov, d
gen read_p50 = .
levelsof idreg, local(regions)
foreach region of local regions {
    summarize copie_per_capita_prov if idreg == `region', detail  
	replace read_p50 = 1 if copie_per_capita_prov < r(p50) & idreg == `region'
	replace read_p50 = 0 if missing(read_p50) & idreg == `region'
}
qui eststo read: reghdfe ihs_d100f_tv_ i.confino_t##i.read_p50, a(i.codcom i.anno c.($controls_1950)#i.anno i.idreg#i.anno) vce(cluster codcom)  	    
qui summ d100f_tv_ if sam1 == 1
local mean_1: display %10.3f r(mean)
local panel_A_prehead "\begin{table}[!h]\centering\begin{threeparttable}" ///
 "\caption{Forced resettlement, municipality characteristics and provincial readership. \label{tab:mech-muni-read}}" ///
 "\begin{tabular}{lcccc} \hline\hline"  ///
 "&\multicolumn{4}{c}{\textit{IHS(TV tax compliance rate)}} \\ \cmidrule(lr){2-5} "
local panel_A_posthead "\hline" 
local panel_A_prefoot "\hline"
local notes ="\textit{\underline{Notes}.} Dependent variable: the IHS of the ratio of the number of TV licences over the number of households * 100. " + ///
"The main variable of interest, \textit{Confino\textsubscript{i,t}}, is a dummy equal to 1 if a municipality \textit{i} received a confinato. It is equal to 0 pre-1970 and equal to 1 from 1970 onward. It is then interacted with a series of dummy variables equal to one if a municipality has a value of that variable lower than the median in the 1950. The variables are elderly index (1950, column 1), illiterate index (1950, column 2), owned house index (1950, column 3) and the number of newspapers sold per capita in the province (1980, column 4). For this last variable, we use the regional median rather than the median of the whole sample. " + ///
"Controls include municipality population (1930, 1950), population density (1950), elderly index (1950), illiterate index (1950), owned house index (1950), and employment rate in agriculture, industry, commerce and tertiary (1950), altitude and area, all interacted with decade dummies. When analysing the interaction with elderly index (1950), illiterate index (1950) or owned house index (1950), we remove the variable from the list of controls. Depending on the specification, we include municipality and decade fixed effects and either region or province * decade fixed effects, respectively. " + ///
"Municipality clustered standard errors in parentheses. * p$<$0.10, ** p$<$0.05, *** p$<$0.01. "
local panel_A_postfoot "Mean TV tax&`mean_1'&`mean_1'&`mean_1'&`mean_1' \\ \hline  " ///
"Controls &\checkmark&\checkmark&\checkmark&\checkmark\\ " ///
"Municipality and decade FE &\checkmark&\checkmark&\checkmark&\checkmark\\ " ///
"Region * decade FE &&&&\checkmark\\ " ///
"Province * decade FE &\checkmark&\checkmark&\checkmark&\\ \hline\hline " ///
"\end{tabular} \begin{tablenotes} \item \scriptsize{`notes'} \end{tablenotes} \end{threeparttable} \end{table}"
esttab using "$tables/Table-5.tex", ///
tex compress nomtitles replace width(\hsize) b (3) se starlevels(* 0.10 ** 0.05 *** 0.01) keep(1.confino_t 1.confino_t#1.idvec_p50 1.confino_t#1.incab_p50 1.confino_t#1.incanalf_p50 1.confino_t#1.read_p50) coeflabels(1.confino_t "\textit{Confino\textsubscript{i,t}}" 1.confino_t#1.idvec_p50 "\textit{Confino\textsubscript{i,t} * Eld. Ind. < med.\textsubscript{i,t0}}" 1.confino_t#1.incab_p50 "\textit{Confino\textsubscript{i,t} * Own house. Ind. < med.\textsubscript{i,t0}}" 1.confino_t#1.incanalf_p50 "\textit{Confino\textsubscript{i,t} * Ill. Ind. < med.\textsubscript{i,t0}}" 1.confino_t#1.read_p50 "\textit{Confino\textsubscript{i,t} * Newspapers per cap < med.\textsubscript{p,t0}}") ///
prehead("`panel_A_prehead'") posthead("`panel_A_posthead'") prefoot("`panel_A_prefoot'") postfoot("`panel_A_postfoot'") gaps






