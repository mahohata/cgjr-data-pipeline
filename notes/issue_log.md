# Issue Log

## Duplicate country-year-indicator keys

- Cause: `R/02_clean_wdi.R` appended a copy of the first cleaned observation. `check_data()` in `R/05_quality_checks.R` only warned on duplicate keys, while the edge test expected rejection.
- Fix: Removed the extra-row append and made duplicate keys an error. The downstream calculations and output-generation code were unchanged.
- Verification:
  - `Rscript R/02_clean_wdi.R` completed successfully; only a warning noted that installed `dplyr` was built under R 4.5.3 while the active R is 4.5.2.
  - `Rscript tests/test_pipeline.R` passed: smoke test and duplicate-key edge test.
  - `Rscript R/05_quality_checks.R` passed: baseline checks completed.
