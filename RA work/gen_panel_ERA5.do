/*

This file generates a panel by merging powerplant data with ERA-5 temperature & rainfall data.

*/

clear all
set more off

// set working directory
global filepath = "D:/github files/climate"

* convert climate data into dta format
import excel "$filepath/2013_19_data/clean_ERA5_output.xlsx", firstrow clear
rename longitude longitude_round
rename latitude latitude_round
save "$filepath/2013_19_data/clean_ERA5_output.dta", replace


* clean powerplant data
clear all
import delimited "$filepath/2013_19_data/global_power_plant_database.csv"

// reshape into panel
forvalues i=2013(1)2019{
  rename generation_gwh_`i' generation_gwh`i'
}

forvalues i=2013(1)2017{
  rename estimated_generation_gwh_`i' estimated_generation_gwh`i'
  rename estimated_generation_note_`i' estimated_generation_note`i'
}

local dynamic_var generation_gwh estimated_generation_gwh estimated_generation_note

reshape long `dynamic_var', i(gppd_idnr) j(year)

rename gppd_idnr identifier


* merge with ERA5 data
merge m:m identifier year using "$filepath/2013_19_data/clean_ERA5_output.dta"


* order, keep and label
order identifier year latitude longitude temperature rainfall capacity_mw year_of_capacity_data  primary_fuel commissioning_year generation_gwh estimated_generation_gwh estimated_generation_note country country_long name 

keep identifier year latitude longitude temperature rainfall capacity_mw year_of_capacity_data  primary_fuel commissioning_year generation_gwh estimated_generation_gwh estimated_generation_note country country_long name 

label var identifier "identifier for the powerplant"
label var capacity_mw "electrical generating capacity in megawatts"
label var year_of_capacity_data "year the capacity information was reported"
label var primary_fuel "energy source used in primary electricity generation or export"
label var commissioning_year "year of plant operation"
label var generation_gwh "electricity generation in GWh"
label var estimated_generation_gwh "estimated electricity generation in GWh"
label var estimated_generation_note "estimation method"
label var name "powerplant name in Romanized form"

* save the panel
save "$filepath/2013_19_data/final_data.dta", replace

erase "$filepath/2013_19_data/clean_ERA5_output.dta" // erase temp datasets
erase "$filepath/2013_19_data/clean_ERA5_output.xlsx"
