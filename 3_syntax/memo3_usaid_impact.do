*********************************************************************************
/*	TITLE: 		Memo 3 -- Perceived impact of the USAID cuts, by party ID
*	PURPOSE:	Stacked bars of KFF April 2026 Health Tracking Poll questions 42,
*				44 and 45 on the impact of the foreign aid and USAID changes,
*				broken out by party identification (question 48).
*	AUTHOR:		Calvin Pan
*	CREATED:	2026_1110
*	UPDATED: 	2026_1110
*	CALLS UPON:	"${rawdatapath}kff_apr2026_usaid_party.csv"
*	PRODUCES: 	Figures:	${tabsfigspath}memo3_usaid_impact.png and .pdf
*				Tables: 	${tabsfigspath}memo3_usaid_impact.csv
*	CONTENTS:	0: Set globals & start log file
* 				1: Open data
*				2: Label topics and parties
*				3: Figure of impact by topic and party
*				4: Export the plotted numbers
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
	log using "${logfilepath}memo3_usaid_impact_log", replace


********
*
*	1. Open data
*
********

	**The iPoll microdata are not public, so this reads the published weighted
	**crosstabs rather than respondent-level data. Question wording, study
	**details and the source of each number are in
	**"${rawdatapath}kff_apr2026_usaid_party_source.txt".
	import delimited using "${rawdatapath}kff_apr2026_usaid_party.csv", ///
		varnames(1) stringcols(2 3 4) clear

	list, noobs abbreviate(14)

	**"All adults" stays in the raw file for the memo text; the figure contrasts
	**the three party groups
	drop if party == "All adults"

	rename topic	topic_name
	rename party	party_name


********
*
*	2. Label topics and parties
*
********

	**Short x-axis labels, in the order the battery was asked
	gen byte topic = .
	replace topic = 1 if question == 42
	replace topic = 2 if question == 44
	replace topic = 3 if question == 45

	label define topic	1 "The U.S. budget deficit"			///
						2 "Health in developing countries"	///
						3 "How the world sees the U.S."
	label values topic topic
	label variable topic "USAID changes have had an impact on..."

	**Party identification from question 48; leaners (question 49) are not folded in
	gen byte party = .
	replace party = 1 if party_name == "Democrat"
	replace party = 2 if party_name == "Independent"
	replace party = 3 if party_name == "Republican"

	label define party 1 "Democrat" 2 "Independent" 3 "Republican"
	label values party party
	label variable party "Party identification"

	label variable negative	 "Negative impact"
	label variable no_impact "No impact"
	label variable positive	 "Positive impact"

	**One row per topic x party, as graph bar (asis) requires
	isid topic party
	sort topic party


********
*
*	3. Figure of impact by topic and party
*
********

	**Segments stack bottom to top in the order listed: negative, no impact,
	**positive. Don't know and refused run from 0 to 1 percent and are left out,
	**so a few bars stop at 99 rather than 100.
	graph bar (asis) negative no_impact positive,							///
		over(party, label(labsize(vsmall) angle(45)))						///
		over(topic, label(labsize(small)) gap(90))							///
		stack																///
		bar(1, color("178 24 43"))											///
		bar(2, color("150 150 150"))										///
		bar(3, color("33 102 172"))											///
		blabel(bar, format(%3.0f) position(center) size(vsmall) color(white))	///
		ytitle("Percent of respondents", size(small))						///
		ylabel(0(20)100, angle(0) labsize(vsmall) grid glcolor(gs14))		///
		yscale(range(0 100))												///
		title("In your opinion, what kind of impact have changes to"		///
			"USAID made to...", size(medsmall) span)						///
		note("Source: KFF Poll, April 2026 Health Tracking Poll (Roper #31125187), questions 42, 44 and 45,"	///
			"crossed by party identification (question 48). Fielded by SSRS, April 14-19, 2026; national"	///
			"sample of 1,343 U.S. adults, of whom 1,242 give a party ID. Weighted percentages, margin of"	///
			"error +/- 3 points. Don't know and refused, 1 percent or less in every group, are not shown.",	///
			size(vsmall) span)												///
		legend(order(3 2 1) rows(1) size(vsmall) pos(6) ring(1)				///
			region(lstyle(none)) symxsize(4) symysize(3))					///
		graphregion(color(white)) plotregion(color(white))					///
		xsize(9.5) ysize(5.5)												///
		name(usaid_impact, replace)

	graph export "${tabsfigspath}memo3_usaid_impact.png", width(2400) replace
	graph export "${tabsfigspath}memo3_usaid_impact.pdf", replace


********
*
*	4. Export the plotted numbers
*
********

	**The figure and this table come from the same rows, so the memo text and the
	**bars cannot drift apart
	keep question variable_name topic party positive negative no_impact ///
		dont_know respondents
	order question variable_name topic party positive negative no_impact ///
		dont_know respondents

	list topic party positive negative no_impact dont_know respondents, ///
		sepby(topic) noobs abbreviate(12)

	export delimited using "${tabsfigspath}memo3_usaid_impact.csv", replace


********
*
*	5. Close log file
*
********

	log close

	translate 	"${logfilepath}memo3_usaid_impact_log.smcl" ///
				"${logfilepath}memo3_usaid_impact_log.pdf", replace
