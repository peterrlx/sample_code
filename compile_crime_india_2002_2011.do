
*** This file compiles crime data in India from 2002-2011(district-year panel).

*** raw data example: https://data.gov.in/catalog/crime-india-2002


clear all
set more off

global path = "E:/RA file/crime_in_India"

cd "$path\raw_data"

*** ==============================
*** import and clean raw data ***
*** ==============================

 forvalues i = 2002(1)2011 {
 	
  import excel "crime_dist_`i'.xls", firstrow clear
  
  gen year = `i'
  
  order year, first
  
  * adjust state or district names
  
  if year==2009{
  	rename StatesUTsDistrict District
  }
  
  if year==2010{
  	rename Districts District
  }
  
  drop if District == "Total"
  
  drop if District == "Grand Total"
  
  drop if District == "All-India"
  
  drop if District == "Total(All-India)"
  
  drop if District == "Total (All-India)"
  
  drop if District == "Total (All- India)"
  
  drop if District == "(All-India)"
  
  drop if District == "Total (All India)"
  
  if year==2007|year==2009|year==2010{
  	drop Category
  }
  
  
  * correct some variables in case errors should occur
  
  // Serial number correction
  
  // let state names be consistent with each other
   
   if year==2002 | year==2003{
	rename StatesUT States
  }
   if year>2003 & year<2006{
   	rename StatesUTs States
   }
   
   if year==2006{
   	rename StateUTAllIndia States
   }
   
   if year==2007|year==2008|year==2010|year==2011{
   	rename StatesUTs States
   }
   
   if year==2009{
  	rename SubCategory States
  }
  
  // adjust some incorrect variable names
  
  ** Attempt to Commit Murder 
  if year==2002|year==2003|year==2005{
  rename CHnotAmountingtoMurder CHNotAmountingtoMurder
  }
  
  if year==2006|year==2007|year==2011{
  	rename CHnotAmountingtoMurderSe CHNotAmountingtoMurder
  }
  
  if year==2008{
  	rename CHNotAmountingtoMurderSe CHNotAmountingtoMurder
  }
  
  if year==2009{
  	rename ChNotAmountingtoMurderSe CHNotAmountingtoMurder
  }
  
  if year==2010{
  	rename ChNotAmountingMurderSec3 CHNotAmountingtoMurder
  }
  
 
   
   if year==2006 |year==2007|year==2011{
   	rename AttempttoCommitMurderSec30 AttempttoCommitMurder
   }
   
   if year==2008{
   	rename AttemptToCommitMurderSec30 AttempttoCommitMurder
   }
   
   if year==2009|year==2010{
   	rename AttempttoCommitMurderSec3 AttempttoCommitMurder
   }

  
  ** murder
  drop if Murder == . 
  
  if year==2006 |year==2007|year==2008{
  rename MurderSec302303IPC Murder
  }
  
  if year==2009|year==2010|year==2011{
  rename MurderSec302IPC Murder
  }

   
  ** Rape
  if year<2006{
  rename RapeTotal Rape
  }
  
  if year==2006|year==2007|year==2008|year==2009|year==2010|year==2011{
  	rename RapeSec376IPCTotal Rape
	rename RapeSec376IPCCustodial RapeCustodial
	rename RapeSec376IPCOther RapeOther
  }
  
  ** kidnapping
    
    if year<2006{
	rename KidnappingAbductionofWome KidnappingAbductionOfWomen
	rename KidnappingAbductionOthers KidnappingAbductionOfOthers
	}
	
	if year==2006|year==2008{
	rename KidnappingAbductionSec363 KidnappingAbductionTotal
	rename J KidnappingAbductionOfWomen
	rename K KidnappingAbductionOfOthers
	}
	
	if year==2007|year==2011{
	rename KidnappingAbductionSec363 KidnappingAbductionTotal
	rename K KidnappingAbductionOfWomen
	rename L KidnappingAbductionOfOthers
	}
	
	if year==2009|year==2010{
	rename KidnappingAbductionSec363 KidnappingAbductionTotal
	rename L KidnappingAbductionOfWomen
	rename M KidnappingAbductionOfOthers
	}
	

	
  ** Dacoity
  if year==2006|year==2007|year==2008|year==2009|year==2011{
  rename DacoitySec395to398IPC Dacoity
   }
   
   if year==2010{
   	rename DacoitySec395398IPC Dacoity
   }
  
  ** Preparation & Assembly for Dacoity
    
  rename PreparationAssemblyforDacoi PreparationandAssemblyforDac
  
  if year==2006{
  	rename PreparationandAssemblyforDac PreparationandAssemblyforDac
	replace PreparationandAssemblyforDac="-999" if PreparationandAssemblyforDac=="NA"
	destring PreparationandAssemblyforDac, replace
  }
  
  ** robbery
  if year==2006|year==2007{
  	rename RobberySec3923943973 Robbery
	replace Robbery="-999" if Robbery=="NA"
	destring Robbery, replace
  }
  
  if year==2008|year==2011{
  	rename RobberySec3923943973 Robbery
  }
  
  if year==2009{
  	rename RobberySec392394397398 Robbery
  }
  
  if year==2010{
  	rename RobberySec392394397398IP Robbery
  }
  
  ** Burglary
   if year==2006|year==2007|year==2008|year==2011{
  	rename BurglarySec4494524544 Burglary
  }
  
   if year==2009|year==2010{
   	rename BurglarySec44945245445545 Burglary
   }
   
 
  
 
    
  ** theft
  if year<2006{
  rename TheftTotal Theft
  }
  
  if year==2006|year==2007|year==2008|year==2009|year==2010|year==2011{
	rename TheftSec379382IPCTota Theft
  }
  
  if year==2002|year==2003|year==2004{
  rename TheftAutotheft TheftAutoTheft
  rename TheftOthertheft TheftOtherTheft
  }
  
  if year==2005{
	rename Autotheft TheftAutoTheft
	rename Othertheft TheftOtherTheft
  }
  
  if year==2006|year==2007|year==2008|year==2009|year==2010|year==2011{
	rename TheftSec379382IPCAuto TheftAutoTheft
	rename TheftSec379382IPCOthe TheftOtherTheft
  }
  ** Riots
  if year==2006|year==2007|year==2008{
	rename RiotsSec143145147151 Riots
  }
  
  if year==2009|year==2010{
	rename RiotsSec143145147151153 Riots
  }
  
  if year==2011{
	rename RiotsSec14314514715115 Riots
  }
  
  ** Criminal Breach of Trust
  if year==2006|year==2007|year==2008|year==2011{
	rename CriminalBreachofTrustSec4 CriminalBreachofTrust
  }
  
  if year==2009|year==2010{
	rename CriminalBreachofTrustSec40 CriminalBreachofTrust
  }
  
  ** Cheating
  if year==2006|year==2007|year==2008|year==2009|year==2010|year==2011{
  rename CheatingSec419420IPC Cheating
  }
  
  ** Counterfeiting
  if year==2006{
  rename CounterFeitingSec231254489 Counterfeiting
  }
  
  if year==2007|year==2011{
  rename CounterFeitingSec23125448 Counterfeiting
  }
  
   if year==2008{
  rename CounterFeitingSec231254 Counterfeiting
  }
  
   if year==2009|year==2010{
  rename CounterfeitingSec231254489 Counterfeiting
  }
  
   ** Arson
  if year ==2005{
	replace Arson ="-999" if Arson =="KABIRNAGAR"
	destring Arson , replace
  }
  
  if year==2006|year==2007|year==2008|year==2009|year==2010|year==2011{
	rename ArsonSec435436438IPC Arson
  }
  
  
   ** Hurt/Grievous Hurt
   
	rename Hurt HurtGrievousHurt

  
   ** Dowry Death
   if year==2006|year==2007|year==2008|year==2011{
    rename DowryDeathSec304BIPC DowryDeath
   }
   
   if year==2009|year==2010{
    rename  DowryDeathsSec304BIPC DowryDeath
   }


   ** Molestation
   if year==2006|year==2007|year==2008|year==2009|year==2010|year==2011{
    rename MolestationSec354IPC Molestation
   }
  
   ** Sexual Harassment
   if year==2006|year==2007|year==2008|year==2009|year==2010|year==2011{
   	rename SexualHarassmentSec509IPC SexualHarassment
   }
    
  
    ** Cruelty by Husband and Relatives 
	if year==2006|year==2007|year==2008{
   	rename CrueltybyHusbandRelatives CrueltybyHusbandandRelatives
   }
   
    if year==2011{
		rename CrueltybyHusbandRelatives CrueltybyHusbandandRelatives
	}
    
  
    ** Others IPC Crimes
    if year<2006|year==2009|year==2010{
  	rename OtherIPCCrimes OthersIPCCrimes
    }
	
	if year==2006|year==2007|year==2008|year==2011{
	rename OtherIPCCrime OthersIPCCrimes
	}
	
  
    ** Total Cognizable Crimes Under IPC
	if year<2006{
	rename TotalCogCrimesUnderIPC TotalCogUnderIPC
	}
	
	if year==2006|year==2007|year==2008|year==2011{
	rename TotalCogCrimeUnderIPC TotalCogUnderIPC
	}
	
	if year==2009|year==2010{
		rename TotalCognizableCrimesUnderIP TotalCogUnderIPC
	}
	
	** Importation of Girls
	if year==2006|year==2007|year==2008|year==2011{
	 rename ImportationofGirlsSec366B ImportationofGirls
	}
	
	if year==2009{
	 rename ImportationofGirlsSec366BI ImportationofGirls
	}
	
	if year==2010{
	  rename ImportationOfGirlsSec366BI ImportationofGirls
	}
    
	** Causing Death by Negligence
	if year==2006|year==2007|year==2008|year==2011{
	rename CausingDeathbyNegligenceSec CausingDeathbyNegligence
	}
	
	if year==2009|year==2010{
	rename CausingDeathByNegligenceSec CausingDeathbyNegligence
	}
	
	
  * save yearly datasets
  
  save "$path\raw_data\crime_dist_`i'.dta", replace
  
  display `i'
  
  describe
  local no_vars = `r(k)'
  di "`no_vars'"
  
}


*** ==============================
*** append data for different years ***
*** ==============================

use crime_dist_india_1990_2000_temp.dta

forvalues i = 2002(1)2011 {
	append using crime_dist_`i'.dta, force
}

//describe




*** ==============================
*** save the panel dataset ***
*** ==============================
drop SLNo
drop SrNo
drop SINo




save "crime_dist_india_1990_2011_temp.dta", replace

erase "crime_dist_india_1990_2000_temp.dta"

forvalues i = 1990(1)2000 {
  erase  "crime_dist_`i'.dta"
}

forvalues i = 2002(1)2011 {
  erase  "crime_dist_`i'.dta"
}



