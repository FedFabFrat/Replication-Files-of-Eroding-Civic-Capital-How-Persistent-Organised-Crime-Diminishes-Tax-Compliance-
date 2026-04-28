use "$data/final_for_analysis.dta", clear
global controls_1950 "popolazione_residente_1930 popolazione_residente_1950 densita_demografica_1950 indice_vecchiaia_1950 inc_abitazioni_proprieta_1950 incidenza_analfabeti_1950 tasso_occ_agric_1950 tasso_occ_industr_1950 tasso_occ_comm_1950 tasso_occ_terz_1950 altitude area"
* declare panel data *
xtset codcom anno, del(10)

set seed 2024 
local N = 1000 // Numero di iterazioni

// Crea un file temporaneo per salvare i risultati
tempfile results
postfile handle beta p_value using `results', replace

egen total_comuni = tag(codcom)
count if total_comuni == 1
local num_clusters = r(N)

local sample_size = round(0.5 * `num_clusters')

// Ciclo per stimare 2SLS N volte
forval i = 1/`N' {
    preserve
    // Estrai un campione casuale (con replacement)
    *bsample
	*bsample `=round(0.5 * `total_obs')'
	bsample `sample_size', cluster(codcom)

	*ivreghdfe ihs_d100f_tv_ (ihs_n_news_ = confino_t), a(i.codcom i.anno c.($controls_1950)#i.anno i.idprov#i.anno) vce(cluster codcom)
    // Stima il modello 2SLS
    capture ivreghdfe ihs_d100f_tv_ (ihs_n_news_ = confino_t), /// 
        a(i.codcom i.anno c.($controls_1950)#i.anno i.idprov#i.anno) /// 
        cl(codcom) savefirst savefp(fs_) 

    // Ripristina il modello del first stage
    if _rc == 0 {
        est restore fs_ihs_n_news_

        // Salva il coefficiente beta dal first stage
        scalar coeff = _b[confino_t]
		scalar p_value = (2 * ttail(e(df_r), abs(e(b)[1,1]/e(V)[1,1]^0.5)))

        // Salva coefficiente e p-value
        post handle (coeff) (p_value)
    }

    restore  // Ripristina il dataset originale
}

// Chiudi il file dei risultati
postclose handle

// Carica i risultati
use `results', clear

// Visualizza i beta stimati
list

// Crea un istogramma della distribuzione dei beta stimati
histogram beta, xtitle("{&beta}") normal color(navy) normopts(lc(cranberry))
graph export "$output/figures/Figure-A7.jpg", as(jpg) name("Graph") quality(90) replace

/*
**Exercise 2
clear all
use "$data/final_for_analysis.dta", clear
global controls_1950 "popolazione_residente_1930 popolazione_residente_1950 densita_demografica_1950 indice_vecchiaia_1950 inc_abitazioni_proprieta_1950 incidenza_analfabeti_1950 tasso_occ_agric_1950 tasso_occ_industr_1950 tasso_occ_comm_1950 tasso_occ_terz_1950 altitude area"
* declare panel data *
xtset codcom anno, del(10)


set seed 2024 
local N = 1000 // Numero di iterazioni

// Crea un file temporaneo per salvare i risultati
tempfile results
postfile handle beta using `results', replace

egen total_comuni = tag(codcom)
count if total_comuni == 1
local num_clusters = r(N)

local sample_size = round(0.25 * `num_clusters')

// Ciclo per stimare 2SLS N volte
forval i = 1/`N' {
    preserve
    // Estrai un campione casuale (con replacement)
    *bsample
	*bsample `=round(0.5 * `total_obs')'
	bsample `sample_size', cluster(codcom)

    // Stima il modello 2SLS
    capture ivreghdfe ihs_d100f_tv_ (ihs_n_news_ = confino_t), /// 
        a(i.codcom i.anno c.($controls_1950)#i.anno i.idprov#i.anno) savefirst savefp(fs_) 

    // Ripristina il modello del first stage
    if _rc == 0 {
        est restore fs_ihs_n_news_

        // Salva il coefficiente beta dal first stage
        scalar coeff = _b[confino_t]
        post handle (coeff)  // Salva il valore del coefficiente
    }

    restore  // Ripristina il dataset originale
}

// Chiudi il file dei risultati
postclose handle

// Carica i risultati
use `results', clear

// Visualizza i beta stimati
list

// Crea un istogramma della distribuzione dei beta stimati
histogram beta, xtitle("{&beta}") normal color(navy) normopts(lc(cranberry))
graph export "$output/figures/Figure-A7.jpg", as(jpg) name("Graph") quality(90) replace
/*