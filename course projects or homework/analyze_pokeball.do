* This file is the code for the exercise at ECONRAGUIDE.
* link: https://raguide.github.io/new_email
* Rongli Xue, 2023-12


clear all
set more off

** change file path
global path = "C:/Users/user/Desktop/Pokeball"

* ================================
* import and save data 
* ================================
import delimited using "$path/city.csv", clear

save "city.dta", replace


import delimited using "$path/hospital.csv", clear

save "hospital.dta", replace

* ================================
* reorganize hospital data
* ================================

// reshape hospital data into a panel
reshape long cases,i(hospital) j(year)

// start year is 2000
gen year_new=year+2000
drop year
rename year_new year
order year hospital cases

// create hospital_id
encode hospital, gen(hospital_id)


// create city variable for each hopsital
split hospital
gen city = hospital1 + " " + hospital2 if hospital4==""
replace city = hospital1 + " " + hospital2 + " " + hospital3 if hospital4!=""
drop hospital1 hospital2 hospital3 hospital4

xtset hospital_id year
save "hospital.dta", replace

* ================================
* reorganize city data
* ================================

use "city.dta"
// reshape city data into a panel
reshape long factory_ production_,i(city) j(year)

// start year is 2000
gen year_new=year+2000
drop year
rename year_new year

* ================================
* merge "city" and "hospital" data
* ================================
merge m:m city year using "hospital.dta" // no unmatched items
drop _merge

** reorganize data
rename production_ production
rename factory_ factory

gen policy=1 if lawchange=="TRUE"
replace policy=0 if lawchange=="FALSE"
drop lawchange
replace policy=0 if year<2008

order hospital_id year policy city cases production factory population hospital

* ================================
* compute total cases for each city and year
* ================================
egen totalcase=sum(cases), by (year city)
sort city year

save "final_data_all.dta", replace


* ================================
* save final dataset (city-year level)
* ================================
** only keep city level data
drop hospital_id hospital cases
encode city, gen(city_id)


duplicates drop city year, force
xtset city_id year

save "pokeball.dta", replace

* ================================
* DID analysis??

* The effect of the policy on the number of asthma cases, the number of factories opened, and the number of pokeballs produced
* ================================

clear all
use "pokeball.dta"

// population has been captured by the city fixed effect

* dependent variable: cases of asthma (in log)
gen lcase=log(totalcase)

xtreg lcase policy i.year, fe

outreg2 using didresult.xls, nocons drop(i.year) bdec(3) tdec(2) adds(adjusted R-squared, `e(r2_a)') append


* dependent variable: number of factories
gen lfactory=log(factory)

xtreg lfactory policy i.year, fe
outreg2 using didresult.xls, nocons drop(i.year) bdec(3) tdec(2) adds(adjusted R-squared, `e(r2_a)') append


* dependent variable: production (in log)
gen lproduction=log(production)

xtreg lproduction policy i.year, fe
outreg2 using didresult.xls, nocons drop(i.year) bdec(3) tdec(2) adds(adjusted R-squared, `e(r2_a)') append

// we can further perform a pre-trend test.

* ==============================
* the effect of the opening of Pokeball factories on a town's incidence of childhood asthma
* ==============================
// dependent variable: the total number of children's hospital stays related to asthma (in log)
// indepdent variable: the number of factories
// control variables: the number of Pokeballs produced, policy dummies
// population has been captured by city fixed effect

reg lcase lfactory policy production i.city_id i.year
outreg2 using factoryresult.xls, nocons drop(i.year i.city_id) bdec(3) tdec(2) adds(adjusted R-squared, `e(r2_a)') append



// conclusion: 1% increase in the number of factories lead to 0.239% increase in the number of children's asthma cases

