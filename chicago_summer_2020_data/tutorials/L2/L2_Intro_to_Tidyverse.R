########################################################################################################
### Programming in R                                                                                 ###
### Lecture 2 - Intro to Tidyverse                                                                   ###
### Austin Wright, The University of Chicago                                                         ###
### Credit: the first iteration of this material was developed by Daniel Snow.                       ###
########################################################################################################



##############################################################################################################################################
## WARMING UP FOR THIS SESSION: A FEW SIMPLE SKILLS
# SKILL 1: Click Tools >> Global Options >> Click the 'Code' Tab >> Check 'Soft-wrap R Source Files' >> Click 'Apply'
# SKILL 2: You can comment (or uncomment) lines or highlighted areas in RStudio using Cmd + Shift + C or Ctrl + Shift + C on Windows
# SKILL 3: To run a single line of code, put your cursor on the line you want to run, then hit "Run" in the top right corner of the console.
##############################################################################################################################################

# For simplicity; starting with L3, we will use projects, which will sidestep setwd
setwd("/Users/austinlw/Harris-Public-Policy Dropbox/Austin Wright/Summer_Scholars/Lecture_Materials_2020/coding_lectures/Lecture 2 - Intro to Tidyverse")

######################
## Just run these for now - we we will discuss these later:
options(stringsAsFactors = FALSE)
options(scipen = 999999)
######################

## The tidyverse makes most of the things we did yesterday much easier. It is designed to work with dataframes and other 2-dimensional datasets. Today we'll focus on using the package dplyr to wrangle (clean up, pivot, filter, etc.) data. To start, we need to install the tidyverse package from the internet.

## running install.packages("name_of_packacge") will download the necessary files. They tidyverse is fairly large, so this may take awhile
install.packages("tidyverse")

## To actually use functions from tidyverse packages, we need to load it using library
library(tidyverse)

## For a list of all tidyverse packages, see here: https://www.tidyverse.org/packages/

## Now lets start with some novel data from a previous cohort. Load the data the same way we loaded the poverty data in lesson 1, but using a new function: read_csv()
dpss <- read_csv("program_data.csv")

## NOTE: read.csv() and read_csv() are NOT the same. read_csv() has much more sensible default settings. Y

## NOTE: The tidyverse uses tibbles, a different class of data frame. For our purposes, data frames and tibbles are nearly identical, the main difference is that tibbles will only print the first 10 rows of data when called (dataframes print all rows)
class(dpss)

## Tibbles can be subset in the same way as normal dataframes:
dpss[1,1]  # first row, first col
dpss[1,]  # first row, all cols
dpss[,1]  # first col, all rows

# This is the syntax we used previously to get the first 20 rows and 2 columns
dpss[1:20,colnames(dpss) == "country" | colnames(dpss) == "height"]

# This will yield the same result, but is now translated into dplyr syntax
dpss %>%
  select(country, height) %>%
  slice(1:20)

# Which format is better? It's up to you, but most prefer the latter.


########################################
########## Syntax and Overview #########
########################################

## Today we will learn the following dplyr "verbs"

# filter: pick rows matching criteria           - very common
# slice: pick rows using index(es)              - rare
# select: pick columns by name                  - common
# distinct: filter for unique rows              - uncommon
# pull: grab a column as a vector               - common
# arrange: reorder rows                         - common
# mutate: add new variables                     - very common
# sample_n / sample_frac: randomly sample rows  - common
# group_by: create groups using row values      - very common
# summarise: reduce variables to values         - very common
# + a few others

## But first, a note on tidyverse syntax:
# ALL tidyverse verbs have the same general syntax following this pattern:

verb(data, argument1 = val1, argument2 = val2)

# tidyverse verbs ALWAYS have the dataset as the first argument, for example:
filter(dpss, country == "United States")

