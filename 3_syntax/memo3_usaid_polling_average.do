*********************************************************************************
/*	TITLE: 		Memo 3 -- 2025 polling on shutting down USAID
*	PURPOSE:	Poll-by-poll support and opposition to shutting down USAID across
*				the 2025 surveys in the Roper iPoll archive, with 95 percent
*				intervals and the across-poll average.
*	AUTHOR:		Calvin Pan
*	CREATED:	2026_1110
*	UPDATED: 	2026_1110
*	CALLS UPON:	"${rawdatapath}usaid_polls_2025.csv"
*	PRODUCES: 	Figures:	${tabsfigspath}memo3_usaid_polling_average.png and .pdf
*							${tabsfigspath}memo3_usaid_polling_average_bare.png
*				Tables: 	${tabsfigspath}memo3_usaid_polls_2025.csv
*	CONTENTS:	0: Set globals & start log file
* 				1: Open data
*				2: Confidence intervals and the across-poll average
*				3: Figure of support and opposition over time
*				4: Export the appendix table
*				5: Close log file
*/
*********************************************************************************

	clear all
	set more off


********
*
*	0. Set globals & start log file
*
********

	glob classpath		"/Users/calvin/Library/Mobile Documents/com~apple~CloudDocs/Documents/Calvin/UVA/2026-27/LPPP 6350 Politics/stata"

	glob rawdatapath	"${classpath}/2_raw_data/"
	glob logfilepath	"${classpath}/5_log_files/"
	glob tabsfigspath	"${classpath}/6_tabsfigs/"

	cd 	"${classpath}"

	capture log close
	log using "${logfilepath}memo3_usaid_polling_average_log", replace


********
*
*	1. Open data
*
********

	**Every 2025 iPoll survey that asked about shutting down USAID. Question
	**wording, toplines and the search that found them are in
	**"${rawdatapath}usaid_polls_2025_source.txt".
	import delimited using "${rawdatapath}usaid_polls_2025.csv", ///
		varnames(1) stringcols(2 3 4 5 12) clear

	list roper sponsor support oppose neither comparable, noobs abbreviate(12)

	**Midpoint of the field period, for plotting
	gen start = date(start_date, "YMD")
	gen end   = date(end_date, "YMD")
	gen fielded = round((start + end) / 2)
	format fielded %tdMon_dd

	label variable support	"Support"
	label variable oppose	"Oppose"


********
*
*	2. Confidence intervals and the across-poll average
*
********

	**95 percent intervals on the proportion, using the number of respondents
	**actually asked the item. These assume simple random sampling, so they are a
	**little narrower than the design-based intervals the pollsters publish.
	**max() and min() ignore missing, so the bounds are built only where there is
	**an estimate; otherwise the KFF row would come out as 0 to 100
	foreach v in support oppose {
		gen `v'_se = 100 * sqrt((`v'/100) * (1 - `v'/100) / asked_of)
		gen `v'_lo = max(`v' - 1.96 * `v'_se, 0) if !missing(`v')
		gen `v'_hi = min(`v' + 1.96 * `v'_se, 100) if !missing(`v')
	}

	**The KFF poll measured awareness only and carries no support or oppose
	**figure, so the average runs over the five polls that asked one
	quietly summarize support if comparable == 1
	glob mean_support = r(mean)
	glob n_polls      = r(N)

	quietly summarize oppose if comparable == 1
	glob mean_oppose = r(mean)

	di _n "Across-poll average over ${n_polls} polls:"
	di "  Support " %4.1f ${mean_support} "   Oppose " %4.1f ${mean_oppose} ///
		"   Net opposition " %4.1f (${mean_oppose} - ${mean_support})


