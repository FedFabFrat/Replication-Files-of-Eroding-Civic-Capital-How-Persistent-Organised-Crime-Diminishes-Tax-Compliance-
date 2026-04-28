********************************************************************************
***                                                                          ***
*** Replication code for: "Eroding Civic Capital: How Persistent Organised  ***
***                        Crime Diminishes Tax Compliance"                  ***
***                                                                          ***
*** Authors: Francesca Maria Calamunci & Federico Fabio Frattini             ***
***                                                                          ***
*** Journal: Journal of Law, Economics & Organization                        ***
***                                                                          ***
*** Stata version: 19 (StataNow)                                             ***
***                                                                          ***
*** DESCRIPTION: This master do-file runs all analysis scripts to reproduce  ***
*** the tables and figures in the paper and appendix.                        ***
***                                                                          ***
*** NOTE: Figures 1(a,b), 3, A1, and A2 are produced by R scripts located    ***
*** in do_file/ and do_file/appendix/. Run R_packages_to_install.R once to   ***
*** install the required R packages. Then run each .R script individually,   ***
*** updating the `root` path at the top of each script.                      ***
***                                                                          ***
********************************************************************************
clear all
set more off
set maxvar 32676



***********************************
**# ***    PACKAGE CHECKS      ***
***********************************
foreach package in reghdfe lincomest parmest estout ppmlhdfe matsave outreg2 ///
                   carryforward schemepack matchit freqindex imperfectiv       ///
                   plausexog testex balancetable psmatch2 {
    cap which `package'
    if _rc != 0 ssc install `package'
}

cap ado uninstall ftools
net install ftools, from("https://raw.githubusercontent.com/sergiocorreia/ftools/master/src/")

cap ado uninstall reghdfe
net install reghdfe, from("https://raw.githubusercontent.com/sergiocorreia/reghdfe/master/src/")

cap ado uninstall ivreg2
ssc install ivreg2

cap ado uninstall ivreghdfe
net install ivreghdfe, from(https://raw.githubusercontent.com/sergiocorreia/ivreghdfe/master/src/)

ssc install ranktest, replace
net install tf, force from(http://www.princeton.edu/~davidlee/wp/)



***********************************
**# ***      DIRECTORIES        ***
***********************************
* SET THIS TO THE ROOT OF THE REPLICATION PACKAGE FOLDER
global dir "PATH/TO/final_package_JLEO"
cd "$dir"



***********************************
**# ***   GLOBALS DECLARATION   ***
***********************************
global do      "$dir/do_file"
global data    "$dir/data"
global output  "$dir/output"
global figures "$output/figures"
global tables  "$output/tables"



***********************************
**# ***      MAIN FIGURES       ***
***********************************
* Figure 1 (a) and (b) — run do_file/Figure-1ab.R in R (update `root` path)
do "$do/Figure-1c"
do "$do/Figure-2"
* Figure 3 — run do_file/Figure-3.R in R (update `root` path)
do "$do/Figure-4"
do "$do/Figure-5"
do "$do/Figure-6"



***********************************
**# ***       MAIN TABLES       ***
***********************************
do "$do/Table-1"
do "$do/Table-2"
do "$do/Table-3"
do "$do/Table-4"
do "$do/Table-5"
do "$do/Table-6"



***********************************
**# ***    APPENDIX FIGURES     ***
***********************************
* Figure A1 — run do_file/appendix/Figure-A1.R in R (update `root` path)
* Figure A2 — run do_file/appendix/Figure-A2.R in R (update `root` path)
do "$do/appendix/Figure-A3"
do "$do/appendix/Figure-A4"
do "$do/appendix/Figure-A5"
* Figure A6 — screenshot of newspaper articles (no script required)
do "$do/appendix/Figure-A7"
do "$do/appendix/Figure-A8"



***********************************
**# ***     APPENDIX TABLES     ***
***********************************
do "$do/appendix/Table-A1"
do "$do/appendix/Table-A2"
do "$do/appendix/Table-A3"
do "$do/appendix/Table-A4"
do "$do/appendix/Table-A5"
do "$do/appendix/Table-A6"
do "$do/appendix/Table-A7"
do "$do/appendix/Table-A8"
do "$do/appendix/Table-A9"
do "$do/appendix/Table-A10"
