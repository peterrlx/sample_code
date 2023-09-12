* Peter RL Xue
* 2022-12
* homework for ECON530: applied micro (DOUGLAS ALMOND, KENNETH Y. CHAY, DAVID S. LEE QJE 2005)

** Problem Set 1

clear all
set more off

use "ps1.dta",clear
save full, replace

**Q1(a)
*summary table of the last 15 variables in the list
sum  cardiac lung diabetes herpes chyper phyper pre4000 preterm tobacco cigar cigar6 alcohol drink drink5 wgain

*drop the observation with missing data
drop if tobacco==9 | cigar==99 | cigar6==6 | alcohol==9 | ///
        drink==99 | drink5==5 | wgain==99
		
*summary table of the last 15 variables in the list
sum  cardiac lung diabetes herpes chyper phyper pre4000 preterm tobacco cigar cigar6 alcohol drink drink5 wgain

**Q1(b)
*tabulate the variable 
tab herpes

clear all
use full

gen tobaccomiss = (tobacco==9)
gen cigarmiss = (cigar==99)
gen drinkmiss = (drink==99)
gen herpesmiss = (herpes==8)

* "ssc install estout" if not already installed

eststo: quietly reg tobaccomiss cardiac lung diabetes herpes chyper phyper pre4000 preterm alcohol drink drink5 wgain
eststo: quietly reg cigarmiss cardiac lung diabetes herpes chyper phyper pre4000 preterm alcohol drink drink5 wgain
eststo: quietly reg drinkmiss cardiac lung diabetes herpes chyper phyper pre4000 preterm tobacco cigar cigar6 wgain
eststo: quietly reg herpesmiss cardiac lung diabetes chyper phyper pre4000 preterm tobacco cigar cigar6 alcohol drink drink5 wgain

esttab
esttab using PS1aQ1.csv,se replace
eststo clear

*drop the observation with missing data
drop if herpes==8

**Q1(c)
*summary table describing the final analysis data set
clear all
use full
drop if tobacco==9 | cigar==99 | cigar6==6 | alcohol==9 | ///
        drink==99 | drink5==5 | wgain==99 | herpes==8
sum  

*Q2(a)

label define tobacco1 1 "Smoker" 2 "Nonsmoker"
label values tobacco tobacco1 

save cleaned, replace

*one minute agpar score
ttest omaps, by(tobacco)


*five minute agpar score
ttest fmaps, by(tobacco)
*birthweight
ttest dbrwt, by(tobacco)

*Q2(b)

foreach var of varlist  rectype pldel3 birattnd cntocpop stresfip dmage ormoth mrace3 dmeduc dmar adequacy nlbnl dlivord dtotord totord9 monpre nprevist disllb isllb10 dfage orfath dfeduc birmon weekday dgestat csex dplural omaps fmaps clingest delmeth5 anemia cardiac lung diabetes herpes chyper phyper pre4000 preterm cigar cigar6 alcohol drink drink5 wgain {
ttest `var', by(tobacco)
}

*Q2(c)
* use your own judgement on selecting predetermined variables；these will be your control variables in (d)

*Q2(d)
clear all
use cleaned


** OLS **
reg  dbrwt smoking //add the list of variables that you think are important to control for
  