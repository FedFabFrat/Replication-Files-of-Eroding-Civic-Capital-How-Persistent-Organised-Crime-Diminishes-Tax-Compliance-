use "$data/final_for_analysis.dta", clear
collapse (max) popolazione_residente_1930 popolazione_residente_1950 densita_demografica_1950 inc_abitazioni_proprieta_1950 indice_vecchiaia_1950 incidenza_analfabeti_1950 tasso_occ_agric_1950 tasso_occ_industr_1950 tasso_occ_terz_1950 tasso_occ_comm_1950 altitude area confino unita_30_1950 unita_31_1950 unita_40_1950 unita_50_1950 unita_60_1950 unita_70_1950 unita_80_1950 unita_90_1950 addetti_30_1950 addetti_31_1950 addetti_40_1950 addetti_50_1950 addetti_60_1950 addetti_70_1950 addetti_80_1950 addetti_90_1950 (firstnm) idreg, by(codcom)
global matching popolazione_residente_1930 popolazione_residente_1950 densita_demografica_1950 inc_abitazioni_proprieta_1950 incidenza_analfabeti_1950 indice_vecchiaia_1950 tasso_occ_agric_1950 tasso_occ_industr_1950 tasso_occ_terz_1950 tasso_occ_comm_1950 altitude area unita_30_1950 unita_31_1950 unita_40_1950 unita_50_1950 unita_60_1950 unita_70_1950 unita_80_1950 unita_90_1950 addetti_30_1950 addetti_31_1950 addetti_40_1950 addetti_50_1950 addetti_60_1950 addetti_70_1950 addetti_80_1950 addetti_90_1950 i.idreg 
psmatch2 confino $matching, common neigh(5) 
psgraph, legend(pos(6) cols(3))
graph export "$figures\Figure-A3a.pdf", as(pdf) replace
pstest $matching if _support==1 & _weight!=.
tab _treated if _support==1 & _weight!=.
keep if _support==1 & _weight!=.
probit confino $matching
predict phat
label var confino "Forced resettlment exposure"
histogram phat, fraction by(confino) color(navy)
graph export "$figures\Figure-A3b.pdf", as(pdf) replace
