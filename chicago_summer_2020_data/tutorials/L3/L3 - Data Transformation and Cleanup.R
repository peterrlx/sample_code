########################################################################################################
### Programming in R                                                                                 ###
### Lecture 3 - Data Transformation and Cleanup                                                      ###
### Austin Wright, The University of Chicago                                                         ###
### Credit: the first iteration of this material was developed by Daniel Snow.                       ###
########################################################################################################

# Always start with the libraries you plan to use in your script!
library(tidyverse)
library(lubridate)

# We will also need the data in the package nycflights13
install.packages("nycflights13")
library(nycflights13)

########################################
######### Overview & Tidy Data #########
########################################

## Today we will learn the following verbs/topics:

# joins: combine different datasets           - very common
# gather/spread: transform wide to long       - very common
# separate/unite: separate into multiple cols - uncommon
# dealing with missing data                   - very common
# working with strings                        - very common
# working with dates                          - common

## But first, a quick note: generally when working in R and other data analysis languages, it's best to strive for 'tidy' data. Tidy data follows three easy rules:

# Each variable must have its own column
# Each observation must have its own row
# Each value must have its own cell

## The vast majority of R tools and packages are designed to work with the tidy data format.

##### Joins #####

# NOTE: The exercises for joins are pulled directly from R4DS, so feel free to follow along there as well. I used these because it's difficult to find clean data to demonstrate joins.

# Typically you have many tables of data, and you must combine them to answer the questions that you’re interested in. Joins allow you to do that, they will merge two (or more) datasets together.

# The types of joins that we care about are:
# Mutating joins - add new variables to one tibble from matching values in another
# Filtering joins - filter observations from one tibble based on whether or not they match a value in another

# Datasets are connected by 'keys', which are shared values across each tibble. You can use these keys to join different rows of data together.

# Subset our data, keeping only the columns we care about
flights2 <- flights %>%
  select(year:day, hour, origin, dest, tailnum, carrier)

### Mutating joins

data(airlines)

# Join the full airline name onto flights2 by the carrier column
# A left join keeps all observations in the left tibble
temp <- flights2 %>%
  left_join(airlines, by = "carrier")

left_join(flights2, airlines, by = "carrier")
temp2 <- left_join(airlines, flights2, by = "carrier")


right_join(flights2, airlines, by = "carrier")


# A right join keeps all observations in the right tibble
flights2 %>%
  right_join(airlines, by = "carrier")

# A full join will keep all observations from both sides
# An inner join will keep only the observations that match for both

data("weather")

# By default, joins will search for shared columns between datasets
temp <- flights2 %>%
  left_join(weather)

data(planes)

# But often, it is better to join datasets explicitly by specifying their key values
flights2 %>%
  left_join(planes)

flights2 %>%
  left_join(planes, by = "tailnum")

# If two datasets share the same information but have different column names, you can specific how to join them with a named list:
flights2 %>%
  left_join(airports, by = c("dest" = "faa"))

### Filtering joins

# A semi join keeps all values in the left side that match the right
# An anti join drops all values in the left side that match the right

# Semi joins are an easy way to filter datasets using the results of some sort of summary
top_dest <- flights %>%
  count(dest, sort = TRUE) %>%
  head(10) %>%
  mutate(origin = dest)

temp <- flights2 %>%
  left_join(top_dest, by = "dest")

# This will yield only flights to the top 10 destinations
temp <- flights %>%
  semi_join(top_dest, by = "dest")

temp <- flights %>%
  filter(dest %in% top_dest$dest)

## QUESTION: Filter flights to only show flights with planes that have flown at least 100 flights.
flights2 %>%
  group_by(tailnum) %>%
  count() %>%
  filter(n >= 100 & !is.na(tailnum))


## QUESTION: Find the 48 hours (over the course of the whole year) that have the worst delays. Cross-reference it with the weather data. Can you see any patterns? We need to be careful here; are we selecting on the dependent variable?



worst_hours <- flights %>%
  mutate(hour = sched_dep_time %/% 100) %>%  #can be omitted
  group_by(origin, year, month, day, hour) %>%
  summarise(dep_delay = mean(dep_delay, na.rm = TRUE)) %>%
  ungroup() %>%  #can be omitted
  arrange(desc(dep_delay)) %>%
  slice(1:48)

weather %>%
  semi_join(
    worst_hours,
    by = c("origin", "year", "month", "day", "hour"
    )
  )

##### Gather/Spread #####

# Let's first load a built-in R dataset. This data starts in the wide format, there are columns that could be treated as observations
data(airquality)

# We can convert data from wide to long using gather()
airquality_long <- airquality %>%
  gather(key = 'type', value = 'measurement', Ozone:Temp)

# And can convert from long back to wide using spread()
airquality_long %>%
  spread(key = type, value = measurement)

# Let's try doing the same for the PhD data available on Canvas
phds <- read_csv("phds.csv")

