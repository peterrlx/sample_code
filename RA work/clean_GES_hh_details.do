* Peter Xue
* This file cleans GES-A.Household_details. xlsx
* This version: 2023-06


clear all
set more off

*** Change the working directory before running the .do file ***

global filepath = "D:/github files/educ_var" 



*======= generate household member datasets from each year (09-14) ==============

forvalues y = 2009/2014 {
    display in red "------generating hh member dataset, Year : `y'"
	
	
	
	* import the full dataset
	import excel "$filepath/orig_data/`y'/ges/A.Household_details.xlsx", firstrow clear
	
	* generate year
	gen year=`y'
	
	* create the identifiers for household
	gen country = substr(VDS_ID,1,1)
	gen state = substr(VDS_ID,2,2)
	gen village = substr(VDS_ID,6,1)
	gen household = substr(VDS_ID,7,4)

	gen hhid = country + "-" + state + "-" + village + "-" + household
	order VDS_ID hhid country state village household
	replace vil = state + "-" + village

	by hhid, sort: gen count=_N
	order hhid year count
	sort hhid year
	
	* destring variables (in different years)
	if `y'==2013|`y'==2014{
	label var YR_STOP_EDU "Year of stopping edu"
	local varlist "REL OLD_MEM_ID PRE_MEM_ID SPOUSE_M_ID CHILD_M_ID CHILD_F_ID MARI_STAT EDU_LEVEL YRS_EDU YR_STOP_EDU REA_STOP_EDU MAIN_OCCP SUBS_OCCP DEG_AB HEIGHT WEIGHT ARM_CIRCUM" // in 2013,14 samples, AGE SPOUSE_F_ID contains multiple values (cannot destring)
	destring `varlist', replace
	}
	
	if `y'==2013{
	destring SL_NO, replace
	}
	
	if (`y'==2009|`y'==2010){
	label var YR_EDU_TER "The year in which the individual member finished/stopped his/her education" 
	destring MAIN_OCCP, replace
	}
	
	if `y'==2011{
	destring CH_STAT MAIN_OCCP SUBS_OCCP, replace
	}
	
	* label the variables (2009-2014)
	label var VDS_ID "Household ID"
	label var SL_NO "Serial number"
	label var REL "relation to head"
	label define relation 1 "Head/Self" 2 "Father" 3 "Mother" 4 "Spouse" 5 "Son" 6 "Daughter" 7 "Son-in-law" 8"Daughter-in-law" 9"Grandson"  10"Grand daughter" 11"Brother" 12 "Sister" 13 "Brother’s wife" 14 "Brother’s children" 15 "Others"
    label values REL relation
	label var OLD_MEM_ID "Household member old id if the present member was the part of the household during first generation VLS"
	label var PRE_MEM_ID "Household member present id"
	label var SPOUSE_M_ID "Member code(ID) assigned to her spouse if she is married"
	label var SPOUSE_F_ID "Member code (ID) assigned to his spouse if he is married"
	label var CHILD_M_ID  "Member code (ID) assigned to his/her father"
	label var CHILD_F_ID "Member code (ID) assigned to his/her mother"
	label var MARI_STAT "Marital status of individual"
	label define marr 1 "Married" 2 "Unmarried" 3 "Widow/Widower" 4 "Divorced" 5  "Separated"
	label values MARI_STAT marr
	label var MARI_STAT_OT "Specify if Marital_status is others"
	label var MARRIAGE_YR "Year in which he/she got married if applicable"
	label var EDU_LEVEL "Education level"
	label var EDU_LEVEL_OT "Specify if Edu_level is others"
	label var YRS_EDU "Actual number of years the individual spent in education as on 1st July"
	label var REA_STOP_EDU "Reasons for stopping education"
	label var REA_STOP_EDU_OT "Specify if reasons for stopping education is others"
	label var MAIN_OCCP "main occupation: Individual member derives highest proportion of income or spent maximum time during the year"
	label var SUBS_OCCP "secondary occupation: Individual member derives second highest proportion of income or spending time during the year"
	label var DEG_AB "Degree of ability of the family member and what is doing presently."
	label var LIV_WF_OS "Is the individual member living with the family or outside"
	label var OS_PLACE "Name of the place if the individual member of the household is living outside during the survey year"
	label var OS_DIST "Distance from the village in Kilometers"
	label var FREQ_VISITS "Codes used for frequency of visits by the migrant to the village: More than once in a month = 1, Once a month = 2, More than once in a year = 3, Once a year = 4, Once in 2-3 years = 5"
	label var OS_PURPOSE "Main reason for living outside (study, job, non-farm work etc.)"
	label var MEM_ORG_NAME "name of org (If the family member(s) joined any organization/trust)"
	label var HEIGHT "Height (BMI of each family members)"
	label var WEIGHT "Weight(BMI of each family members)"
	label var ARM_CIRCUM "Arm circumference (BMI of each family members)"
	label var REMARKS "Remarks"
	destring(YRS_EDU AGE REL), replace
	
	* label variables (in different years)
	if `y'==2011|`y'==2012|`y'==2013|`y'==2014{
	label var CH_STAT "Change in status"
	label var CH_STAT_OT "Change in status-Others"
	label var REL_OT "Relation with head-Others"
	label var MAIN_OCCP_OT "Main occupation-Others"
	label var SUBS_OCCP_OT "Sub. occupation-Others"
	}

	if `y' >= 2013 {
	split(AGE), p("M")
	replace AGE = "0" if AGE2 == "ONTH" | AGE2 == "ONTHS"
	drop AGE1 AGE2

	replace AGE = subinstr(AGE," ","",.)		
	replace AGE = "0" if AGE == "1M" | AGE == "2M" | AGE == "3M" | AGE == "4M" | AGE == "5M" | AGE == "6M" | AGE == "7M"
	replace AGE = "0" if AGE == "18DAYS" | AGE == "28DAYS"
	// set age of baby as zero
	destring AGE, replace
}

	
	* gender
	gen male = 0
	replace male = 1 if (GENDER == "MALE" | GENDER == "Male" | GENDER == "M")
	drop GENDER
		
	* age
	rename AGE age
	drop if age==.
	
	* educ ot
	replace EDU_LEVEL_OT = subinstr(EDU_LEVEL_OT, " ", "", .)
	
	* living with family or outside
	if `y'==2009 | `y'==2010{
	replace LIV_WF_OS="Family" if LIV_WF_OS=="With Family"
	}
	if `y'==2013{
		replace LIV_WF_OS = subinstr(LIV_WF_OS," ","",.)
	}
	if `y'==2014{
		replace LIV_WF_OS = subinstr(LIV_WF_OS," ","",.)
		replace LIV_WF_OS="Family" if LIV_WF_OS=="FAMILY"
		replace LIV_WF_OS="Outside" if LIV_WF_OS=="OUTSIDE"
	}
	
	* modify data format
	    
	if `y'==2009| `y'==2010{
		format age %10.0g
		format SL_NO %10.0g
		format OLD_MEM_ID %10.0g
		format PRE_MEM_ID %10.0g
		format SPOUSE_M_ID %10.0g
		format SPOUSE_F_ID %10.0g
		format CHILD_M_ID %10.0g
		format CHILD_F_ID %10.0g
		format EDU_LEVEL %10.0g
		format YRS_EDU %10.0g
		format SUBS_OCCP %10.0g
		format DEG_AB %10.0g
		format OS_DIST %10.0g
		format FREQ_VISITS %10.0g
	}
	
	if `y'==2011{
		format YRS_EDU %10.0g
	}
	
	if `y'>=2011{
		format CH_STAT %10.0g
	}

	* rename variables
	if `y'==2011{
	rename REMARKS_A REMARKS
	}
	
	* save dataset
	save "$filepath/temp_data/hh_details_`y'.dta", replace	
	
}


