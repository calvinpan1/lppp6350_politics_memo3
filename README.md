# LPPP 6350 Memo 3 -- Public opinion on the USAID cuts

Figure and underlying numbers for Politics of Public Policy Memo 3 on public opinion
on my topic, the 2025 shutdown of USAID and the cuts to U.S. foreign aid.

## What this repo produces

`6_tabsfigs/memo3_usaid_impact.png` -- stacked bars showing whether U.S. adults
think the foreign aid and USAID changes had a positive, negative or no impact on
three outcomes, split by party identification.

`python/ces25_va_aid_cut_map/output/fig1_va_aid_cut_map.png` -- map of support
for the 2025 cut of $8.3B in foreign aid and $1.1B for NPR/PBS across Virginia's
congressional districts, with a table comparing VA-5, Virginia and the U.S.

`6_tabsfigs/memo3_usaid_polling_average.png` -- support for and opposition to
shutting down USAID across the six 2025 national polls in the Roper iPoll
archive, with 95 percent intervals and the across-poll average. A `_bare`
version without the title and note is there for documents that typeset their
own caption.

## Running the repo

Open `3_syntax/memo3_usaid_impact.do`, set the `classpath` global to wherever you
cloned this, and run it. Stata 18, no user-written packages.
`3_syntax/memo3_usaid_polling_average.do` runs the same way and is independent
of the first.

For the map, put `CES25_Common.dta` and the Census file
`cb_2024_us_cd119_500k/` in `python/ces25_va_aid_cut_map/rawdata/`, set `dir` in
section 1 of `ces25_va_aid_cut_map.ipynb`, and run all cells. Needs pandas,
geopandas, matplotlib and scipy.

## Folders

| Folder | Contents |
| --- | --- |
| `2_raw_data/` | Published crosstabs transcribed from Roper iPoll, plus a source note |
| `3_syntax/` | The do-file |
| `5_log_files/` | Stata logs |
| `6_tabsfigs/` | Figure (PNG, PDF) and the plotted numbers (CSV) |
| `python/ces25_va_aid_cut_map/` | Notebook for the Virginia map; `output/` has the figure and table (CSV); `rawdata/` is gitignored |

## Data

KFF Poll, April 2026 Health Tracking Poll, fielded by SSRS, April 14-19, 2026.
National sample of 1,343 U.S. adults, margin of error +/- 3 points. Roper
#31125187, doi:10.25940/ROPER-31125187.

The iPoll microdata are not public, so `2_raw_data/kff_apr2026_usaid_party.csv`
holds the published weighted crosstabs rather than respondent-level data.
`2_raw_data/kff_apr2026_usaid_party_source.txt` gives the full question wording,
the study details and where each number came from.

The 2025 polling comparison uses the six surveys in the Roper iPoll archive
that asked about shutting down USAID: Ipsos (#31122394), CNN (#31122387),
Washington Post-Ipsos (#31122388), KFF (#31122407), Reuters/Ipsos (#31122408)
and Pew (#31122581). `2_raw_data/usaid_polls_2025_source.txt` gives the question
wording, the toplines and the search that found them. Five asked a support or
oppose question; the KFF poll measured awareness only.
`6_tabsfigs/memo3_usaid_polls_2025.csv` holds the plotted numbers with their
confidence bounds.

The Virginia map uses the Cooperative Election Study 2025 Common Content
(national survey of 17,000 adults run by YouGov, item `CC25_340g`), weighted
with `commonweight`, and the Census Bureau's 2024 cartographic boundaries for
the 119th Congress. Districts have 28 to 58 respondents each, so district
estimates are noisy.
