* Peter RL Xue
* 2022-12
* homework for ECON530: applied micro (DOUGLAS ALMOND, KENNETH Y. CHAY, DAVID S. LEE, QJE 2005, the costs of low birth weight)

****************** Problem set 1 ***************************  

clear all
set more off

use "ps1.dta",clear
save full, replace

**Q1(a)
*summary table of the last 15 variables in the list
sum cardiac lung diabetes herpes chyper phyper pre4000 preterm tobacco cigar cigar6 alcohol drink drink5 wgain

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

************* Problem set 2: propensity score ******************** 
clear all
set more off
use "ps1.dta", clear

* Redo the data cleaning procedure.
drop if tobacco==9
drop if cigar==99
drop if alcohol==9
drop if drink==99
drop if wgain==99
drop if herpes==8
replace tobacco=0 if tobacco==2
* Now we have 114,610 observations.

*1(b)
gen dmeduc2=dmeduc^2
reg dbrwt tobacco dmage mrace3 dmeduc dmeduc2
outreg2 using result.doc, replace title(Non-linear regression with quadratic terms)
drop dmeduc2

*2(a)
clear all
set more off
use "ps1.dta", clear

*** clean the data***
	qui tab cardiac
	qui tab lung
	qui tab diabetes
	qui tab herpes
	drop if herpes == 8
	qui tab chyper
	qui tab phyper
	qui tab pre4000
	qui tab preterm
	qui tab tobacco
	drop if tobacco == 9
	qui tab cigar
	drop if cigar == 99
	qui tab cigar6
	drop if cigar6 == 6
	qui tab alcohol
	drop if alcohol == 9
	qui tab drink
	drop if drink == 99
	qui tab drink5
	drop if drink5 == 5
	qui tab wgain
	drop if wgain == 99
*** Recode dummy variables***
*************create all dummies**************
gen smoking = (tobacco==1)

local DUMMY rectype pldel3 dmar csex anemia lung cardiac diabetes ///
      chyper phyper herpes pre4000 preterm alcohol

foreach x of local DUMMY {
gen `x'1 = (`x'==1)
}

local CATEGORY birattnd cntocpop stresfip ormoth mrace3 dmeduc adequacy isllb10 orfath dfeduc birmon weekday delmeth5
foreach x of local CATEGORY {
qui tabulate `x', gen (`x') 
drop `x'1
}


*** Rename variables and create second order terms for continuous variables ***

local CON  dmage nlbnl dlivord dtotord totord9 monpre nprevist dplural drink drink5 wgain
foreach x of local CON {
local i = `i'+1
gen var`i'=`x'
}
forvalues i=1/11{
forvalues j=`i'/11{
gen inter`i'`j'=var`i'*var`j'
}
}


*** Drop interaction terms ***
forvalues i=1/11{
local k=`i'+1
forvalues j=`k'/11{
drop inter`i'`j'
}
}

*** Use RHS variables as in Ps1a_solution, i.e. without interactions ***
local RHS rectype1 pldel31 dmar1 csex1 stresfip* dmage mrace3* dmeduc* birattnd* cntocpop*  ormoth* ///
        adequacy* nlbnl dlivord dtotord totord9 monpre nprevist disllb isllb10* dfage orfath* dfeduc* ///
        dplural anemia1 cardiac1 lung1 diabetes1 herpes1 chyper1 phyper1 pre40001 preterm1 alcohol1 ///
        birmon* weekday* delmeth5* drink drink5 wgain

*** Logit Specification ***
logit smoking `RHS'
predict phat1

*** Drop insignificant variables depending on your RHS, below I assume remaining variables are RHS2 ***
local RHS2 rectype1 pldel31 dmar1 csex1 stresfip* dmage mrace3* dmeduc* birattnd* cntocpop*  ormoth*

*** Logit Specification and compare predictions ***
logit smoking `RHS2'
predict phat2 if e(sample)
twoway (scatter phat1 phat2, sort)




*2(b)
clear
set more off
//log using ps2, text
use ps1.dta