* ================= construct a dataset including all years =====================

* append 2009-2014 datasets
clear all
use "$filepath/temp_data/hh_details_2009.dta"


forvalues y = 2010/2014 {

 append using "$filepath/temp_data/hh_details_`y'.dta",force
 
}

* drop missing values
	drop if SL_NO==.
	

* label variables
label var CH_STAT "Change in status"
label var CH_STAT_OT "Change in status-Others"
label var REL_OT "Relation with head-Others"
label var MAIN_OCCP_OT "Main occupation-Others"
label var SUBS_OCCP_OT "Sub. occupation-Others"
label var YR_STOP_EDU "Year of stopping edu"
label var MEM_NAME "member name"

* lowercase all variable names
rename *, lower

* educ-level
label define edulevel 0 "Illiterate" 1 "Primary(1-4th std)" 2 "Middle(5-7th std)" 3 "High school(8-10th std)" 4 "Inter(11-12th std)" 5 "Diploma" 6 "Graduation" 7 "Post-graduation" 8 "Technical degree" 9 "Double degree" 10 "PhD" 11 "Others"
label values edu_level edulevel

* living status
replace liv_wf_os="Family" if liv_wf_os=="With family"
encode liv_wf_os, gen (temp_liv_wf_os)
drop liv_wf_os
rename temp_liv_wf_os liv_wf_os
label var liv_wf_os "Is the individual member living with the family or outside"

