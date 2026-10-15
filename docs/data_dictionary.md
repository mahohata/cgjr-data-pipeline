# Working Data Dictionary

## WDI Inputs

| Indicator | Variable | Definition | Unit |
| --- | --- | --- | --- |
| NY.GDP.MKTP.KD.ZG | gdp_growth | Annual percentage growth of GDP at market prices based on constant local currency | Annual percent |
| NY.GDP.PCAP.KD | gdp_per_capita | GDP divided by midyear population | Constant 2015 US dollars |
| SP.POP.TOTL | population | Total population, using the de facto definition | Persons |

Source: World Bank World Development Indicators, accessed through the `WDI`
R package. Confirm definitions in the source metadata when extending the project.
Configured coverage is BRA, IDN, KEN and VNM, 2010-2023; actual availability
must be checked after download. Missing values remain missing.

## ILOSTAT Input

The selected annual series is `EMP_2WAP_SEX_AGE_RT_A`, "Employment-to-population
ratio by sex and age -- ILO modelled estimates, Nov. 2025 (%)", from the ILO
Modelled Estimates (ILOEST) database. The ILOSTAT table of contents reported
annual frequency and catalog coverage 1991-2027 when this series was selected.
The cleaner retains total sex (`SEX_T`) and age 15+ (`AGE_YTHADULT_YGE15`) and
filters to the country-specific years in `config/countries.csv`. The verified
2010-2023 pull contains 56 observations across BRA, IDN, KEN and VNM. Values are
percentages.

The raw `data/raw/ilostat_employment_to_population.csv` contains the full
Rilostat response. `source` identifies the contributing ILOSTAT source. The
response does not provide a separate observation-status field for this series;
`best_source` is retained as the ILOSTAT source-selection flag (1 denotes the
selected best source). Retrieval details are recorded in
`data/raw/ilostat_retrieval.csv`.

## Processed Fields

`wdi_long.csv` contains `country_code` (ISO3), `country_name`, `year` (integer),
`indicator` (WDI code), `variable`, `value` (numeric), `unit` and `source`.
Its intended unique key is country-code, year and indicator.

`ilostat_long.csv` contains `country_code` (ISO3), `year` (integer), `indicator`
(the selected ILOSTAT series ID), `value` (numeric percentage), `source` and
`best_source`. Its intended unique key is country-code, year and indicator.

`analytical.csv` contains one row per configured country-year, the configured
WDI variables, and `employment_to_population_ratio` from the selected ILOSTAT
series. Missing ILOSTAT observations remain `NA`. `gdp_per_capita_growth` is
intended to measure the percentage change from the same country's previous
calendar year. Verify its implementation before interpreting it.

The ILOSTAT trend figure is saved to
`outputs/figures/ilostat_employment_to_population.png`. Each country's line is
split at missing years so unavailable observations are shown as gaps.

Record your selected ILOSTAT code, exact age/sex/population concept, unit,
source and status fields, retrieval date, observed coverage and transformations
here after inspecting the source metadata.