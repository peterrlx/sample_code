* This file cleans and appends stock daily return data for all A shares in China since 1990 and then match it with firm-level confidential data. 
* some variable names are renamed as "XXX" due to confidential data issue.

cls
clear all
set more off 

global PATH "F:\RA_file_2\stock_day_data"
cd $PATH



// Note: 1=Shanghai A股市场 (不包含科创板），2=Shanghai B股市场，4=Shenzhen A股市场（不包含创业板），8=Shenzhen B股市场，16=创业板， 32=科创板，64=Beijing A股市场

* ===================================================
* extract stock return variable from raw files
* ===================================================


// 1990-1993
cd "$PATH\1990_1993"
use TRD_Dalyr
gen vol_day = (Hiprc - Loprc)*100/Loprc
keep Stkcd Trddt Dretnd vol_day Markettype ChangeRatio Dsmvtll
cd $PATH
save stk_1990_1993, replace

// 1994-1998
cd "$PATH\1994_1998"
use TRD_Dalyr
gen vol_day = (Hiprc - Loprc)*100/Loprc
keep Stkcd Trddt Dretnd vol_day Markettype ChangeRatio Dsmvtll
cd $PATH
save stk_1994_1998, replace

// 1999-2003
cd "$PATH\1999_2003"
use TRD_Dalyr

forvalues i = 1(1)1 {
  append using TRD_Dalyr`i', force
}

gen vol_day = (Hiprc - Loprc)*100/Loprc
keep Stkcd Trddt Dretnd vol_day Markettype ChangeRatio Dsmvtll
cd $PATH
save stk_1999_2003, replace

// 2004-2008
cd "$PATH\2004_2008"
use TRD_Dalyr

forvalues i = 1(1)1 {
  append using TRD_Dalyr`i', force
}

gen vol_day = (Hiprc - Loprc)*100/Loprc
keep Stkcd Trddt Dretnd vol_day Markettype ChangeRatio Dsmvtll
cd $PATH
save stk_2004_2008, replace

// 2009-2013
cd "$PATH\2009_2013"
use TRD_Dalyr

forvalues i = 1(1)2 {
  append using TRD_Dalyr`i', force
}

gen vol_day = (Hiprc - Loprc)*100/Loprc
keep Stkcd Trddt Dretnd vol_day Markettype ChangeRatio Dsmvtll
cd $PATH
save stk_2009_2013, replace



// 2014-2018
cd "$PATH\2014_2018"
use TRD_Dalyr

forvalues i = 1(1)3 {
  append using TRD_Dalyr`i', force
}

gen vol_day = (Hiprc - Loprc)*100/Loprc
keep Stkcd Trddt Dretnd vol_day Markettype ChangeRatio Dsmvtll
cd $PATH
save stk_2014_2018, replace

// 2019-2023
cd "$PATH\2019_2023"
use TRD_Dalyr


