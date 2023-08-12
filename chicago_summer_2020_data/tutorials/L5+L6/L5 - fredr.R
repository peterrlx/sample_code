##### Federal Reserve API #####

# Fed data is used for a wide variety of labor statistics and economics. If you've ever seen unemployment stats in the news, they probably used FRED to get them.

# FRED Base URL
## https://fred.stlouisfed.org/

# Adapted From Sam Boysel's Blog Post:
## http://sboysel.github.io/fredr/articles/fredr.html

# API key request URL
# https://research.stlouisfed.org/docs/api/api_key.html


# Just like with the Census API, we must request an enter an API key
fredr_set_key("886e21a6e31f73cc29e2d7bf896efc3e")

# Gather unemployment rate since the beginning of 2000
unemployment <- fredr(
  series_id = "UNRATE",
  observation_start = as.Date("2000-01-01")
)

pur_power <- fredr(
  series_id = "CUUR0000SA0R",
  observation_start = as.Date("2000-01-01")
)

# Plot the unemployment data as a line (time series)
pur_power %>%
  ggplot(aes(x = date, y=  value)) +
  geom_line(color="#238912") +
  labs(
    title = "Unemployment Rate (2000-2019)",
    x = "Year",
    y = "Unemployment Rate (%)"
  ) +
  theme_bw()

# You can change the specifications of your query to get different units or time periods
fredr_series_observations(
  series_id = "UNRATE",
  observation_start = as.Date("2000-01-01"),
  frequency = "q",
  units = "pch"
) %>%
  ggplot(aes(x = date, y=  value)) +
  geom_line(color="#238912") +
  labs(
    title = "Unemployment Quarterly Percent Change (2000-2019)",
    x = "Year",
    y = "% Change in Unemployment"
  ) +
  theme_bw()

## What options can I change? See API documentation:
# https://research.stlouisfed.org/docs/api/fred/series_observations.html
fredr_docs(endpoint = "series/observations")

# The easiest way to find a series that you need is to start here: https://fred.stlouisfed.org/categories , then choose a category and then series from that category. The series ID will be the right-most part of the URL of whatever series you select

# CHALLENGE: Create a time-series visualization of seasonally-adjusted U.S. GDP, starting in 1980.