* Redo the data cleaning procedure.
drop if tobacco==9
drop if cigar==99
drop if alcohol==9
drop if drink==99
drop if wgain==99
drop if herpes==8
replace tobacco=0 if tobacco==2

global controls dmage dfage dmeduc dfeduc mrace3 dmar dlivord monpre nprevist disllb cntocpop birmon dtotord pre4000 preterm alcohol drink anemia cardiac lung diabetes herpes chyper phyper /*choose covariates*/
reg dbrwt tobacco ,r /*raw difference without controls*/
reg dbrwt tobacco $controls ,r /*raw difference with controls*/
logit tobacco $controls /*run a logit regression*/
predict pscore,pr /*predict the probabilities*/


reg dbrwt tobacco pscore, r
outreg2 using result.doc, replace title(PSM regression)

*2(c)
*compute ATE step-by-step
gen temp=.
gen temp1=.
replace temp=dbrwt*(1/pscore) if tobacco==1
replace temp1=1/pscore if tobacco==1
egen a=sum(temp)
egen aa=sum(temp1)
gen aaa=a/aa
gen temp2=.
gen temp3=.
replace temp2=-dbrwt*(1/(1-pscore)) if tobacco==0
replace temp3=1/(1-pscore) if tobacco==0
egen b=sum(temp2)
egen bb=sum(temp3)
gen bbb=b/bb
gen ate=aaa+bbb
list ate in 1/1 /*result：-210.63*/
drop temp 
drop temp1
drop temp2
drop temp3
drop a 
drop b 
drop aa 
drop bb
drop aaa
drop bbb 
drop ate

*use STATA 'teffects' package to compute inverse prob weights
teffects ipw (dbrwt) (tobacco $controls, logit), ate /*result：-210.63, the same as the result above*/

*3. use blocking to compute ATE
**divide into groups
egen pscore_cut=cut(pscore), group(50)
// table pscore_cut, contents(n pscore min pscore max pscore)
**compute the ATE
gen size=_N
forvalues i=0/49{
egen treat_`i'=mean(dbrwt) if pscore_cut==`i'& tobacco==1
egen control_`i'=mean(dbrwt) if pscore_cut==`i'& tobacco==0
egen mean_treat_`i'= mean(treat_`i')
egen mean_control_`i'= mean(control_`i')
gen ate_`i'=mean_treat_`i'-mean_control_`i'
}

forvalues i=0/49{
count if pscore_cut==`i'
gen size_`i'=r(N)
gen weighted_ate_`i'=ate_`i'*size_`i'/size
}
**within block calculation
gen block_ate=0
forvalues i=0/49{
replace block_ate= block_ate+weighted_ate_`i'
}
**add together
list block_ate in 1/1

*4.Redo 3 using an indicator for low birth weight
qui forvalues i=0/49{
drop treat_`i'
drop control_`i'
drop mean_treat_`i' 
drop mean_control_`i'
drop ate_`i'
drop size_`i'
drop weighted_ate_`i'
}
drop block_ate
drop pscore_cut
gen lbw=.
replace lbw=0 if (dbrwt>2500|dbrwt==2500)
replace lbw=1 if dbrwt<2500
**divide into groups
egen pscore_cut=cut(pscore), group(50)
**compute the ATE
qui forvalues i=0/49{
egen treat_`i'=mean(lbw) if pscore_cut==`i'& tobacco==1
egen control_`i'=mean(lbw) if pscore_cut==`i'& tobacco==0
egen mean_treat_`i'= mean(treat_`i')
egen mean_control_`i'= mean(control_`i')
gen ate_`i'=mean_treat_`i'-mean_control_`i'
}
qui forvalues i=0/49{
count if pscore_cut==`i'
gen size_`i'=r(N)
gen weighted_ate_`i'=ate_`i'*size_`i'/size
}
gen block_ate=0
qui forvalues i=0/49{
replace block_ate= block_ate+weighted_ate_`i'
}
list block_ate in 1/1

qui forvalues i=0/49{
drop treat_`i'
drop control_`i'
drop mean_treat_`i' 
drop mean_control_`i'
drop ate_`i'
drop size_`i'
drop weighted_ate_`i'
}
drop block_ate
drop pscore_cut
drop size 
