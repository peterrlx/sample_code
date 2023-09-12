* Peter RL Xue
* 2023-04
* Homework 2 for FIN065: venture capital course

clear
set more off
// log using vchomework

use vcdeal.dta
egen startup_id = group(Com_Name)



* label varaibles *

label var RoundDate "Date of Investment Round"
label var Round_Number "The number of the current round (Round 1, 2, 3, etc)" 
label var Round_Amount "The amount of US dollars in 1000 in the round"
label var Com_Name "The Entrepreneurial Company Name"
label var Com_Found_Year "The Entrepreneurial Company’s Founding Year"
label var Com_Ind_Minor "The Entrepreneurial Company’s Operating Industry"
label var Com_Situation "The Entrepreneurial Company’s Current Status"
label var Firm_Name "VC Firm’s Name"
label var Firm_Type "Investor Type"
label var Fund_Name "VC Fund Name (The given VC fund is affiliated with the VC firm)"
label var Num_Investors "Total number of investors in the round"
label var Round_Infor "Extra Information in the Round"

* Question 3: IPO
preserve
duplicates drop Com_Name, force
tab Com_Situation
keep if Com_Situation=="Went Public"
count
gen IPO=r(N)
list IPO in 1/1
qui drop IPO
restore

* Question 4: acquisition
preserve
duplicates drop Com_Name, force
keep if Com_Situation=="Acquisition" | Com_Situation=="Pending Acquisition"
egen acquisition = count(Com_Situation)
list acquisition in 1/1
drop acquisition
restore

* Question 5: largest round amount
preserve
keep Com_Name Round_Amount Round_Number
duplicates drop Com_Name Round_Number,force
egen totalamount = total(Round_Amount), by(Com_Name)
collapse totalamount, by(Com_Name)
gsort -totalamount
list Com_Name in 1/1
restore

* Question 6-1: total rounds of investments
preserve
collapse (max) Round_Number, by(Com_Name)
egen totalrounds=total(Round_Number)
list totalrounds in 1/1
restore

* Question 6-2: average rounds of investments
preserve
collapse (max) Round_Number, by(Com_Name)
egen averagerounds=mean(Round_Number)
list averagerounds in 1/1
restore

* Question 7: the fraction of CVC investors
preserve
duplicates drop Firm_Name, force
count
gen totalvc=r(N)
tab Firm_Type
keep if Firm_Type=="Corporate PE/Venture"
count
gen totalCVC=r(N)
gen cvc_frac=totalCVC/totalvc
list cvc_frac in 1/1
restore


* Question 8-1: IPO exit of CVC-backed startups 
* CVC-backed*
// select the firms that have been backed by CVC for at least one round

preserve
gen CVC=1 if Firm_Type=="Corporate PE/Venture"
keep if CVC==1
duplicates drop Com_Name, force 
count
gen CVC_backed=r(N)
keep if Com_Situation=="Went Public"
count
gen CVC_IPO=r(N)
gen cvc_ipo_frac=CVC_IPO/CVC_backed
list cvc_ipo_frac in 1/1 
restore

//select the firms that have been backed by VC for at least one round (those whose first rounds were backed by CVC are not taken into account)
preserve
gen aa=0
replace aa=1 if (Firm_Type=="Corporate PE/Venture") & (Round_Number==1)
gen bb=0
replace bb=1 if (Firm_Type=="Private Equity Firm")
keep startup_id Com_Name Firm_Type Com_Situation Firm_Name Round_Number aa bb
egen zz = max(aa), by(Com_Name) //zz=1表示第1轮有cvc参与
egen yy= max(bb), by(Com_Name) //yy=1表示有VC参与
drop if zz==1
drop if yy==0
duplicates drop startup_id, force
count
gen VC_backed=r(N)
keep if Com_Situation=="Went Public"
count
gen VC_IPO=r(N)
gen vc_ipo_frac=VC_IPO/VC_backed
list vc_ipo_frac in 1/1
restore


* Question 8-2: Acquisition exit of CVC-backed startups
* CVC-backed*
preserve
gen CVC=1 if Firm_Type=="Corporate PE/Venture"
keep if CVC==1
duplicates drop Com_Name, force 
count
gen CVC_backed=r(N)
keep if Com_Situation=="Acquisition"
count
gen CVC_acq=r(N)
gen cvc_acq_frac=CVC_acq/CVC_backed
list cvc_acq_frac in 1/1 
restore
//VC-backed
preserve
gen aa=0
replace aa=1 if (Firm_Type=="Corporate PE/Venture") & (Round_Number==1)
gen bb=0
replace bb=1 if (Firm_Type=="Private Equity Firm")
keep startup_id Com_Name Firm_Type Com_Situation Firm_Name Round_Number aa bb
egen zz = max(aa), by(Com_Name) //zz=1表示第1轮有cvc参与
egen yy= max(bb), by(Com_Name) //yy=1表示有VC参与
drop if zz==1
drop if yy==0
duplicates drop startup_id, force
count
gen VC_backed=r(N)
keep if Com_Situation=="Acquisition"
count
gen VC_acq=r(N)
gen vc_acq_frac=VC_acq/VC_backed
list vc_acq_frac in 1/1
restore



// log close _all
