use "$data/final_for_analysis.dta", clear
keep codcom n_news_ popolazione_residente_1930 popolazione_residente_1950 densita_demografica_1950 indice_vecchiaia_1950 ampiezza_media_famiglie_1950 inc_abitazioni_proprieta_1950 diff_genere_istr_sup_1950 incidenza_analfabeti_1950 part_mercato_lavoro_1950 tasso_occ_agric_1950 tasso_occ_industr_1950 tasso_occ_comm_1950 tasso_occ_terz_1950 altitude area confino idreg
collapse (mean) n_news_ popolazione_residente_1930 popolazione_residente_1950 densita_demografica_1950 indice_vecchiaia_1950 ampiezza_media_famiglie_1950 inc_abitazioni_proprieta_1950 diff_genere_istr_sup_1950 incidenza_analfabeti_1950 part_mercato_lavoro_1950 tasso_occ_agric_1950 tasso_occ_industr_1950 tasso_occ_comm_1950 tasso_occ_terz_1950 altitude area confino (firstnm) idreg, by(codcom)
label var popolazione_residente_1930 "Population (1930)"
label var popolazione_residente_1950 "Population (1950)"
label var densita_demografica_1950 "Pop. density (1950)"
label var indice_vecchiaia_1950 "Elderly index (1950)"
label var ampiezza_media_famiglie_1950 "Avg. household size (1950)"
label var inc_abitazioni_proprieta_1950 "Owned house index (1950)"
label var diff_genere_istr_sup_1950 "Educ. gender gap (1950)"
label var incidenza_analfabeti_1950 "Illiterate index (1950)"
label var part_mercato_lavoro_1950 "LF participation rate (1950)"
label var tasso_occ_agric_1950 "Share emp. agric. (1950)"
label var tasso_occ_industr_1950 "Share emp. industr. (1950)"
label var tasso_occ_comm_1950 "Share emp. comm. (1950)"
label var tasso_occ_terz_1950 "Share emp. terz. (1950)"
label var altitude "Altitude"
label var area "Area"
gen ihs_n_news_5000 = log(n_news_+(n_news_^2 + 1)^0.5)
label var ihs_n_news_5000 "IHS Mafia news (avg.50s/00s)"		
local prehead	"\begin{table}\centering\begin{threeparttable}" ///
				"\caption{Balance table by forced resettlement law.\label{tab:bal-confino}}" ///
				"\begin{tabular}{lccc} \hline\hline"
local notes =	"\textit{\underline{Notes}.} The table assesses the balancedness of forced resettlement exposure along a set of pre-instrument characteristics. * p$<$0.10, ** p$<$0.05, *** p$<$0.01."
local postfoot 	"\hline\hline \end{tabular} \begin{tablenotes} \item \scriptsize{`notes'} \end{tablenotes} \end{threeparttable} \end{table}"		
balancetable 	(mean if confino == 0) (mean if confino == 1) (diff confino) ///
				popolazione_residente_1930 popolazione_residente_1950 densita_demografica_1950 indice_vecchiaia_1950 ampiezza_media_famiglie_1950 inc_abitazioni_proprieta_1950 diff_genere_istr_sup_1950 incidenza_analfabeti_1950 part_mercato_lavoro_1950 tasso_occ_agric_1950 tasso_occ_industr_1950 tasso_occ_comm_1950 tasso_occ_terz_1950 altitude area ihs_n_news_5000 ///
				using "$tables/Table-A2.tex", ///
				replace starlevels(* 0.10 ** 0.05 *** 0.01) ///
				mean(nopar fmt(%10.3f)) diff(fmt(%10.4f)) sd(par() fmt(%10.4f)) se(par() fmt(%10.4f)) obs(nopar fmt(%6.0g)) ///
				nonumbers ctitles("Not-FR" "FR" "Diff. (FR-NFR)") varlabels ///
				prehead("`prehead'") postfoot("`postfoot'")


