use "$data/final_for_analysis.dta", clear
global controls_1950 "popolazione_residente_1930 popolazione_residente_1950 densita_demografica_1950 indice_vecchiaia_1950 inc_abitazioni_proprieta_1950 incidenza_analfabeti_1950 tasso_occ_agric_1950 tasso_occ_industr_1950 tasso_occ_terz_1950 altitude area"
keep ihs_d100f_tv_ ihs_n_news_ confino_t codcom anno $controls_1950 
ivreghdfe ihs_d100f_tv_ (ihs_n_news_ = confino_t), a(i.codcom i.anno c.($controls_1950)#i.anno) vce(cluster codcom) 
xi i.anno
glevelsof codcom, local(coms)
foreach x of local coms {
	gen _codcom_`x' = 1 if codcom == `x'
	recode _codcom_`x' .=0
}
tf ihs_d100f_tv_ c.($controls_1950)#i.(_Ianno_*) _Ianno_* _codcom_* (ihs_n_news_ = confino_t)
scalar tF_critical_value_01 = e(tF_critical_value_01)
scalar tF_UB_01 = e(tF_UB_01)
scalar tF_LB_01 = e(tF_LB_01)
scalar tF_se_beta_hat_01 = e(tF_se_beta_hat_01)
scalar tF_critical_value_05 = e(tF_critical_value_05)
scalar tF_se_beta_hat_05 = e(tF_se_beta_hat_05)
scalar tF_UB_05 = e(tF_UB_05)
scalar tF_LB_05 = e(tF_LB_05)
scalar unadj_UB = e(unadj_UB)
scalar unadj_LB = e(unadj_LB)
scalar unadj_se = e(unadj_se)
scalar beta_hat = e(beta_hat)
scalar F = e(F)
matrix M = J(7, 2, .)
matrix M[1,1] = `=beta_hat'
matrix M[2,1] = `=unadj_se'
matrix M[3,1] = `=tF_critical_value_05'
matrix M[4,1] = `=tF_se_beta_hat_05'
matrix M[5,1] = `=tF_LB_05'
matrix M[6,1] = `=tF_UB_05'
matrix M[7,1] = `=F'
matrix M[1,2] = `=beta_hat'
matrix M[2,2] = `=unadj_se'
matrix M[3,2] = `=tF_critical_value_01'
matrix M[4,2] = `=tF_se_beta_hat_01'
matrix M[5,2] = `=tF_LB_01'
matrix M[6,2] = `=tF_UB_01'
matrix M[7,2] = `=F'
matrix rownames M = ///
    "Coefficient" "Std. Err." "Crit. Val." "Adj. Std. Err." ///
    "Lower Bound" "Upper Bound" "First-stage F-stat"
matrix colnames M = alpha05 alpha01
matrix list M, format(%9.3f)
local panel_A_prehead "\begin{table}[!h]\centering\begin{threeparttable}" ///
 "\caption{\citet{lee2022valid} valid t-ratio inference}\label{tab:lee}" ///
 "\begin{tabular}{lcc} \hline\hline"  
local panel_A_posthead "& \multicolumn{1}{c}{5\% Level} & \multicolumn{1}{c}{1\% Level} \\ \hline " 
local panel_A_prefoot "%% " 
local notes ="\item \textit{\underline{Notes}:} This table applies the methodology from \citet{lee2022valid} to estimate valid t-ratio inference for instrumental variables. The estimates the command works on is column (1) of Panel B of \autoref{tab:mainres-2sls-app}."
local panel_A_postfoot " \hline\hline " ///
"\end{tabular} \begin{tablenotes} \scriptsize{`notes'} \end{tablenotes} \end{threeparttable} \end{table}"
esttab matrix(M, fmt(%9.3f)) using "$tables/Table-A9.tex", /// 
tex replace compress nomtitles collabels(none) ///
prehead("`panel_A_prehead'") posthead("`panel_A_posthead'") prefoot(`panel_A_prefoot') postfoot(`panel_A_postfoot') gaps
