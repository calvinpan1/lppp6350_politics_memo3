# LPPP 6350 Memo 3 -- Public opinion on the USAID cuts

Figure and underlying numbers for Memo 3 (Considering the Public), on where the
public stands on the 2025 shutdown of USAID and the cuts to U.S. foreign aid.

## What it produces

`6_tabsfigs/memo3_usaid_impact.png` -- stacked bars showing whether U.S. adults
think the foreign aid and USAID changes had a positive, negative or no impact on
three outcomes, split by party identification.

## Running it

Open `3_syntax/memo3_usaid_impact.do`, set the `classpath` global to wherever you
cloned this, and run it. Stata 18, no user-written packages.

## Folders

| Folder | Contents |
| --- | --- |
| `2_raw_data/` | Published crosstabs transcribed from Roper iPoll, plus a source note |
| `3_syntax/` | The do-file |
| `5_log_files/` | Stata logs |
| `6_tabsfigs/` | Figure (PNG, PDF) and the plotted numbers (CSV) |

## Data

KFF Poll, April 2026 Health Tracking Poll, fielded by SSRS, April 14-19, 2026.
National sample of 1,343 U.S. adults, margin of error +/- 3 points. Roper
#31125187, doi:10.25940/ROPER-31125187.

The iPoll microdata are not public, so `2_raw_data/kff_apr2026_usaid_party.csv`
holds the published weighted crosstabs rather than respondent-level data.
`2_raw_data/kff_apr2026_usaid_party_source.txt` gives the full question wording,
the study details and where each number came from.
