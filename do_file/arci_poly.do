/*Calculates Anderson Rubin Confidence Intervals
Via a polynomial method

ONLY WORKS if first-stage f-stat>3.84, which 
implies that the AR CI is an interval 

See Andrews, Stock, and Sun 2019 Annual Review for more info
(particularly appendix D)


Note:  for
Y=\beta X + \epsilon w/ Z as IV
* e(depvar) is Y
* e(exexog) is excluded instrument Z
* e(instd) is the endog x var being instrumented

This needs to be called right after ivreghdfe (or ivreg2)

********************************************************************/



global x="`e(instd)'"
global z="`e(exexog)'"
global y= "`e(depvar)'"
*** Need to First get Variances and Coefficients from IV/First Stage/and Reduced Forms
global iv_coef=_b[$x]
global iv_se=_se[$x]
global iv_coef2=$iv_coef * $iv_coef
global iv_var=$iv_se * $iv_se

estimates restore f_$x
global fs_coef=_b[$z]
global fs_se=_se[$z]
global fs_var=$fs_se * $fs_se
global fs_coef2=$fs_coef * $fs_coef 

estimates restore r_$y
global rf_coef=_b[$z]
global rf_se=_se[$z]
global rf_var=$rf_se * $rf_se
global rf_coef2=$rf_coef * $rf_coef

* get parts of polynomial
global sig = 1.96
global cov=-($iv_var - $iv_coef2 * ($fs_var / $fs_coef2) - ($rf_var / $fs_coef2 ) ) / (2*$iv_coef / $fs_coef2 )
global a=$fs_coef2 - ($sig^2) * $fs_var
global c=$rf_coef2 - ($sig^2) * $rf_var
global b=2* ($sig^2) * $cov - 2 * $fs_coef * $rf_coef
global Delta=($b * $b) - 4 * $a * $c 

* save the upper and lower bounds

global ar_l=(-$b - sqrt($Delta )) / (2* $a)
global ar_u=(-$b + sqrt($Delta )) / (2* $a)

* put them in a matrix w/ same name as the endogenous X var
matrix ar_l=$ar_l
matrix colnames ar_l = $x

matrix ar_u=$ar_u
matrix colnames ar_u = $x