## QUESTION: How would we convert this PhD data from wide to long?
## CHALLENGE: Generate a new column(s) that contains the YoY percentage change for each PhD field.

## Cleaning example and answer to question 1
phds_long <- phds %>%
  gather(key = year, value = n_phds, `2008.0`:`2017.0`) %>%
  mutate(
    year = as.integer(year),
    n_phds = parse_number(n_phds)
  )

# Answer to challenge question
 phds_long %>%
  group_by(field) %>%
  mutate(pct_change = (n_phds - lag(n_phds)) / lag(n_phds)) %>%
  arrange(field) %>%
  mutate(pct_change = replace_na(pct_change, 0))

phds_long %>%
  group_by(year) %>%
  summarize(mean_phds = sum(n_phds, na.rm = T)) %>%
  ggplot() +
    geom_line(aes(x = year, y = mean_phds))

##### Separate/Unite #####

# Unite() will combine the selected columns into a new column. For example, here I combine the year, month, and day of the flights dataset into a new column called date
united <- flights2 %>%
  unite(date, year, month, day)

# Separate() is the opposite of unite. It will divide a column into multiple columns, splitting on some separator that you specify.
united %>%
  separate(date, into = c("year", "month", "day"))

# QUESTION: Use unite(), mutate(), and as.Date() to convert the year, month, and day columns of flights2 into a date column

flights2 %>%
  unite(date, year, month, day, sep = '-') %>%
  mutate(date = as.Date(date))

##### Missingness #####

# There are two varieties of missing data, explicit and implicit. Explicit missing data is marked with an NA, implicit is missing an entire observation or variable i.e. missing a year of data in a series.

# Let's clean up some fake missing data:

# Here I'm generating a time series data frame containing only 80% of the total
# series and with some random NA values (both implicit and explicit missing)
missing <- tibble(
  year = rep(seq(2000, 2018, 1), 12),
  month = str_pad(rep(seq(1, 12, 1), 19), 2, "left", "0"),
  date = as_date(
    paste0(month, "-", year, "-1"),
    format = "%m-%Y-%d",
    tz = "UTC"),
  signal = jitter(3 * sin(2 * year))
  ) %>%
  sample_frac(0.8) %>%
  mutate(signal = replace(signal, runif(10, 1, nrow(.)), NA))

# We can check for missingness in our dataset using is.na(), which returns a logical value of TRUE for any NAs it detects
table(is.na(missing$signal))
missing %>%
  count(is.na(signal))

# We can also look at the data itself on a plot
ggplot(missing) +
  geom_line(aes(x = date, y = signal))

# It's always a good idea to check for missing data in your dataset unless you KNOW it's already clean

# For things like time series data, where there is a known set of possible values, you can complete the missing values in a set using complete()
missing_complete <- missing %>%
  complete(year, month)

# The easiest way to then deal with the missingness is to use replace_na(),
# which simply replaces all the NA values in a vector with what you specify
missing_complete %>%
  mutate(signal = replace_na(signal, 0)) %>%  # here replacing NA with 0
ggplot() +
  geom_line(aes(x = date, y = signal))

# Some libraries exist to handle missing data more gracefully, usually by imputing missing values. Don't worry about installing this library, it's just for a demo.
library(imputeTS)
missing_complete %>%
  mutate(signal = na_interpolation(signal)) %>%
  ggplot() +
  geom_line(aes(x = date, y = signal))

# Note that some missing values are not coded as NA. You may encounter missing values that are coded with very high or very low numbers (999 is common) or with empty strings ''. You can use the function na_if() to replace these values with NA
na_if(c(1,3,4,5,999,7,8,9), 999)
na_if(c("dog", "cat", "dog", "", "dog"), "")

# There are two other many options for dealing with missingness

# na.omit() will remove any row with an NA in it
# complete.cases() will return TRUE if a row is complete (it has no NAs in it)
# fill() will fill all the NAs in a dataframe with the value you specify (typically 0)


##### Strings #####

## Base R string stuff

# Change case:
toupper("letters")
tolower("LETTERS")

# Simple substitution:
txt <- c("arm","foot","lefroo", "bafoobar")
grep("foo", txt) ## find 'foo'
gsub("foo", "", txt) ## replace 'foo' with 'bar'
## More on pattern replacement here: http://www.inside-r.org/r-doc/base/sub

## stringr
# Modern and consistent processing of character strings. Much better than typical base R. All stringr functions start with str_
# install.packages("stringr")
library(stringr)

str_to_lower("LETTERS")
str_to_upper("letters")
str_to_title("TODAY IT IS RAINING")
str_to_sentence("TODAY IT IS RAINING")

# str_sub() selects the start and end position within the string and returns only that section
str_sub("TODAY IT IS RAINING", 1, 5)

# str_pad() usually adds leading 0s (or other things) to the front of a string, this is especially useful for things like FIPS codes
str_pad(txt, width = 4, side = "left", pad = "x")

