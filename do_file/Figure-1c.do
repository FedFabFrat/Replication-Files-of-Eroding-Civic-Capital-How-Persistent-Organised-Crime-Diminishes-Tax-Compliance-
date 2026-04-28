use "$data/final_for_analysis.dta", clear
collapse (mean) confino share_surname_conf, by(sll2001)
reg confino share_surname_conf, robust
local cons = r(table)[1,2]
local cons3: display %6.3f `cons'
local coeff = r(table)[1,1]
local coeff3: display %6.3f `coeff'
scalar pval = r(table)[4,1]
scalar pval = r(table)[4,1]
if pval <= 0.10 & pval > 0.05 {
	local star = "*"
} 
else if pval <= 0.05 & pval > 0.01 {
	local star = "**"
} 
else if pval <= 0.01 {
	local star = "***"
} 
else {
	local star = ""
}
local fsc2 `coeff3'`star'
twoway	(scatter confino share_surname_conf, mcolor(navy)) ///
		(lfitci confino share_surname_conf, fc(%50)), ///
		legend(order(1 "Scatter" 3 "Fitted values" 2 "CI") cols(3) pos(6)) ///
		xtitle("Share of FR surnames", size(medium)) ytitle("Pr(Forced resettlement)", size(medium)) ///
		note("Pr(Force resettlement) = `cons3' + `fsc2' Share of FR surnames") 
graph export "$figures/Figure-1c.pdf", as(pdf) replace
