*! version 0.0  28aug2020  Liyang Sun, lsun20@mit.edu

program define eventstudyweights, eclass sortpreserve
	version 13 
	syntax varlist(min=1 numeric) [if] [in] [aweight fweight], [cohort(varname) ///
		rel_time(varname) ///
		CONTROLs(varlist numeric ts fv)  saveweights(string)  ///
		*]
	set more off
	
	* Mark sample (reflects the if/in conditions, and includes only nonmissing observations)
	marksample touse
	markout `touse' `by' `xq' `controls' `absorb', strok
	* Prepare the list of relative time indicators for partialling out
	local nvarlist ""
	foreach l of local varlist {
		local nvarlist "`nvarlist' n`l'"
	}
// 	dis "`nvarlist'"
	capture drop  `nvarlist'
	capture hdfe, version 
	if _rc != 0 {
		di as err "Error: must have hdfe installed"
		di as err "To install, from within Stata type " _c
		di in smcl "{stata ssc install hdfe :ssc install hdfe}"
					exit 601
	}
	hdfe  `varlist' `wt' if `touse', absorb(`controls') generate(n)
	* Initiate empty matrix for weights
	tempname bb bb_w

	levelsof `cohort', local(cohort_list) 
	levelsof `rel_time', local(rel_time_list) 
	* Loop over cohort and relative times
	foreach yy of local cohort_list {
		foreach rr of local rel_time_list { 
		tempvar catt
			qui count if `cohort' == `yy' & `rel_time' == `rr'
			if r(N) >0 {
				gen `catt'  = (`cohort' == `yy') * (`rel_time' == `rr')
				qui regress `catt'   `nvarlist'  `wt' if `touse', nocons
				mat `bb_w' = e(b)
				mat `bb_w' = `yy', `rr', `bb_w'
				matrix `bb'  = nullmat(`bb') \ `bb_w'
			}
		}
	}
	capture drop  `nvarlist'

 	matrix colnames `bb' = "`cohort'" "`rel_time'" `varlist'

// 	mat list `bb'
	putexcel set `saveweights', replace
	putexcel A1=matrix(`bb', colnames) using `saveweights',replace
end

 
