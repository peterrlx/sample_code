########################################################################################################
### Programming in R                                                                                 ###
### Lecture 5 - Data Gathering and APIs                                                              ###
### Austin Wright, The University of Chicago                                                         ###
### Credit: the first iteration of this material was developed by Daniel Snow.                       ###
########################################################################################################

library(tidyverse)

# Today we will use three new libraries that you will need to install first. Use install.packages("library_name") to install each one.c
install.packages("jsonlite")
install.packages("tidycensus")

library(jsonlite)   # For reading raw JSON
library(tidycensus) # For downloading U.S. Census data

###########################
####### API Overview ######
###########################

# In the policy world, you will often find yourself using data from a variety of sources. For demographic data, you'll often use data from the U.S. Census or the General Social Survey. For economic and labor data, you might use data from the Bureau of Labor Statistics (BLS) or the Federal Reserve. For local and state data, you'll likely use data from a data portal like the one set up by the City of Chicago.

# Typically, you don't need ALL of the data that these agencies/organizations hold (the entirety of the Census Bureau's data is likely terabytes or petabytes in size). Instead you want to extract some small part of the data that you're interested in. An API (Application Programming Interface) allows you to query large datasets via the internet and return only the records you care about. This saves you time and saves bandwidth for the entity offering the API, since you only download the data you need.

# APIs are increasingly common. Most organizations hosting large amounts of data use some sort of API to access it. Many government APIs are free and require only that you use an API key. However, not all APIs are free or public. There are plenty of paid APIs that provide some sort of specialized service (Google Maps comes to mind). Many companies use internal, private APIs that only employees can access.

# Today we will use two different API wrapper packages (tidycensus, fredr (deprecated)) to gather data and create plots. We will also walkthrough how an API request is typically structured so you can form and download your own requests without using a wrapper package.

##### United States Census API #####

# The Census API is an important part of working with data in the US policy space. It is used to gather the vast majority of demographic statistics about different places. Any time you see an article that says "Chicago's population is getting younger" or "California's population has increased in the past decade" it's likely using Census data.

# Other countries you may interested in studying could have similar platforms; you will need to investigate.

## VERY IMPORTANT ##
# To use the Census API, you first need a free API key. Get one here:
# https://api.census.gov/data/key_signup.html
# When you execute the code below, use your key.
## VERY IMPORTANT ##

# Census API Documentation: https://www.census.gov/data/developers/updates/new-discovery-tool.html

# Census API base URL: https://api.census.gov/data.html

# Data dictionary of all codes: https://www.socialexplorer.com/data/metadata

# R has a very nice Census API wrapper that makes querying the Census API very easy. It returns a tidy dataframe with the variables and their estimates for whatever you request. The first step to using it is to pass your API key to the function census_api_key()

census_api_key("7bbfe721e81691522fc770d142dce31449003c80", install = TRUE) # INSERT YOUR OWN API KEY

# We can see all the variables available from the census using load_variables(); load a few inputs below:
vars_dc_2017 <- load_variables(2017, "acs5")

vars_dc_2010 <- load_variables(2010, "sf1")

divorced_df <- get_acs(
  geography = "state",
  variables = c(divorced = "B06008_004", total = "B01001_001"),
  year = 2017
)

divorced_df %>%
  select(-moe) %>%
  spread(variable, estimate) %>%
  mutate(pct_divorced = divorced / total) %>%
  arrange(desc(pct_divorced))

# Here we're getting the total number of people in rental units for all states in 2010

pop_df <- get_acs(
  geography = "state",
  variables = "B01001_001",
  year = 2017,
  geometry = TRUE,
  shift_geo = TRUE
)

rentals_df <- get_decennial(
  geography = "county",
  variables = "H011004",
  year = 2010)

# We can expand this to get more than one variable at once
housing_df <- get_decennial(
  geography = "state",
  variables = c("H011004", "H004001"),
  year = 2010)

# We can also name each variable to make it easier to interpret
housing_df <- get_decennial(
  geography = "state",
  variables = c(renters = "H011004", total = "H011001"),
  year = 2010)

housing_df %>%
  spread(variable, value) %>%
  mutate(pct_renters = renters / total) %>%
  mutate(State = fct_reorder(factor(NAME), pct_renters)) %>%
ggplot() +
  geom_point(aes(x = pct_renters, y = State))

# The census, generally speaking, has two big surveys: the decennial census and the American Community Survey. Tidycensus has functions to query both

# The ACS can query at many different levels of geography
il_income_df <- get_acs(
  geography = "county",
  variables = c(medincome = "B19013_001"),
  state = "IL")

il_income_df %>%
  mutate(
    NAME = str_remove(NAME, " County, Illinois"),
    NAME = fct_reorder(NAME, estimate)
  ) %>%
  filter(
    NAME %in% c("Cook", "Kendall", "DuPage",
                "Lake", "Will", "Kane", "McHenry")
  ) %>%
