library(dplyr)

clean <- read.csv("data/processed/wdi_long.csv", stringsAsFactors = FALSE)
indicators <- read.csv("config/indicators.csv", stringsAsFactors = FALSE)
countries <- read.csv("config/countries.csv", stringsAsFactors = FALSE)

analytical <- bind_rows(lapply(seq_len(nrow(countries)), function(index) {
  data.frame(
    country_code = countries$country_code[index],
    country_name = countries$country_name[index],
    year = seq.int(countries$start_year[index], countries$end_year[index])
  )
}))

for (variable_name in indicators$variable) {
  series <- clean |>
    filter(variable == variable_name) |>
    select(country_code, year, value)
  names(series)[names(series) == "value"] <- variable_name
  analytical <- left_join(analytical, series, by = c("country_code", "year"))
}

ilostat <- read.csv("data/processed/ilostat_long.csv", stringsAsFactors = FALSE)
required <- c("country_code", "year", "indicator", "value")
missing <- setdiff(required, names(ilostat))
if (length(missing) > 0L) {
  stop("ILOSTAT processed file is missing expected columns: ", paste(missing, collapse = ", "))
}
if (anyDuplicated(ilostat[, c("country_code", "year", "indicator")])) {
  stop("Duplicate ILOSTAT country-year-indicator keys.")
}

ilostat_series <- ilostat |>
  filter(indicator == "EMP_2WAP_SEX_AGE_RT_A") |>
  transmute(country_code, year, employment_to_population_ratio = value)
analytical <- left_join(analytical, ilostat_series, by = c("country_code", "year"))

analytical <- analytical |>
  arrange(country_code, desc(year)) |>
  mutate(gdp_per_capita_growth = 100 * (gdp_per_capita / lag(gdp_per_capita) - 1))

write.csv(analytical, "data/processed/analytical.csv", row.names = FALSE, na = "")