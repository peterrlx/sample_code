# Always start by loading the libraries you plan to use
library(tidyverse)

# Next we can load our data. Today we'll use data from the National Survey on Drug Use and Health. You can find more information about this dataset and the variables in it here: https://www.icpsr.umich.edu/icpsrweb/ICPSR/studies/34933/variables

drugs <- read_csv("NSDUH.csv")

# NOTE: Missing/irrelevant data in this dataset is coded using 991, 993, or 999

# NOTE: AGE2 is an adjusted variable, it's actually starting from 12, not 1. Add 11 to get the adjusted age


# Question 1: What is the average age of males in the dataset? Females?

drugs %>%
  mutate(age = AGE2 + 11) %>%
  group_by(IRSEX) %>%
  summarize(
    mean_age = mean(age),
    count = n()
  )

# QUESTION 2: What is the average age at which males try cigarettes? Females?

drugs %>%
  mutate(age = AGE2 + 11) %>%
  filter(CIGTRY < 120) %>%
  group_by(IRSEX) %>%
  summarize(mean_cig_age = mean(CIGTRY))

# QUESTION 3: What percentage of males younger than 16 have tried cigarettes?

drugs %>%
  mutate(age = AGE2 + 11) %>%
  filter(IRSEX == "Male" & age < 16) %>%
  mutate(cig_binary = CIGEVER == "Yes") %>%
  summarize(pct_cig = mean(cig_binary))

# QUESTION 4: What percentage of males that try alcohol or cigarettes below the age of 15 have a graduate degree?

# CHALLENGE: For each education level, what percentage of each gender has tried any of the drugs listed?



