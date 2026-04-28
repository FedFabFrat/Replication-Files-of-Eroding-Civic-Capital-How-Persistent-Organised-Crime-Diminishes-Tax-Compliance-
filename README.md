# Replication Package — *Eroding Civic Capital: How Persistent Organised Crime Diminishes Tax Compliance*

**Authors:** Francesca Maria Calamunci & Federico Fabio Frattini  
**Journal:** Journal of Law, Economics & Organization (JLEO), Manuscript MS7010

---

## Overview

This repository contains the finalized datasets and analysis code needed to reproduce all tables and figures in the paper and online appendix. It does **not** include raw data or data-construction scripts; the final analysis-ready datasets are provided directly.

---

## Software Requirements

| Software | Version | Purpose |
|----------|---------|---------|
| Stata | 18+ (StataNow 19 used by authors) | All `.do` files |
| R | 4.x | Mapping figures (Figure 1a/b, 3, A1) and text analysis (Figure A2) |

### Stata packages

Run the package-check block at the top of `master_analysis_JLEO.do` once. It installs:

`reghdfe`, `ftools`, `ivreghdfe`, `ivreg2`, `ranktest`, `tf`, `ppmlhdfe`, `estout`, `lincomest`, `parmest`, `matsave`, `outreg2`, `carryforward`, `schemepack`, `matchit`, `freqindex`, `imperfectiv`, `plausexog`, `testex`, `balancetable`, `psmatch2`

### R packages

Run `do_file/R_packages_to_install.R` once. Main packages: `dplyr`, `sf`, `ggplot2`, `haven`, `ggpubr`, `tidyverse`, `quanteda`, `readtext`, `topicmodels`, and others listed in that script.

---

## Folder Structure

```
final_package_JLEO/
├── master_analysis_JLEO.do     ← main entry point (Stata)
├── data/
│   ├── final_for_analysis.dta  ← main panel dataset (73 variables, 33,054 obs)
│   ├── ads_main_1980.dta       ← provincial newspaper readership (used by Table 5)
│   ├── maps/
│   │   ├── maps_data.dta       ← municipality-level map summaries
│   │   ├── Com2011_WGS84.*     ← municipality shapefile (2011)
│   │   ├── Reg2011_WGS84.*     ← region shapefile (2011)
│   │   └── Prov2011_WGS84.*    ← province shapefile (2011)
│   └── oc_news/
│       └── oc_news_text_analysis.csv  ← newspaper article texts (Figure A2)
├── do_file/
│   ├── arci_poly.do            ← Anderson-Rubin CI helper (called by Table 3, A8)
│   ├── R_packages_to_install.R ← R package installer
│   ├── Figure-1ab.R            ← Figure 1 (panels a & b): maps of confino & TV tax
│   ├── Figure-1c.do            ← Figure 1 (panel c): IV first-stage scatter
│   ├── Figure-2.do             ← Figure 2: TV tax compliance trends by region
│   ├── Figure-3.R              ← Figure 3: maps of mafia news
│   ├── Figure-4.do             ← Figure 4: event study (reduced form)
│   ├── Figure-5.do             ← Figure 5: event study (first stage)
│   ├── Figure-6.do             ← Figure 6: event study (economic outcomes)
│   ├── Table-1.do              ← Table 1: descriptive statistics
│   ├── Table-2.do              ← Table 2: reduced-form estimates
│   ├── Table-3.do              ← Table 3: OLS and 2SLS estimates
│   ├── Table-4.do              ← Table 4: economic and criminal activity outcomes
│   ├── Table-5.do              ← Table 5: heterogeneity by newspaper readership
│   ├── Table-6.do              ← Table 6: migration heterogeneity
│   └── appendix/
│       ├── Figure-A1.R         ← Figure A1: maps (OC, homicides, surnames)
│       ├── Figure-A2.R         ← Figure A2: text/topic analysis of OC news
│       ├── Figure-A3.do        ← Figure A3: PSM common support & overlap
│       ├── Figure-A4.do        ← Figure A4: event study (PSM sample, RF)
│       ├── Figure-A5.do        ← Figure A5: event study (PSM sample, FS)
│       ├── Figure-A7.do        ← Figure A7: bootstrap distribution of FS coefficient
│       ├── Figure-A8.do        ← Figure A8: Conley bounds (sensitivity)
│       ├── Table-A1.do         ← Table A1: mafia news and confiscation dummies
│       ├── Table-A2.do         ← Table A2: balance table by forced resettlement
│       ├── Table-A3.do         ← Table A3: other specifications (PPML, radio, etc.)
│       ├── Table-A4.do         ← Table A4: population heterogeneity
│       ├── Table-A5.do         ← Table A5: PSM balance test (txt output)
│       ├── Table-A6.do         ← Table A6: main results on PSM sample
│       ├── Table-A7.do         ← Table A7: alternative PSM samples
│       ├── Table-A8.do         ← Table A8: OLS and 2SLS (appendix version)
│       ├── Table-A9.do         ← Table A9: Lee et al. (2022) valid t-ratio inference
│       └── Table-A10.do        ← Table A10: balance by forced resettlement + readership
└── output/
    ├── figures/                ← all figures saved here (PDF/JPG)
    └── tables/                 ← all tables saved here (TEX/TXT)
```

> **Note:** Figure A6 is a screenshot of newspaper articles and has no associated script.

---

## How to Replicate

### Step 1 — Set the root directory

Open `master_analysis_JLEO.do` and update the global on this line:

```stata
global dir "PATH/TO/final_package_JLEO"
```

### Step 2 — Run Stata analysis

Run `master_analysis_JLEO.do` from Stata. This reproduces all tables and figures produced in Stata. Outputs go to `output/tables/` and `output/figures/`.

### Step 3 — Run R scripts

For each R script listed below, open the file and update the `root` variable at the top:

```r
root <- "path/to/final_package_JLEO"
```

Then run:
- `do_file/Figure-1ab.R` → Figure 1 (panels a & b)
- `do_file/Figure-3.R` → Figure 3
- `do_file/appendix/Figure-A1.R` → Figure A1
- `do_file/appendix/Figure-A2.R` → Figure A2

---

## Main Dataset: `final_for_analysis.dta`

Panel dataset at the municipality-decade level. Unit of observation: municipality (`codcom`) × decade (`anno`, from 1950 to 2000 in 10-year steps).

**Key variables:**

| Variable | Description |
|----------|-------------|
| `codcom` | Municipality ISTAT code (2011 boundaries) |
| `anno` | Decade (1950, 1960, ..., 2000) |
| `idreg` / `idprov` | Region / province code |
| `sll2001` | Local labour market area (ISTAT 2001) |
| `confino` | = 1 if municipality ever received a forced resettler |
| `confino_t` | Time-varying version of `confino` (= 1 from 1970 onward for treated) |
| `d100f_tv_` | TV licence compliance rate (licences / households × 100) |
| `ihs_d100f_tv_` | IHS transformation of `d100f_tv_` |
| `n_news_` | Number of OC-related news mentions per decade |
| `ihs_n_news_` | IHS transformation of `n_news_` |
| `share_s_migrants` | Share of migrants from Southern Italy (provincial level) |
| `share_mi_migrants` | Share of migrants from high-Mafia-Index Southern provinces |
| `share_surname_conf` | Share of surnames matching forced resettlers (instrument validity) |
| `confisc_dum` | = 1 if municipality ever had an asset confiscation (post-1980) |
| `nfirms_*` | Number of firms by sector (time-varying) |
| `*_1950` | Baseline (1950) controls interacted with decade dummies in regressions |

