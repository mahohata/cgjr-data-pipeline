library(dplyr)

series_id <- "EMP_2WAP_SEX_AGE_RT_A"
raw <- read.csv(
  "data/raw/ilostat_employment_to_population.csv",
  stringsAsFactors = FALSE
)
countries <- read.csv("config/countries.csv", stringsAsFactors = FALSE)
dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)

required <- c(
  "ref_area", "source", "indicator", "sex", "classif1", "time",
  "obs_value", "best_source"
)
missing <- setdiff(required, names(raw))
if (length(missing) > 0L) {
  stop("ILOSTAT raw file is missing expected columns: ", paste(missing, collapse = ", "))
}

raw$year <- suppressWarnings(as.integer(raw$time))
if (anyNA(raw$year)) stop("ILOSTAT time column contains missing or non-integer years.")
if (!is.numeric(raw$obs_value)) stop("ILOSTAT obs_value column must be numeric.")

clean <- raw |>
  filter(sex == "SEX_T", classif1 == "AGE_YTHADULT_YGE15") |>
  transmute(
    country_code = ref_area,
    year,
    indicator = series_id,
    value = as.numeric(obs_value),
    source,
    best_source
  ) |>
  inner_join(countries[, c("country_code", "start_year", "end_year")],
             by = "country_code") |>
  filter(year >= start_year, year <= end_year) |>
  select(-start_year, -end_year) |>
  arrange(country_code, year)

if (nrow(clean) == 0L) stop("No ILOSTAT observations remain after filtering.")
keys <- clean[, c("country_code", "year", "indicator")]
if (anyDuplicated(keys)) stop("Duplicate ILOSTAT country-year-indicator keys.")

write.csv(clean, "data/processed/ilostat_long.csv", row.names = FALSE, na = "")