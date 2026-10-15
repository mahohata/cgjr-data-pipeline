library(dplyr)
library(ggplot2)

analytical <- read.csv("data/processed/analytical.csv", stringsAsFactors = FALSE)
dir.create("outputs/figures", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)

chart <- ggplot(analytical, aes(year, gdp_growth, colour = country_name)) +
  geom_line(na.rm = FALSE) +
  labs(
    title = "GDP Growth by Country", x = "Year", y = "Annual growth (%)",
    colour = "Country", caption = "Source: World Bank, World Development Indicators."
  ) +
  theme_minimal(base_size = 11) +
  theme(legend.position = "bottom")
ggsave("outputs/figures/gdp_growth.png", chart, width = 8, height = 5, dpi = 150)

ilostat_plot_data <- analytical |>
  arrange(country_code, year) |>
  group_by(country_code) |>
  mutate(line_group = cumsum(lag(is.na(employment_to_population_ratio), default = FALSE))) |>
  filter(!is.na(employment_to_population_ratio)) |>
  ungroup()

ilostat_chart <- ggplot(
  ilostat_plot_data,
  aes(
    year, employment_to_population_ratio,
    colour = country_name,
    group = interaction(country_code, line_group)
  )
) +
  geom_line(linewidth = 0.8) +
  geom_point(size = 1.8) +
  scale_colour_brewer(palette = "Dark2") +
  scale_x_continuous(breaks = seq(min(analytical$year), max(analytical$year), by = 2)) +
  labs(
    title = "Employment-to-population ratio",
    subtitle = "Annual estimates for total sex, age 15+",
    x = "Year", y = "Employment-to-population ratio (%)",
    colour = "Country",
    caption = paste(
      "Source: ILOSTAT, ILO Modelled Estimates (ILOEST), Nov. 2025.",
      "Gaps indicate unavailable annual observations."
    )
  ) +
  theme_minimal(base_size = 12) +
  theme(
    legend.position = "bottom",
    panel.grid.minor = element_blank(),
    plot.title = element_text(face = "bold"),
    plot.caption = element_text(hjust = 0)
  )
ggsave(
  "outputs/figures/ilostat_employment_to_population.png",
  ilostat_chart, width = 8.5, height = 5.5, dpi = 300, bg = "white"
)

summary_table <- analytical |>
  filter(!is.na(gdp_growth)) |>
  arrange(country_code, year) |>
  group_by(country_code, country_name) |>
  slice(1) |>
  ungroup() |>
  select(country_code, country_name, year, gdp_growth)
write.csv(summary_table, "outputs/tables/country_summary.csv", row.names = FALSE)