forvalues i = 1(1)5 {
  append using TRD_Dalyr`i', force
}

gen vol_day = (Hiprc - Loprc)*100/Loprc
keep Stkcd Trddt Dretnd vol_day Markettype ChangeRatio Dsmvtll
cd $PATH
save stk_2019_2023, replace


* ===================================================
* append 1990-2023 stock return
* ===================================================
cd $PATH

use stk_1990_1993


append using stk_1994_1998, force

append using stk_1999_2003, force

append using stk_2004_2008, force

append using stk_2009_2013, force

append using stk_2014_2018, force

append using stk_2019_2023, force


save stk_1990_2023, replace

erase stk_1990_1993.dta
erase stk_1994_1998.dta 
erase stk_1999_2003.dta
erase stk_2004_2008.dta
erase stk_2009_2013.dta
erase stk_2014_2018.dta
erase stk_2019_2023.dta


* ===================================================
* merge with firm names
* ===================================================

cd "$PATH\A_share_firm_name"
merge m:1 Stkcd using "HLD_Copro.dta"

drop if _merge==2
drop _merge


* ===================================================
* adjust date format
* ===================================================
gen date = date(Trddt,"YMD")

format date %td

encode Stkcd, gen(stock_id)


gen year = year(date)
gen month = month(date)
gen day = day(date)


* ===================================================
* adjust time priod and stock market type
* ===================================================

* 1990-12-19 < time < 2020-8-28
// drop if year>2020
// drop if year==2020 & month>8
// drop if year==2020 & month==8 & day>28

sort date

* only keep 上证A股市场+深证A股市场+创业板+科创板
keep if Markettype==1 | Markettype==4 |Markettype==16 |Markettype==32

cd ..
save stk_1990_2023, replace


* ===================================================
* create_trade_day---创建Business calendar(股票交易日)
* ===================================================
preserve

cls
clear all
set more off 

global PATH "F:\RA_file_2\stock_day_data"
cd $PATH

use stk_1990_2023

sort date

duplicates drop date, force

keep date


gen weekday = dow(date)


bcal create tradeday, from(date) maxgap(100) dateformat(dmy) replace
//创建一个stbcal文件。里面可以看到省略了哪些日期

gen bcaldate = bofd("tradeday",date) //查看当前日期是日历中的第X天，1990-12-19为第零天

format bcaldate %tbtradeday

assert bcaldate!=. if date!=. // make sure the mapping from tbday to tbcalendar is one-to-one.


gen id= _n

save trade_day, replace


restore



* ===================================================
* create_trade_day
* ===================================================
use stk_1990_2023
merge m:1 date using trade_day
drop _merge

save stk_1990_2023, replace


xtset stock_id date // check panel
// duplicates drop Stkcd, force

* ===================================================
* summary statistics
* ===================================================
// gen return = ChangeRatio*100
//
// //ssc install winsor2, replace
// gen return_winsor = return
// winsor2 return_winsor, replace cuts(1 99)
// tabstat return return_winsor, stat(mean sd p1 p5 p10 p25 p50 p75 p90 p95 p99 n) f(%9.2f)


cls
clear all
set more off 

global PATH "F:\RA_file_2"
cd $PATH



* ===================================================
* match with firm names
* ===================================================



cd "$PATH\XXX" // rename file path due to confidential data issue



use listedfirm_pat_tora

merge m:m firmname_wx1 using listedfirmname

drop if _merge == 2  // drop unmatched values from "listedfirmname.dta"

drop _merge


// drop XXX date that is not trade day
rename XX_date date
cd "$PATH\stock_day_data"
merge m:1 date using trade_day
keep if _merge == 3
drop _merge weekday
rename date XX_date

// gen pre and post variables

gen XXXdate_post1= bcaldate + 1
format XXXdate_post1 %tbtradeday

gen XXXdate_post2 = bcaldate + 2
format XXXdate_post2 %tbtradeday

gen XXXdate_post3 = bcaldate + 3
format XXXdate_post3 %tbtradeday

gen XXXdate_post4 = bcaldate + 4
format XXXdate_post4 %tbtradeday

gen XXXdate_pre1 = bcaldate - 1
format XXXdate_pre1 %tbtradeday

// gen XXXdate_pre1 = XXXdate - 1
// format XXXdate_pre1 %td

gen XXXdate_pre2 = bcaldate- 2
format XXXdate_pre2 %tbtradeday

cd "$PATH\XX_data"
save XX_day, replace


* ===================================================
*  create XXXX date dummy for each firm [confidential data]
* ===================================================
clear all 

cd "$PATH\stock_day_data"
use stk_1990_2023

// prepare for the merge
gen date2= date
format date2 %td

rename date XX_date
rename Stkcd stkcd
//rename Conme firmname
rename date2 date

cd "$PATH\XXX"
merge m:m stkcd XX_date using XX_day


drop if _merge == 2 // drop those XXX days when stocks are not traded (e.g., 2019-2-5 is Chinese Spring festival), or the firm is not listed on XXX, or the firm XXX is B-share firm, or there is no stock return data on that XXX
gen XXX_dummy = 1 if _merge == 3 
replace XXX_dummy = 0 if _merge == 1 // _merge == 1 are trading days when there is no XXX

drop appid firmname appdate pubdate firmname_wx1 _merge XX_date XXXdate_post1 XXXdate_post2 XXXdate_post3 XXXdate_pre1

duplicates tag stkcd date, generate(dup_XX_tag) 
duplicates drop stkcd date, force // Some companies have multiple XXX on one day. So there are repeated values.

keep stkcd stock_id dateXXX_dummy


save fd_XX_temp, replace




* ===================================================
*  create XXX post_1 date dummy for each firm
* ===================================================
clear all
cd "$PATH\stock_day_data"
use stk_1990_2023

gen XXXdate_post1 = bcaldate
format XXXdate_post1 %tbtradeday

rename Stkcd stkcd

cd "$PATH\XX_data"

merge m:m stkcd XXXdate_post1 using XX_day


drop if _merge == 2

genXXX_post1_dummy = 1 if _merge == 3 
replaceXXX_post1_dummy = 0 if _merge == 1

drop appid firmname appdate XX_date firmname_wx1 _merge pubdate XXXdate_post1 XXXdate_post2 XXXdate_post3 XXXdate_pre1


duplicates drop stkcd date, force


keep stkcd stock_id dateXXX_post1_dummy

save fd_XX_temp_post1, replace


* ===================================================
*  create XXX post_2 date dummy for each firm
* ===================================================
clear all
cd "$PATH\stock_day_data"
use stk_1990_2023

gen XXXdate_post2 = bcaldate
format XXXdate_post2 %tbtradeday

rename Stkcd stkcd

cd "$PATH\XX_data"

merge m:m stkcd XXXdate_post2 using XX_day


drop if _merge == 2

gen XXX_post2_dummy = 1 if _merge == 3 
replace XX_XX_post2_dummy = 0 if _merge == 1

drop appid firmname appdate XX_date firmname_wx1 _merge pubdate XXXdate_post1 XXXdate_post2 XXXdate_post3 XXXdate_pre1


duplicates drop stkcd date, force


keep stkcd stock_id date XX_XX_post2_dummy

save fd_XX_temp_post2, replace

* ===================================================
*  create XXX post_3 date dummy for each firm
* ===================================================
clear all
cd "$PATH\stock_day_data"
use stk_1990_2023

gen XXXdate_post3 = bcaldate
format XXXdate_post3 %tbtradeday

rename Stkcd stkcd

cd "$PATH\XX_data"

merge m:m stkcd XXXdate_post3 using XX_day


drop if _merge == 2

gen XX_XX_post3_dummy = 1 if _merge == 3 
replace XX_XX_post3_dummy = 0 if _merge == 1

drop appid firmname appdate XX_date firmname_wx1 _merge pubdate XXXdate_post1 XXXdate_post2 XXXdate_post3 XXXdate_pre1


duplicates drop stkcd date, force


keep stkcd stock_id date XX_XX_post3_dummy

save fd_XX_temp_post3, replace

* ===================================================
*  create XXX post_4 date dummy for each firm
* ===================================================
clear all
cd "$PATH\stock_day_data"
use stk_1990_2023

gen XXXdate_post4 = bcaldate
format XXXdate_post4 %tbtradeday

rename Stkcd stkcd

cd "$PATH\XX_data"

merge m:m stkcd XXXdate_post4 using XX_day


drop if _merge == 2

gen XX_XX_post4_dummy = 1 if _merge == 3 
replace XX_XX_post4_dummy = 0 if _merge == 1

drop appid firmname appdate XX_date firmname_wx1 _merge pubdate XXXdate_post1 XXXdate_post2 XXXdate_post3 XXXdate_pre1


duplicates drop stkcd date, force


keep stkcd stock_id date XX_XX_post4_dummy

save fd_XX_temp_post4, replace

* ===================================================
*  create XXX pre_1 date dummy for each firm
* ===================================================
clear all
cd "$PATH\stock_day_data"
use stk_1990_2023

gen XXXdate_pre1 = bcaldate
format XXXdate_pre1 %tbtradeday

// gen XXXdate_pre1 = date
// format XXXdate_pre1 %td

rename Stkcd stkcd

cd "$PATH\XX_data"

merge m:m stkcd XXXdate_pre1 using XX_day


drop if _merge == 2

gen XX_XX_pre1_dummy = 1 if _merge == 3 
replace XX_XX_pre1_dummy = 0 if _merge == 1

drop appid firmname appdate XX_date firmname_wx1 _merge pubdate XXXdate_post1 XXXdate_post2 XXXdate_post3 XXXdate_pre1


duplicates drop stkcd date, force


keep stkcd stock_id date XX_XX_pre1_dummy

save fd_XX_temp_pre1, replace

* ===================================================
*  create XXX pre_2 date dummy for each firm
* ===================================================
clear all
cd "$PATH\stock_day_data"
use stk_1990_2023

gen XXXdate_pre2 = bcaldate
format XXXdate_pre2 %tbtradeday

rename Stkcd stkcd

cd "$PATH\XX_data"

merge m:m stkcd XXXdate_pre2 using XX_day


drop if _merge == 2

gen XX_XX_pre2_dummy = 1 if _merge == 3 
replace XX_XX_pre2_dummy = 0 if _merge == 1

drop appid firmname appdate XX_date firmname_wx1 _merge pubdate XXXdate_post1 XXXdate_post2 XXXdate_post3 XXXdate_pre1 XXXdate_pre2 


duplicates drop stkcd date, force


keep stkcd stock_id date XX_XX_pre2_dummy

save fd_XX_temp_pre2, replace




* ===================================================
*  merge XX publication dummies for pre and post
* ===================================================
clear all
cd "$PATH\XX_data"

use fd_XX_temp
merge 1:1 stkcd date using  fd_XX_temp_pre1
drop _merge

merge 1:1 stkcd date using  fd_XX_temp_post1
drop _merge

merge 1:1 stkcd date using  fd_XX_temp_post2
drop _merge

merge 1:1 stkcd date using  fd_XX_temp_post3
drop _merge

merge 1:1 stkcd date using  fd_XX_temp_post4
drop _merge

merge 1:1 stkcd date using  fd_XX_temp_pre2
drop _merge

save fd_XX_dummy, replace


* ===================================================
*  merge XX_pre_post dummies with stock price volatility and return
* ===================================================
clear all
cd "$PATH\stock_day_data"

use stk_1990_2023
rename Stkcd stkcd

cd "$PATH\XX_data"
merge 1:1 stkcd date using fd_XX_dummy

drop _merge

rename weekday day_of_week




cd ..
save final_validity_reg_temp.dta, replace

* ===================================================
*  create lagged-one-day stock return data
* ===================================================
/*
clear all
cd "$PATH\stock_day_data"

use stk_1990_2023
gen lag1_day = bcaldate-1
format lag1_day %tbtradeday
//drop if lag1_day == -1

keep Stkcd stock_id bcaldate lag1_day

rename bcaldate orig_day



sort Stkcd lag1_day

//匹配上一期的波动率
rename lag1_day bcaldate
merge 1:m Stkcd bcaldate using stk_1990_2023
rename bcaldate lag1_day

rename vol_day lag1_vol_day

// 如果某公司这一天还是没有交易数据，再减一天
gen blank_day = 1 if _merge == 1
replace blank_day = 0 if blank_day == .

drop if orig_day == .



keep Stkcd stock_id orig_day lag1_day blank_day

//step1将有空缺值的日期向前推一个交易日

gen lag1_day2 = lag1_day-1 if blank_day == 1
replace lag1_day2 = lag1_day if blank_day == 0
format lag1_day2 %tbtradeday

drop lag1_day blank_day

save lag1_day_vol_temp, replace

//step2再次匹配上一期的波动率, 发现缺失值减少
rename lag1_day2 bcaldate
merge 1:m Stkcd bcaldate using stk_1990_2023
rename bcaldate lag1_day

rename vol_day lag1_vol_day

gen blank_day = 1 if _merge == 1
replace blank_day = 0 if blank_day == .

drop if orig_day == .


keep Stkcd stock_id orig_day lag1_day blank_day

//不断重复上述的step1,step2直到缺失值消失
forvalues i = 3(1)6 {
	gen lag1_day`i' = lag1_day-1 if blank_day == 1
	replace lag1_day`i' = lag1_day if blank_day == 0
	format lag1_day`i' %tbtradeday

	drop lag1_day blank_day

	save lag1_day_vol_temp, replace

	rename lag1_day`i' bcaldate
	merge 1:m Stkcd bcaldate using stk_1990_2023
	rename bcaldate lag1_day
	
	rename vol_day lag1_vol_day

	gen blank_day = 1 if _merge == 1
	replace blank_day = 0 if blank_day == .

	drop if orig_day == .

	keep Stkcd stock_id orig_day lag1_day blank_day
}

// 最后一次重复保留lag1_vol_day
gen lag1_day7 = lag1_day-1 if blank_day == 1
replace lag1_day7 = lag1_day if blank_day == 0
format lag1_day7 %tbtradeday

drop lag1_day blank_day

save lag1_day_vol_temp, replace

rename lag1_day7 bcaldate
merge 1:m Stkcd bcaldate using stk_1990_2023
rename bcaldate lag1_day

rename vol_day lag1_vol_day

gen blank_day = 1 if _merge == 1
replace blank_day = 0 if blank_day == .

drop if orig_day == .

keep Stkcd stock_id orig_day lag1_day blank_day lag1_vol_day


// 替换缺失值为0
replace lag1_vol_day = 0 if blank_day == 1 

//生成lag1_return数据
rename orig_day bcaldate
rename Stkcd stkcd
cd ..
save lag1_day_vol, replace

* ===================================================
*  create final data for regression
* ===================================================
merge 1:1 stkcd bcaldate using final_validity_reg_temp
drop _merge

*/

save validity_reg, replace

* ===================================================
*  erase temp datasets
* ===================================================
// erase final_validity_reg_temp.dta
// erase lag1_day_vol.dta
//
// cd "$PATH\XX_data"
// erase fd_pub_temp.dta
// erase fd_pub_temp_post1.dta
// erase fd_pub_temp_post2.dta
// erase fd_pub_temp_post3.dta
// erase fd_pub_temp_post4.dta
// erase fd_pub_temp_pre1.dta


cls
clear all
set more off
set maxvar 120000


global PATH "F:\RA_file_2"
cd $PATH



* ===================================================
* use the merged dataset to do regression
* ===================================================
// package needed: reghdfe, coefplot.

use validity_reg



global XX_dummy "XX_XX_pre1_dummy XX_XX_dummy XX_XX_post1_dummy XX_XX_post2_dummy XX_XX_post3_dummy"

egen firm_year=group(year stock_id)


tabstat vol_day, stat(min max mean p25 p50 p99 sd n)


// drop if year>2020
// drop if year==2020 & month>8
// drop if year==2020 & month==8 & day>28

// keep if Markettype==1 | Markettype==4


// gen vol_day_winsor = vol_day
// winsor2 vol_day_winsor, replace cuts(1 99)
// drop vol_day
// rename vol_day_winsor vol_day

xtset stock_id date

* ===================================================
* regression
* ===================================================
// reghdfe vol_day $XX_dummy l.vol_day, absorb(firm_year i.day_of_week) level(90) vce(cluster firm_year)

// reghdfe vol_day $XX_dummy l.vol_day i.day_of_week, absorb(firm_year) level(99) vce(cluster firm_year)

// reghdfe vol_day $XX_dummy l.l.vol_day i.day_of_week, absorb(firm_year) level(99) vce(cluster firm_year)

reghdfe vol_day $XX_dummy l.vol_day l.l.vol_day i.day_of_week, absorb(firm_year) level(99) vce(cluster firm_year)


* ===================================================
* plot the graph
* ===================================================
coefplot, ///
	xtitle("days around XX issuance (XX XX day)") ///
	ytitle("intraday volatility (%)") ///
	legend(off) ///
	yline(0) ///
	xline(2,lpattern(dash) lcolor(black))   ///
	recast(connected)  ///
	ciopts(recast(rarea)  ///
	color(gs12%70)  ///
	lwidth(0))  ///
	keep($XX_dummy)  ///
	vert  ///
	scheme(s1color)   ///
	lcolor(black)  ///
	lwidth(0.7) ///
	msymbol(D)  ///
	mfcolor(black)  ///
	mlcolor(black)  ///
	msize(large) ///
	ylabel(-0.06(0.02)0.1,angle(0) format(%9.2f) tposition(inside))  ///
	yscale(range(-0.06(0.02)0.1))  ///
	coeflabels(XX_XX_pre1_dummy = "-1" XX_XX_dummy = "0" XX_XX_post1_dummy="1" XX_XX_post2_dummy = "2" XX_XX_post3_dummy = "3") ///
	levels(99) 


graph export validity_plot.eps, as(eps) replace
graph export validity_plot.png, as(png) replace
