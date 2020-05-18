set more off
log using US_county_poverty.log, replace
* Covid-19 program
* April 2020
* Proportion of people below poverty line
* Jiaolong He

import delim using "C:\Users\Administrator\Dropbox\HPC_data_hub\Phase 2 data release\Prepandemic\raw data\ACS_Percent_People_Below_Poverty.csv",clear
d
sum
* name 
rename state stname
la var stname "State name"

rename fipsstatecountycode fipsc
tostring fipsc,gen(fipscc)
gen a="0"
egen fips=concat(a fipscc) if fipsc < 10000
replace fips=fipscc if fips==""
drop a fipsc fipscc fipsstatecode fipscountycode
la var fips "FIPS code of state-county"

gen stfips=substr(fips,1,2)
la var stfips "State FIPS code"

gen ctyfips=substr(fips,3,3)
la var ctyfips "County FIPS code"

drop totalpopulation populationpersquarekilometerpopu percentageoffamiliesandpeoplewho 
rename v8 oldprop
replace oldprop="" if oldprop=="-888,888,888.00"
destring oldprop,replace
replace oldprop=oldprop/100
la var  oldprop "Prop. of old(65+) people below the poverty line based on ACS(2014-18)"

rename percentageofpeoplewhoseincomeint povprop
replace povprop="" if povprop=="-888,888,888.00"
destring povprop,replace
replace povprop=povprop/100
la var povprop "Prop. of people below the poverty line based on ACS(2014-18)"

order stname stfips ctyfips fips oldprop povprop
compress
d
sum

save US_county_poverty,replace
export exc using US_county_poverty.xlsx, first(var) replace
log close