str_c("0", txt)

strings <- c("   219 733 8965",
             "329-293-8753    ",
             "banana",
             "387 287 6718",
             "apple",
             "233.398.9187 ",
             "842 566 4692",
             "    Work: 579-499-7527    ",
             "$1000",
             "Home: 543.355.3679")

str_length(strings)  # get the length of strings in a list
str_c("BIRTH", "DAY")  # Combine strings into a single string
str_c("TODAY", "IS", "NOT", "MY", "BIRTHDAY", sep = ' ')

str_trim(strings) ## Remove whitespace from start and end of string
str_trim("   String with trailing and leading white space \t", side="right")
str_trim("   String with trailing and leading white space \t", side="left")

str_detect(strings, "5") ## Is there a '5' in this string?

str_detect(strings, "a") ## Is there an 'a' in this string?
str_locate(strings, "a") ## Where is the first 'a' in this string?
str_locate_all(strings, "a") ## Where are all the 'a's in this string?

## Makes use of regular expressions:
# Regular expressions in R reference: http://www.regular-expressions.info/rlanguage.html
str_detect(strings, "\\s") ## Is there any whitespace in this string?
str_detect(strings, "\\$")  ## Is there a '$' in this string?

phone <- "([2-9][0-9]{2})[- .]([0-9]{3})[- .]([0-9]{4})"
str_detect(strings, phone) ## Is this string a phone number?
str_locate(strings, phone) ## Where is the phone number in this string?


##### Dates and Times #####

# These formats are exactly what they sound like: a date is simply a special date format, and a date-time is simply date and a time combined into one value. Internally, date-times are stored as the number of seconds since a specific date and time, usually midnight on Jan 1st, 1970.

# Dates and date-times are often stored as non-date-time values, like integers and strings. This can make seemingly arbitrary calculations, like determining the number of days between two dates, fairly difficult. Fortunately, the R library `lubridate` makes it fairly easy to work with dates and date-times in R.

# Here is the traditional R way to create a date. The first argument is a date
# formatted as a string, the second argument is a format string that specifies
# how to read each discrete value in the string
strptime("2018-03-12", format = "%Y-%m-%d")

# Note that changing the separators from - to / breaks the function
strptime("2018/06/12", format = "%Y-%m-%d")

# lubridate functions are smart and will read in a variety of date formats
ymd("2018-06-12")
ymd("20180612")
ymd("2018/06/12")

# They'll also read text formats
mdy("Jan. 10, 2018")
mdy("January 10th, 2018")

# You can even do weird stuff like this, subtract dates to get a length of time
mdy("January 10th, 2018") - mdy("January 10th, 2017")

# Date-times will add a time component to dates, note the military time
ymd_hms("2019-03-12 14:00:00")
ymd_hms("2019-03-12 14:00:00")
ymd_hms("2019-03-12 02:00:00 pm")
ymd_hms("2019-03-12 02:00:00 am")


# Once a date-time is saved, what can we do with it?
program_time <- ymd_hms("2019-07-25 16:30:00 pm")

# Extract specific values
year(program_time)
month(program_time)
hour(program_time)

# Test against logical statements
program_time > ymd("2019-01-01")

# Determine lengths of time (lubridate intervals)
program_time - ymd_hms("2019-01-01 00:00:00")

# lubridate has some useful builtin functions
now(tzone = "UTC")
today()

# See if a date falls within a range
program_time %>%
  between(ymd_hms("2019/01/01 00:00:00"), ymd_hms("2019/07/22 00:00:00"))

# These things can be combined in cools ways:
# How many days are left in the year?
days(365) - as.period(program_time - ymd_hms("2019-01-01 00:00:00"))

# How long will you spend in lectures at program?
as.duration(11 * 2 * (hours(2) + minutes(50)))

# How many leap years have occured since 0 A.D?
map(0:2020, leap_year) %>% unlist() %>% sum

# Loading the provided births dataset, which is NCHS data of all birth until 2014
births <- read_csv("births.csv")

# This data has a year, month, and day column. We can combine them into a date
births <- births %>%
  mutate(date = make_date(year, month, day)) %>%
  mutate(date = ymd(str_c(year, month, day, sep = "-")))

# The wday() function extracts the day of the week
# Now we can look for interesting trends

# There is a very slight dip in mean births on Friday the 13th vs all
# other possible days for a Friday
births %>%
  group_by(day, weekday = wday(date)) %>%
  summarize(mean_births = mean(births)) %>%
  filter(weekday == 6) %>%
  ggplot() +
  geom_col(aes(x = day, y = mean_births)) +
  theme_bw()


## Challenge 1: Using the births data and the `lag()` function, find the month with the smallest month-to-month percentage change in births.


## Challenge 2: Using the births data and the `lag()` function, find the month with the largest month-to-month percentage change in births.