# So why didn't I put the dataset first in the example code on line 38? Because I was using a special operator called the pipe '%>%'. The pipe operator allows your to chain together sequences of verbs, such that they are executed in order and the end result is the data after all your chained verbs have been executed. The pipe operator puts the dataset from the previous verb into the first argument of the next verb (it does this implicitly). This can be incredibly powerful and useful:
dpss %>%
  filter(country == "China") %>%
  select(country, num_siblings) %>%
  arrange(num_siblings)


##### Filter #####

# filter() will return a subset of rows based on a logical condition(s)
filter(dpss, country == "United States")  # get only US students
dpss %>% filter(country == "United States")  # same as above
dpss %>% filter(country %in% c("India", "Mexico", "Japan"))  # get students from India, Mexico, and Japan

# Get US students with more than 1 sibling than don't use Windows
dpss %>%
  filter(
    country == "United States" &
    num_siblings > 1 &
    op_system != "Windows"
  )

# QUESTION: How many students from China and India are over 160 cm tall, are interested in economic policy, and like pizza?

dpss %>%
  filter(
    country %in% c("China", "India"),
    height > 160,
    policy_area == "Economics"
  )

filtered <- dpss %>%
  filter(
    country == "China",
    height > 165 |
    tolower(fav_food) == "hotpot"
  )


##### Slice #####

# slice() is a very simple verb that returns rows based on indices, so this:
dpss[1:15, ]
# becomes:
slice(dpss, 1:15)
# or:
dpss %>% slice(1:15)

# Unlike native indexing however, slice() lets you provide multiple indices, separated by commas:
dpss %>% slice(1, 6, 9, c(20:24))

# You can combine it with which.max() to get things like the max value for a column:
dpss %>% slice(which.max(dpss$num_siblings))

# The more tidyverse way to accomplish this is:
dpss %>% filter(num_siblings == max(num_siblings))

# QUESTION: What is the height of the tallest student? The shortest?
dpss %>%
  slice(which.max(dpss$height), which.min(dpss$height))

dpss %>%
  filter(height == max(height) | height == min(height))


dpss %>%
  filter(best_friend_age == max(best_friend_age) |
         best_friend_age == min(best_friend_age))


##### Select #####

# select() will allow you to select columns from your tibble/dataframe. It is very versatile and includes a number of helper functions

dpss %>% select(country, height)  # separate column names by a comma

dpss %>% select(-num_siblings)  # get all columns except num_siblings

dpss %>% select(country:best_friend_age)  # get all columns between country and best_friend_age

dpss %>% select(c("country", "policy_area"))  # you can also pass in a vector of names as strings

dpss %>% select(starts_with("p"))  # all columns that start with 'p'
dpss %>% select(contains('o'))  # all columns that contain 'o'

# There are also special variants of select that will return columns based on a logical test. Here we select only columns with numbers:
dpss %>% select_if(is.numeric)

# QUESTION: How many character columns are in our DPSS dataset?
dpss %>% select_if(is.character) %>% ncol()


dpss %>%
  select(contains("a")) %>%
  ncol()

##### Distinct #####

# distinct() works like select, but will keep only unique rows for each specified column

dpss %>% distinct(country)  # get only distinct countries
dpss %>% distinct(country, op_system)  # get unique combinations of countries and operating system

# Get a distinct value for each country, keeping all other rows. This is a great way to get rid of duplicates!
distinct(country, .keep_all = TRUE)

# QUESTION: How many distinct favorite foods does our class have?
dpss %>% distinct(fav_food) %>% nrow()

dpss %>%
  distinct(op_system, num_siblings) %>%
  nrow()

##### Pull #####

# pull() is a relatively simple verb. It returns the column you select as a vector (rather than as a tibble). You can use this vector result with base R functions very easily.

dpss %>% pull(height)  # this returns a vector
dpss %>% select(height)  # this returns a tibble

dpss %>% pull(height, num_siblings)  # this will break! pull() only takes one column

