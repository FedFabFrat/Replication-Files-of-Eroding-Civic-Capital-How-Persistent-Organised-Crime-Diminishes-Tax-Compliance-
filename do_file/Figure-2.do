use "$data/final_for_analysis.dta", clear
gen region = "Piedmont" if idreg == 1
replace region = "Aosta Valley" if idreg == 2
replace region = "Lombardy" if idreg == 3
replace region = "Trentino-Alto Adige" if idreg == 4
replace region = "Veneto" if idreg == 5
replace region = "Friuli-Venezia Giulia" if idreg == 6
replace region = "Liguria" if idreg == 7
replace region = "Emilia-Romagna" if idreg == 8
replace region = "Tuscany" if idreg == 9
replace region = "Umbria" if idreg == 10
replace region = "Marche" if idreg == 11
replace region = "Lazio" if idreg == 12
collapse (mean) d100f_tv_, by(anno region)
label var d100f_tv_ "TV tax compliance rate * 100"
label var anno "Decade"
twoway connected d100f_tv_ anno, by(region) lc(navy) mc(navy) xlabel(1950(10)2000)
graph export "$figures/Figure-2.pdf", as(pdf) replace
