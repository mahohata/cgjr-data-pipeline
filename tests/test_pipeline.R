source("R/05_quality_checks.R")

clean <- read.csv("data/processed/wdi_long.csv", stringsAsFactors = FALSE)
stopifnot(nrow(clean) > 0L, isTRUE(check_data(clean)))
outputs <- c(
  "outputs/figures/gdp_growth.png",
  "outputs/figures/ilostat_employment_to_population.png",
  "outputs/tables/country_summary.csv"
)
stopifnot(all(file.exists(outputs)), all(file.info(outputs)$size > 0))
message("Smoke test passed.")

ilostat <- read.csv("data/processed/ilostat_long.csv", stringsAsFactors = FALSE)
ilostat_required <- c(
  "country_code", "year", "indicator", "value", "source", "best_source"
)
stopifnot(
  nrow(ilostat) > 0L,
  all(ilostat_required %in% names(ilostat)),
  is.integer(ilostat$year),
  is.numeric(ilostat$value),
  !anyDuplicated(ilostat[, c("country_code", "year", "indicator")])
)
countries <- read.csv("config/countries.csv", stringsAsFactors = FALSE)
stopifnot(all(ilostat$country_code %in% countries$country_code))
stopifnot(all(ilostat$year >= min(countries$start_year)))
stopifnot(all(ilostat$year <= max(countries$end_year)))

analytical <- read.csv("data/processed/analytical.csv", stringsAsFactors = FALSE)
analytical_keys <- c("country_code", "year")
stopifnot(
  nrow(analytical) == sum(countries$end_year - countries$start_year + 1L),
  !anyDuplicated(analytical[, analytical_keys]),
  "employment_to_population_ratio" %in% names(analytical)
)
plot_check <- merge(
  ilostat[, c(analytical_keys, "value")],
  analytical[, c(analytical_keys, "employment_to_population_ratio")],
  by = analytical_keys, all = TRUE
)
stopifnot(
  nrow(plot_check) == nrow(analytical),
  sum(!is.na(plot_check$value)) == sum(!is.na(plot_check$employment_to_population_ratio)),
  isTRUE(all.equal(
    plot_check$value, plot_check$employment_to_population_ratio,
    check.attributes = FALSE
  ))
)
message("ILOSTAT ingestion checks passed.")

fixture <- data.frame(
  country_code = c("BRA", "BRA"), year = c(2020L, 2021L),
  indicator = c("NY.GDP.MKTP.KD.ZG", "NY.GDP.MKTP.KD.ZG"),
  value = c(-3.3, 4.8)
)
stopifnot(isTRUE(check_data(fixture)))
invalid <- rbind(fixture, fixture[1, ])
duplicate_rejected <- tryCatch(
  { check_data(invalid); FALSE },
  error = function(condition) TRUE
)
if (!duplicate_rejected) stop("Edge test failed: duplicate input must raise an error.")
message("Duplicate-key edge test passed.")