ggplot(aes(x = estimate, y = NAME)) +
  geom_errorbarh(aes(xmin = estimate - moe, xmax = estimate + moe)) +
  geom_point(color = "#1215f3", size = 3) +
  labs(
    title = "Median household income by county in Chicagoland",
    subtitle = "2012-2016 American Community Survey",
    y = "",
    x = "ACS estimate (bars represent margin of error)"
  ) +
  theme_bw()

# QUESTION: Create a plot showing median income by state using tidycensus and data from the Census API.

acs_state_df <- get_acs(
  geography = "state",
  variables = c(medincome = "B19013_001"),
  year = 2015
  )

acs_state_df %>%
  mutate(NAME = fct_reorder(NAME, estimate)) %>%
ggplot(aes(x = estimate, y = NAME)) +
  geom_errorbarh(aes(xmin = estimate - moe, xmax = estimate + moe)) +
  geom_point(color = "#1215f3", size = 1) +
  labs(
    title = "Median household income by state",
    subtitle = "2012-2016 American Community Survey",
    y = "",
    x = "ACS estimate (bars represent margin of error)"
  ) +
  theme_bw()


# CHALLENGE: Create a plot showing white population change in Cook County over time, starting in 1990.

il_sex_df <- get_acs(
  geography = "county",
  variables = c(male = "B01001_002", total = "B01001_001"),
  state = "IL", geometry = TRUE)

il_sex_df %>%
  select(-moe) %>%
  spread(variable, estimate) %>%
  mutate(ratio = male / total) %>%
ggplot() +
  geom_sf(aes(fill = ratio))

il_race_df <- get_acs(
  geography = "tract",
  county = "031",
  variables = c(total = "B02001_001",
                white = "B02001_002",
                black = "B02001_003",
                asian = "B02001_005",
                latino = "B03002_012"),
  state = "IL", geometry = TRUE
)

il_race_df %>%
  mutate(total = ifelse(
    variable == "total", estimate, NA)
  ) %>%
  fill(total) %>%
  mutate(pct = estimate / total) %>%
  select(variable, pct) %>%
  filter(variable != "total") %>%
  ggplot() +
    geom_sf(aes(fill = pct, color = pct)) +
    viridis::scale_fill_viridis() +
    viridis::scale_color_viridis() +
    facet_wrap(vars(variable), nrow = 2)

##### Querying Raw APIs #####

# Sometimes you will encounter an API that doesn't have a wrapper package. In such a case, you will need to query the API directly by modifying the URL of a given API endpoint. This sounds hard but is really similar to just filtering or summarizing data.

# Let's use the Chicago Data Portal as an example using salary data: https://data.cityofchicago.org/Administration-Finance/Current-Employee-Names-Salaries-and-Position-Title/xzkq-xp2w

# We can see the documentation on the API endpoint here:
# https://dev.socrata.com/foundry/data.cityofchicago.org/xzkq-xp2w

# Let's try an example query based on the one provided by the docs:
salary_url <- "https://data.cityofchicago.org/resource/xzkq-xp2w.json?full_or_part_time=F&$limit=5000"

# The jsonlite library contains a function called read_json which will allow us to read the data directly into R
library(jsonlite)

salary <- read_json(salary_url, simplifyVector = TRUE)

inspections <- read_json("https://data.cityofchicago.org/resource/4ijn-s7e5.json?risk=All", simplifyVector = T)

salary %>%
  filter(salary_or_hourly == "Salary") %>%
  group_by(department) %>%
  summarize(mean_sal = mean(as.numeric(annual_salary), na.rm = T)) %>%
  arrange(desc(mean_sal)) %>%
  mutate(department = fct_reorder(department, mean_sal)) %>%
ggplot() +
  geom_point(aes(x = mean_sal, y = department)) +
  labs(
    title = "Chicago Salaries by Department",
    x = "Average Salary",
    y = "Department"
  ) +
  theme_minimal() +
  theme(
    axis.text.y = element_text(size = 6)
  )


cook <- read_json("https://datacatalog.cookcountyil.gov/resource/5mxh-trhm.json?&fiscal_year=2018&$limit=100000", simplifyVector = T)

cook %>%
  group_by(bureau) %>%
  summarize(
    mean_sal = mean(parse_number(base_pay), na.rm = T) * 4,
    count = n()
  ) %>%
  arrange(desc(mean_sal)) %>%
  mutate(bureau = fct_reorder(bureau, mean_sal)) %>%
  filter(row_number() < 30 | bureau == "COUNTY ASSESSOR") %>%
  ggplot() +
  geom_point(aes(x = mean_sal, y = bureau)) +
  labs(
    title = "Chicago Salaries by Department",
    x = "Average Salary",
    y = "Department"
  ) +
  theme_minimal() +
  theme(
    axis.text.y = element_text(size = 6)
  )