dpss %>% pull(height) %>% mean()  # this will return the mean of the height column
dpss %>% pull(height) %>% sd()  # this will return the SD of the height column

# QUESTION: What is the median best friend age for students who use Windows? For Mac?

dpss %>%
  filter(op_system == "Windows") %>%
  pull(best_friend_age) %>%
  median()

heights <- dpss %>%
  filter(country %in% c("United States", "Spain")) %>%
  pull(height)



##### Arrange #####

# arrange() is used to order data according to its values. You can order by multiple columns. The default is ascending order.

dpss <- dpss %>% arrange(height)  # ascending by height
dpss %>% arrange(desc(height))  # descending by height
dpss %>%
  arrange(-height) %>%
  slice(11:nrow(dpss))

dpss %>%
  arrange(-height) %>%
  filter(row_number() > 10)


# shorthand for descending by height

# Using two columns will group and order by the values in the first column, then order by the second column
dpss %>% arrange(-num_siblings, height)
dpss %>% arrange(country, -height)


##### Mutate #####

# mutate() is probably the most used tidyverse verb. It creates new variables and appends them to your dataframe. It uses the following syntax:

mutate(data, new_variable_name = some_value)

# For example, this will create a binary variable (1 or 0) with the name has_siblings:
dpss <- mutate(dpss, has_siblings = num_siblings > 0)

# NOTE: This change has not been saved to the dpss data. In order to save the changes made by mutate or any tidyverse verb, you must assign them to a variable. This can be the same variable as the original dataset or an entirely new one.
dpss <- dpss %>%
  mutate(has_siblings = num_siblings > 0)

# mutate() can be incredibly complex and can create variables using wildly complicated functions.
dpss <- dpss %>%
  mutate(food_group = case_when(
    fav_food == "Pizza" ~ "Pizza",
    fav_food == "Tacos" ~ "Mexican food",
    fav_food == "Mexican food" ~ "Mexican food",
    TRUE ~ "Other"
  ))

# It can also create more than one new variable at the same time:
dpss <- dpss %>%
  mutate(
    has_siblings = num_siblings > 0,
    tall = height >= 182
  )

# CHALLENGE: Create a variable called tall_windows of Windows users over 182 cm. How many are there?

dpss %>%
  mutate(tall_windows = height >= 182 & op_system == "Windows") %>%
  count(tall_windows)

# Count of Mac users with prior experience
# Mean height of mac users with prior experience

dpss %>%
  mutate(
    experienced_macs = prior_exp == "Yes" &
                       op_system == "Apple/Mac OS"
  ) %>%
  filter(experienced_macs == TRUE) %>%
  pull(height) %>%
  mean()




##### Sample_n / Sample_frac #####

# sample_n() and sample_frac() will return a sample of your dataframe, either N rows or a percentage of the entire frame. This can be very useful when working with large data.

dpss %>% sample_n(10)  # get 10 rows of data only
dpss %>% sample(0.5)  # get half the rows in our dataset
dpss%>%sample(0.4)
dpss%>%sample(8)
# sample will also shuffle the rows, which can be important for machine learning
dpss %>% sample_frac(1)
dpss %>% sample_frac(.5)
dpss %>% sample_frac(.8)


# APPLICATION
# Sampling with replacement will eventually yield a normal distribution, assuming the underlying data is normally distributed (see the central limit theorem)


##### Group By / Summarize #####

# group_by() will create groups in the dataframe based on the distinct values in the columns you provide it. These groups will be invisible in the dataframe, you cannot see them until you perform some sort of summarization operation on the dataframe.

dpss %>% group_by(country)  # no visible change
dpss %>% group_by(country, op_system, prior_exp)  # group_by more than one variable

# group_by is almost always used with summarize(). summarize() will apply some sort of summary function to your dataset or to the groups in your dataset. It MUST be used with functions that reduce a vector to a single number, think mean(), sum(), median(). The syntax of summarize is the same as mutate():