********
*
*	3. Figure of support and opposition over time
*
********

	**Horizontal average lines are drawn as a two-point series so they span the
	**plotted window without hard-coding axis values
	quietly summarize fielded if comparable == 1
	glob first_poll = r(min) - 5
	glob last_poll  = r(max) + 5

	**Two versions of the same plot: "full" carries its own title and note and
	**stands alone, "bare" is for documents that typeset their own caption
	foreach version in full bare {

		local thetitle ""
		local thenote  ""

		if "`version'" == "full" {
			local thetitle `"title("Opposition to shutting down USAID ran ahead of support" "in every 2025 poll", size(medsmall) span)"'
			local thenote  `"note("Each point is one national poll, with a 95 percent interval based on the number of respondents asked" "the item; these assume simple random sampling and so are slightly narrower than the intervals the" "pollsters publish. Dashed lines are the unweighted average across the ${n_polls} polls. Wording" "differs: CNN asks whether shutting down agencies such as USAID and the CFPB is a good or bad thing," "and the Washington Post describes the agency rather than naming it. A sixth 2025 poll, KFF's February" "Health Tracking Poll, measured awareness only and is not plotted." "Source: Roper iPoll, studies #31122394, #31122387, #31122388, #31122408 and #31122581.", size(vsmall) span)"'
		}

		twoway	(function y = ${mean_oppose}, range(${first_poll} ${last_poll})		///
					lcolor("178 24 43") lpattern(dash) lwidth(medthin))				///
				(function y = ${mean_support}, range(${first_poll} ${last_poll})	///
					lcolor("33 102 172") lpattern(dash) lwidth(medthin))			///
				(rcap oppose_lo oppose_hi fielded if comparable == 1,				///
					lcolor("178 24 43") lwidth(medthin) msize(small))				///
				(scatter oppose fielded if comparable == 1,							///
					mcolor("178 24 43") msymbol(O) msize(medium))					///
				(rcap support_lo support_hi fielded if comparable == 1,				///
					lcolor("33 102 172") lwidth(medthin) msize(small))				///
				(scatter support fielded if comparable == 1,						///
					mcolor("33 102 172") msymbol(O) msize(medium)),					///
			ytitle("Percent of respondents", size(small))							///
			ylabel(0(10)70, angle(0) labsize(vsmall) grid glcolor(gs14))			///
			yscale(range(0 70))														///
			xtitle("")																///
			xlabel(${first_poll}(14)${last_poll}, format(%tdMon_dd) labsize(vsmall))	///
			`thetitle'																///
			`thenote'																///
			legend(order(4 "Oppose" 6 "Support" 1 "Average opposition" 2 "Average support")	///
				rows(1) size(vsmall) pos(6) ring(1) region(lstyle(none))			///
				symxsize(5) symysize(3))											///
			graphregion(color(white)) plotregion(color(white))						///
			xsize(9) ysize(5.5)														///
			name(polling_`version', replace)

		if "`version'" == "full" {
			graph export "${tabsfigspath}memo3_usaid_polling_average.png", width(2400) replace
			graph export "${tabsfigspath}memo3_usaid_polling_average.pdf", replace
		}
		else {
			graph export "${tabsfigspath}memo3_usaid_polling_average_bare.png", width(2400) replace
		}
	}


********
*
*	4. Export the appendix table
*
********

	keep roper sponsor organization start_date end_date sample_size asked_of	///
		support support_lo support_hi oppose oppose_lo oppose_hi neither	///
		comparable
	order roper sponsor organization start_date end_date sample_size asked_of	///
		support support_lo support_hi oppose oppose_lo oppose_hi neither	///
		comparable

	format support_lo support_hi oppose_lo oppose_hi %5.1f

	list sponsor start_date support oppose neither, noobs abbreviate(12)

	export delimited using "${tabsfigspath}memo3_usaid_polls_2025.csv", replace


********
*
*	5. Close log file
*
********

	log close

	translate 	"${logfilepath}memo3_usaid_polling_average_log.smcl" ///
				"${logfilepath}memo3_usaid_polling_average_log.pdf", replace
