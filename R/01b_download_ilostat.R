library(Rilostat)

series_id <- "EMP_2WAP_SEX_AGE_RT_A"
dir.create("data/raw", recursive = TRUE, showWarnings = FALSE)

raw <- get_ilostat(
  id = series_id,
  type = "code",
  best_source = "all"
)
if (is.null(raw) || nrow(raw) == 0L) stop("ILOSTAT returned no observations.")

required <- c(
  "ref_area", "source", "indicator", "sex", "classif1", "time",
  "obs_value", "best_source"
)
missing <- setdiff(required, names(raw))
if (length(missing) > 0L) {
  stop("ILOSTAT response is missing expected columns: ", paste(missing, collapse = ", "))
}

write.csv(raw, "data/raw/ilostat_employment_to_population.csv",
          row.names = FALSE, na = "")
write.csv(
  data.frame(
    source = "ILOSTAT ILO Modelled Estimates (ILOEST)",
    series_id = series_id,
    series_label = "Employment-to-population ratio by sex and age - ILO modelled estimates, Nov. 2025 (%)",
    source_url = "https://ilostat.ilo.org/data/",
    retrieved_at_utc = format(Sys.time(), tz = "UTC", usetz = TRUE)
  ),
  "data/raw/ilostat_retrieval.csv", row.names = FALSE
)