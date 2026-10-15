# Growth and Jobs Data Pipeline

Participant starter for the GitHub, VS Code and Copilot hands-on exercise.
Use public aggregate data only. This starter deliberately contains four
recoverable issues: execution alone does not establish analytical correctness.

## Setup

Open this repository folder in VS Code, install the four required R packages, set your working directory, create a branch

- Open New Terminal
- Click on "+" -> "R Terminal"
- Set your working directory by running 'setwd("your_path")' in the terminal. E.g. `setwd("c:/Users/wb541423/OneDrive - WBG/Documents/cgjr-data-pipeline")`
- Check the working directory by running `getwd()`
- Copy the following code then press enter: `install.packages(c("WDI", "dplyr", "ggplot2", "Rilostat"))`
- Create and publish a branch named `first name`. E.g. `yann-branch`; do not work directly on `main`.

## Baseline

The configuration selects Brazil, Indonesia, Kenya and Viet Nam for 2010-2023.
WDI supplies GDP growth, GDP per capita (constant 2015 US$) and population.

Source each script, in this order:

 R/01_download_wdi.R
 R/01b_download_ilostat.R
 R/02_clean_wdi.R
 R/02b_clean_ilostat.R
 R/03_merge_data.R
 R/04_analysis.R
 R/05_quality_checks.R
 tests/test_pipeline.R

To source a script, open it in the editor and click on the arrow on the top right or type source("filepath") in the terminal - for example `source("R/01_download_wdi.R")`


The scripts create their data and output directories automatically. Downloads
and generated outputs are ignored by Git. Expected outputs are
`outputs/figures/gdp_growth.png`,
`outputs/figures/ilostat_employment_to_population.png`, and
`outputs/tables/country_summary.csv`.
The summary is intended to describe the latest available GDP-growth observation.
Investigate warnings and failed checks, even when plots are produced.
The ILOSTAT scripts save the raw modelled-estimates download and retrieval
metadata under `data/raw/`, and the filtered employment-to-population series
under `data/processed/ilostat_long.csv`.

## Your Work

1. Explain the workflow before editing; inspect the configuration and scripts.
2. Diagnose and fix at least three issues. See Issue solution if needed.
3. Review the ILOSTAT ingestion scripts and verify the selected annual
   employment-to-population series and its source metadata.
4. Run the ILOSTAT scripts to filter the configured countries and years. Raw
   downloads remain in `data/raw/`.
5. Merge using explicit country-year keys after checking uniqueness and types.
   Report matched, WDI-only and ILO-only rows before deciding on the sample.
6. Add an ILOSTAT trend plot.
7. Extend quality checks for columns, keys, types, bounds, missingness, country
   coverage.
8. Update README, `docs/data_dictionary.md` from verified code and results, including the new run order.
9. Review diffs, stage only intended files, commit with a title and explanatory
   body, push and open a pull request. Leave the PR open; do not merge.

## Files You Will Use

- `config/`: country list, years and WDI indicator definitions.
- `R/`: download, clean, merge, analysis and quality-check scripts.
- `tests/test_pipeline.R`: baseline smoke test and duplicate-key edge test.
- `docs/`: working data dictionary.
- `.github/pull_request_template.md`: your submission checklist.

Never commit downloaded data, generated outputs, credentials, confidential
material or person-level records. Review Source Control before every commit.