summarize(data, summarized_column_name = summary_function(column_to_summarize))

# For example, if we want to get the mean height of the whole class, we can use:
dpss %>% summarize(mean_height = mean(height))

# You can create multiple summary columns at the same time, just like with mutate()
dpss %>%
  summarize(
    mean_height = mean(height),
    total_siblings = sum(num_siblings),
    total_econ_policy = sum(policy_area == "Economic")
  )

# Summarize also has some helper functions, such as n(), which returns the count in each group

dpss %>% summarize(n())
dpss %>% summarize(count = n())  # same as above, but I've named the column 'count'

# Let's add group_by into the mix. Getting the count of students by country:
dpss %>%
  group_by(country) %>%
  summarize(count = n())

# Getting the mean height and median number of siblings of students by country:
dpss %>%
  group_by(country) %>%
  summarize(
    count = n(),
    med_num_siblings = median(num_siblings),
    mean_height = mean(height)
  )

# count() is a shorthand for group_by(column) %>% summarize(n())
dpss %>% count(country)
dpss %>% group_by(country) %>% summarize(n = n())

# Let's combine verbs to do more complicated analysis. What is the breakdown of prior programming experience by operating system?
dpss %>%
  mutate(prog_exp = prior_exp == "Yes") %>%  # create a new binary variable for exp.
  group_by(op_system) %>%
  summarize(pct_with_exp = mean(prog_exp))

# What is the breakdown of policy areas by country?
dpss %>%
  group_by(country, policy_area) %>%
  count() %>%
  group_by(country) %>%
  summarize(count = n())


# QUESTION: What percentage of students have siblings, grouped by country?

dpss %>%
  group_by(country) %>%
  summarise(pct_with_siblings = mean(num_siblings > 0))

# QUESTION: How many students fall between 160 and 180 cm and are interested in economic policy?

dpss %>%
  filter(between(height, 160, 180) & policy_area == "Economic") %>%
  count()

# CHALLENGE: Considering only countries with more than 2 students, what percentage of students from each country share the same favorite food?


# Simplest way, doesn't include 'All' as a nonunique food
temp <- dpss %>%
  group_by(country) %>%
  mutate(count = n()) %>%
  filter(count > 2) %>%
  group_by(country, fav_food) %>%
  mutate(nonunique_food = n() > 1) %>%
  group_by(country) %>%
  summarize(pct_nonunique = mean(nonunique_food))

# More difficult, but will work better when the group_by() summarize() is very complicated
dpss %>%
  group_by(country) %>%
  summarize(n = n()) %>%
  filter(n > 2)
  right_join(dpss, by = "country") %>%
  filter(!is.na(n)) %>%
  group_by(country, fav_food) %>%
  mutate(
    nonunique_food = mean(n() > 1),
    nonunique_food = ifelse(fav_food == "All", 1, nonunique_food)
  ) %>%
  group_by(country) %>%
  summarize(pct_unique = mean(nonunique_food))

# Nested code way
dpss %>%
  filter(country %in% (dpss %>%
           group_by(country) %>%
           count() %>%
           filter(n > 2) %>%
           pull(country))
         ) %>%
  group_by(country, fav_food) %>%
  mutate(nonunique_food = mean(n() > 1)) %>%
  mutate(nonunique_food = ifelse(fav_food == "All", 1, nonunique_food)) %>%
  group_by(country) %>%
  summarize(pct = mean(nonunique_food))

temp <- dpss %>%
  rename(height_cm = height, n_siblings = num_siblings)

temp <- dpss %>%
  select(height_cm = height, n_siblings = num_siblings)



########################################
############ Applied Example ###########
########################################

# This is a real dataset we can play with to test what we've learned. We will talk more about some of the commands below tomorrow/next week:

# National Survey on Drug Use and Health (2012)
# Source: http://www.icpsr.umich.edu/icpsrweb/ICPSR/studies/34933?q=&paging.rows=25&sortBy=10

