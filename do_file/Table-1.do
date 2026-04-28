use "$data/final_for_analysis.dta", clear
global controls_1950 "popolazione_residente_1930 popolazione_residente_1950 densita_demografica_1950 indice_vecchiaia_1950 inc_abitazioni_proprieta_1950 incidenza_analfabeti_1950 tasso_occ_agric_1950 tasso_occ_industr_1950 tasso_occ_comm_1950 tasso_occ_terz_1950 altitude area"
qui reghdfe ihs_d100f_tv_ confino_t, a(i.codcom i.anno c.($controls_1950)#i.anno) vce(cluster codcom) 
cap qui gen sample = 1 if e(sample) == 1
label var ihs_n_news_ "IHS of Mafia news"
label var confino "Confino"
label var d100f_tv_ "TV tax compliance"
label var share_s_migrants "Share migrants from South"
label var share_mi_migrants "Share migrants from South (MI)"
label var popolazione_residente "Population"
label var densita_demografica "Pop. density"
label var indice_vecchiaia "Elderly index"
label var ampiezza_media_famiglie "Avg. household size"
label var inc_abitazioni_proprieta "Owned house index"
label var diff_genere_istr_sup "Educ. gender gap"
label var incidenza_analfabeti "Illiterate index"
label var part_mercato_lavoro "LF participation rate"
label var tasso_occ_agric "Share emp. agric."
label var tasso_occ_industr "Share emp. industr."
label var tasso_occ_comm "Share emp. comm."
label var tasso_occ_terz "Share emp. terz."
label var nfirms_ "N. of firms"
label var nfirms_mining "N. of firms in mining"
label var nfirms_manuf "N. of firms in manuf."
label var nfirms_energy "N. of firms in energy"
label var nfirms_constr "N. of firms in constr."
label var nfirms_services "N. of firms in services"
local prehead1 	"\begin{table}\centering\begin{threeparttable}" ///
				"\caption{Descriptive statistics of main variables.}\label{tab:ds}" ///
				"\begin{tabular}{lccccc} \hline \hline" ///
				"& N  & Mean & SD  & Min  & Max  \\  \hline "
local prehead2 	"%"
local prehead3 	"%"
local prehead4 	"%"
local prehead5 	"%"
local posthead1	"\textit{\underline{Organised crime presence}}& & & & & \\"
local posthead2	"\textit{\underline{TV tax compliance}}& & & & & \\"
local posthead3	"\textit{\underline{Migration}}& & & & & \\"
local posthead4	"\textit{\underline{Municipality demographics}}& & & & & \\"
local posthead5	"\textit{\underline{Municipality econ. characteristics}}& & & & & \\"
local prefoot1 	"& & & & & \\"
local prefoot2 	"& & & & & \\"
local prefoot3 	"& & & & & \\"
local prefoot4 	"& & & & & \\"
local prefoot5 	"\hline"
local notes =	"\textit{\underline{Notes}.} This table shows the descriptive statistics of the main variables at our disposal in the analysis. 'MI' stands for Mafia Index and refers to migrants from a region in the South with a MI higher than the median \citep{calderoni2011}. 'LF' stands for labour force."
local postfoot1 "%"
local postfoot2 "%"
local postfoot3 "%"
local postfoot4 "%"
local postfoot5 "\end{tabular} \begin{tablenotes} \item \scriptsize{`notes'} \end{tablenotes} \end{threeparttable} \end{table}"	
eststo clear
estpost summarize ihs_n_news_ confino if sample == 1
esttab using "$tables/Table-1.tex", /// 
tex label compress nomtitles nodepvars nonumbers mlabels(,none) collabels(,none) replace cells("count(fmt(a2)) mean sd min max") noobs ///
prehead("`prehead1'") posthead("`posthead1'") prefoot("`prefoot1'") postfoot("`postfoot1'")
eststo clear
estpost summarize d100f_tv_ if sample == 1
esttab using "$tables/Table-1.tex", /// 
tex label compress nomtitles nodepvars nonumbers mlabels(,none) collabels(,none) append cells("count(fmt(a2)) mean sd min max") noobs ///
prehead("`prehead2'") posthead("`posthead2'") prefoot("`prefoot2'") postfoot("`postfoot2'")
eststo clear
estpost summarize share_s_migrants share_mi_migrants if sample == 1
esttab using "$tables/Table-1.tex", /// 
tex label compress nomtitles nodepvars nonumbers mlabels(,none) collabels(,none) append cells("count(fmt(a2)) mean sd min max") noobs ///
prehead("`prehead3'") posthead("`posthead3'") prefoot("`prefoot3'") postfoot("`postfoot3'")
eststo clear
estpost summarize popolazione_residente densita_demografica indice_vecchiaia ampiezza_media_famiglie inc_abitazioni_proprieta diff_genere_istr_sup incidenza_analfabeti  if sample == 1
esttab using "$tables/Table-1.tex", /// 
tex label compress nomtitles nodepvars nonumbers mlabels(,none) collabels(,none) append cells("count(fmt(a2)) mean sd min max") noobs ///
prehead("`prehead4'") posthead("`posthead4'") prefoot("`prefoot4'") postfoot("`postfoot4'")
eststo clear
estpost summarize part_mercato_lavoro tasso_occ_agric tasso_occ_industr tasso_occ_terz tasso_occ_comm nfirms_ nfirms_mining nfirms_manuf nfirms_energy nfirms_constr nfirms_services if sample == 1
esttab using "$tables/Table-1.tex", /// 
tex label compress nomtitles nodepvars nonumbers mlabels(,none) collabels(,none) append cells("count(fmt(a2)) mean sd min max") noobs ///
prehead("`prehead5'") posthead("`posthead5'") prefoot("`prefoot5'") postfoot("`postfoot5'")