* status change
replace ch_stat=0 if ch_stat==.
label define status 0 "Present in HH" 1 "Left the HH due to marriage" 2 "Left the HH due to separation (family division)"  3 "Death"  4 "Left the HH due to other reason" 5 "Joined the HH due to birth" 6 "Joined the HH due to marriage" 7 "Rejoined the family" 8 "Joined the HH due to other reason"
label values ch_stat status


* reasons for stopping education
replace rea_stop_edu=0 if rea_stop_edu==.
label define stopedu 0 "n/a" 1 "Not affordable" 2 "facilities are faraway"  3 "enough to get employment"  4 "child not interested" 5 "support the family" 6 "enough to get minimum knowledge" 7 "Others(specify)"
label values rea_stop_edu stopedu
replace rea_stop_edu_ot = subinstr(rea_stop_edu_ot," ","",.)

* main/secondary occupation
label define occup 1 "Farming" 2 "Farm labour" 3 "Non-farm labour" 4 "Regular farm servant" 5 "Livestock" 6 "Business" 7 "Caste occupation" 8 "Salaried job"  9 "Education" 10 "Domestic work" 11 "No work (Child/Old age/Physically or mentally handicapped)" 12 "Others"
label values main_occp occup
label values subs_occp occup
replace main_occp_ot = subinstr(main_occp_ot," ","",.)
replace subs_occp_ot = subinstr(subs_occp_ot," ","",.)


* degree of disability
label define dab 1 "Can do any farm, domestic, any other physical work" 2 "Can do only farm work"  3 "Can do only domestic work" 4 "Can do only light farm work" 5 "Can do only light domestic work" 6 "Cannot do any work (due to young/old age or physical/mental disability)"
label values deg_ab dab


* create member id 
/*
tostring sl_no, gen(sl_no_str)
gen memberid = country + "-" + village + "-" + household + "-" + sl_no_str
order memberid, a(hhid)
encode memberid, gen(memberid_new)
tab memberid_new
bysort memberid: gen memberid_freq = _N // observations for each member
sort year
sort hhid, stable
sort memberid, stable
tab memberid_freq
*/
tostring pre_mem_id, gen(pre_mem_id_str)
gen memberid = country + "-" + village + "-" + household + "-" + pre_mem_id_str
order memberid, a(hhid)
encode memberid, gen(memberid_new)
tab memberid_new
bysort memberid: gen memberid_freq = _N // observations for each member
sort year
sort hhid, stable
sort memberid, stable
tab memberid_freq

* reorder some variables
order yr_stop_edu, a(yrs_edu)
order male, a(age)
order main_occp_ot, a(main_occp)
order subs_occp_ot, a(subs_occp)

* years of stopping education
gen yr_stop_edu2=max(yr_stop_edu,yr_edu_ter)
drop yr_stop_edu yr_edu_ter
rename yr_stop_edu2 yr_stop_edu
label var yr_stop_edu "The year in which the individual member finished/stopped his/her education"

* keep all household members
preserve
sort year, stable
sort hhid, stable
save "$filepath/temp_data/individual_all.dta", replace
xtset memberid_new year
restore

/*

* construct a strongly-balanced panel dataset
preserve
keep if memberid_freq==6
xtset memberid_new year
save "$filepath/temp_data/individual_panel.dta", replace
restore

*/

* erase temp yearly datasets
forvalues y = 2009/2014 {
erase "$filepath/temp_data/hh_details_`y'.dta"
}