drugs <- read_csv("NSDUH.csv")

dim(drugs) 
head(drugs)## look at the first six rows of data
summary(drugs) ## gives five number summary for continuous variables

table(drugs$HEALTH) ## frequency table of the HEALTH column
table(drugs$AGE2) ## frequency table of the AGE2 column
hist(drugs$AGE2)
glimpse(drugs)

drugs_no_smokers <- filter(drugs, CIGEVER == "No")
nrow(drugs_no_smokers)

drugs_lim1 <- filter(drugs, AGE2 < 11)
drugs_lim2 <- filter(drugs, AGE2 <= 10)
drugs_lim4 <- filter(drugs, AGE2 %in% c(1,2,3,4,5,6,7,8,9,10))
drugs_lim3 <- filter(drugs, AGE2 %in% 1:10)

table(drugs_lim1 == drugs_lim2)
table(drugs_lim1 == drugs_lim3)
table(drugs_lim1 == drugs_lim4)

## Look at this frequency table:
table(drugs$CIGEVER, drugs$MJEVER, useNA="always")

## And predict the results of these filters:
nrow(filter(drugs, CIGEVER == "Yes"))
nrow(filter(drugs, CIGEVER == "Yes" & MJEVER == "Yes"))
nrow(filter(drugs, CIGEVER == "No" | MJEVER == "No"))

## Now, with missing values:
table(drugs$IRSEX, drugs$MJEVER, useNA="always")
nrow(filter(drugs, IRSEX == "Female"))
nrow(filter(drugs, IRSEX == "Female" & MJEVER != "No"))

## Mutate for new variable creation:
drugs <- mutate(drugs, AGE_ADJUSTED = AGE2 + 11)

## Always check to make sure your code did what you thought - you can do this using select to examine one variable:
glimpse(drugs)
select(drugs, AGE_ADJUSTED)
table(select(drugs, AGE_ADJUSTED))

## Proportional Frequency Table:
prop.table(c(2,3))
prop.table(table(select(drugs, CIGEVER)))

## Ordered categorical variables should generally be factors to work as intended. Factors are how you define the possible set of categorical variables. All values not in the set will be coerced into NA, or missing (which is good).
drugs$MJEVER <- factor(drugs$MJEVER, levels = c("Yes","No"))
drugs$CIGEVER <- factor(drugs$CIGEVER, levels = c("Yes","No"))
drugs$SNFEVER <- factor(drugs$SNFEVER, levels = c("Yes","No"))
drugs$CIGAREVR <- factor(drugs$CIGEVER, levels = c("Yes","No"))
drugs$ALCEVER <- factor(drugs$ALCEVER, levels = c("Yes","No"))
drugs$IRSEX <- factor(drugs$IRSEX, levels = c("Male","Female"))

## Factor Example:
mons_data <- c("March","April","January","November","January","September","October","September","November","August","January","November","November","February","May","August","July","December","August","August","September","November","February","April")
mons_factor <- factor(mons_data)
table(mons_factor)
levels(mons_factor)

mons_ordered_factor <- factor(mons_data, levels=c("January","February","March","April","May","June","July","August","September", "October","November","December"), ordered=TRUE)
mons_ordered_factor[1] < mons_ordered_factor[2]
table(mons_ordered_factor)
levels(mons_ordered_factor)

new_data <- drugs %>%
	filter(CIGEVER == "Yes") %>%
	group_by(IRSEX) %>%
	summarize(avg_education = mean(IREDUC2)) %>%
	arrange(avg_education)

library(ggplot2)

drugs %>%
	filter(CIGEVER == "Yes") %>%
	group_by(HEALTH) %>%
	summarize(avg_education = mean(IREDUC2)) %>%
	arrange(-avg_education)  %>%
	ggplot(aes(x=HEALTH, y=avg_education)) +
		geom_bar(stat="identity", fill="#00AEEF")
