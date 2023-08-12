########################################################################################################
### Programming in R                                                                                 ###
### Lecture 7 - Causal Inference Stats in R                                                          ###
### Austin Wright, The University of Chicago                                                         ###
### Credit: the first iteration of this material was developed by Daniel Snow.                       ###
########################################################################################################

library(tidyverse)
library(tidycensus)
library(haven)  # for loading DTA files


###########################
######### Overview ########
###########################

# Today we'll be covering basic statistics and running regressions in R. We'll walk through the components of the linear model object created by the lm() function, run some regressions, then wrap up with an activity where we apply our models to real data.

# 1. Basic descriptive statistics
# 2. Linear models
# 3. More advanced models
# 4. Working with data (independent activity)


##############################################################

### More Resources:

# 1. R CRAN Task Views: https://cran.r-project.org/web/views/
# CRAN is the Comprehensive R Archive Network, tasked with storing R and all of its packages. CRAN Task Views are guides to doing certain tasks in R that are maintained by experts in that area. Most critically, this includes an overview of the many packages that we've used so far.

# 2. Introduction to Statistical Learning: http://faculty.marshall.usc.edu/gareth-james/ISL/code.html
# Wonderful textbook for 'statistical learning' - which includes not only statistics, but also many of the foundational skills in machine learning and data science. Nine out of ten of these chapters also have an R tutorial at the end.

# 3. Linear Regressions in R: http://r-statistics.co/Linear-Regression.html
# Extremely useful web page going over basic (and advanced) regressions in R.

# 4. R formula syntax cheatsheet: https://faculty.chicagobooth.edu/richard.hahn/teaching/formulanotation.pdf
# Handy guide to all the different possible formulas you can pass to lm()

##############################################################


##### Basic Descriptive Statistics #####

# So far, we've done a lot of work creating simple descriptive statistics like means, counts, and percentages. There are tons of simple descriptive stats that we haven't talked about that are very useful/common:

wage <- read_dta("WAGE2.DTA")

# Descriptive Statistics:
mean(wage$IQ)
median(wage$IQ)
sd(wage$IQ)
fivenum(wage$IQ)
summary(wage$IQ)

# Weighting is used to value some rows of data more than others. This can be because one row of data represents many more people in a sample, or potentially that one observation is far more reliable (e.g. we often weight surveys/polls based on the quality of their methodology, see FiveThirtyEight).

weighted.mean(wage$wage, wage$hours)
mean((wage$wage * wage$hours) / mean(wage$hours))  # Same as line above

# Quantile - cut points dividing a dataset into equally sized subgroups (meaning each subgroup will all have the same number of rows). Some common examples are:
# Tercile: 33th and 66th, dividing a dataset into three equally-sized groups.
# Quartiles: 25th / 50th / 75th, dividing a dataset into four equally-sized groups
# Quintiles: 20th / 40th / 60th / 80th, dividing a dataset into five equally-sized groups
# Decile - 10/20/30/40/50/60/70/80/90, dividing a dataset into ten equally-sized groups
# Percentile - 1:99, dividing a dataset into 100 equally-sized groups
quantile(wage$IQ, 0.33)
quantile(wage$IQ, c(0.33,0.66))
quantile(wage$IQ, c(0.2,0.4,0.6,0.8))

# The tidyverse function ntile() makes this much easier. The following divides IQ into deciles and saves to a new column:
wage %>%
  mutate(quant = ntile(IQ, 10)) %>%
  select(IQ, quant)

# How could we convert this into percentiles? Which argument would we manipulate?

# Correlation
# How related are two variables
cor(wage$wage, wage$educ)
cor.test(wage$wage, wage$educ)  # Also outputs significance

# Covariance
# How much do two variables trend/move together?
cov(wage$wage, wage$educ)

# T tests
# Is the difference in means across two groups statistically significant?
t.test(wage$wage[wage$urban == 1], wage$wage[wage$urban == 0])


######## Linear Models #######

# lm() is the function for running simple regression in R, it stands for linear model. Let's start with a simple bivariate regression.
# Here we regress wage on IQ and then on age
wage %>%
  lm(wage ~ IQ, data = .)


lm(wage ~ IQ, data = wage)
lm(wage ~ age, data = wage)

# We can also save this model and examine its contents
reg_model <- lm(wage ~ IQ, data = wage)

# And call various diagnostic or summary functions on it
# summary() will give you a complete summary of the model, including the R squared
summary(reg_model)

# ADVANCED TOPIC
# plot() will give you various diagnostic plots, useful for finding outliers
# plot(reg_model)

# coef() will give you only the coefficients of your model
coef(reg_model)

reg_model$coefficients

reg_model$fitted.values

# fitted() and predicted() will give you the fitted X values of your model
fitted(reg_model)
predict(reg_model)

# Beware! These functions are the same for OLS, but might not be for other regression types. If your regression contains a link function (logit, probit, Poisson), predict will give you values before this function is applied, fitted will give you values after it is applied

# You can also call individual parts of the model with the dollar sign, just like a dataframe:
reg_model$fitted.values
reg_model$coefficients

# There's a very useful library called broom that converts model objects into nice dataframes:
# install.packages("broom")
library(broom)

# tidy() will convert model objects to dataframes
reg_model_df <- tidy(reg_model)

# augment() will add fitted values, residuals, etc to your original data
reg_model_df <- augment(reg_model)

# glance() will output model statistics, including R-squared, Adjusted R-squared, P-value, AIC, BIC, Degress of Freedom, etc.
glance(reg_model)

# The combination of these functions can be used to more easily extract statistical results into a format useable by other packages:
lm(wage ~ IQ + age + tenure + urban, data = wage) %>%
  tidy(., conf.int = TRUE) %>%
  filter(term != "(Intercept)") %>%
ggplot(aes(estimate, term, color = term)) +
  geom_point() +
  geom_errorbarh(aes(xmin = conf.low, xmax = conf.high)) +
  geom_vline(xintercept=0) +
  theme_minimal() +
  theme(legend.position="none")


##### Multi-variate models and interaction terms #####
# Creating a multivariate regression is as easy as adding more variables
lm(wage ~ IQ + age + tenure + urban, data = wage)
reg_model_multi <- lm(wage ~ IQ + age + tenure + urban, data = wage)

# Again, we can view our model using summary() or plot()
summary(reg_model_multi)

# If you think two variables are related, it may be useful to interact them.
# You can accomplish this in R using *. Note that this adds both variables to the regression as well as an interaction term! Use I() for pure interaction
lm(wage ~ IQ + age*tenure, data = wage)

# You can also add weights to any lm() model using the weights argument:
lm(wage ~ IQ + age*tenure, data = wage)
lm(wage ~ IQ + age*tenure, data = wage, weights = hours)

# While linear models in policy are typically used for causal inference, they can also be used for machine learning and prediction. Not very exciting with a linear model unless you use more flexible parameters.
predict(reg_model, data.frame(IQ = c(1:200)))

reg_model_predicted <- tibble(
  x = c(1:200),
  y = predict(reg_model, data.frame(IQ = c(1:200)))
)

ggplot(reg_model_predicted) +
  geom_line(aes(x = x, y = y)) +
  labs(x = "IQ", y = "Monthly Wage")


##### More Advanced Models #####

## Fixed Effects
# If you have cross-sectional data (i.e. data from many different places) it is a good idea to incorporate fixed effects into your regression model. Fixed effects will remove variation in your estimates caused by location.

# But beware! The key assumption underlying the use of fixed effects is that there are no changes within-place that aren't controlled for by other variables in your model. If there are, fixed effects will remove those changes and your regression will have omitted variable bias. Let's see an example using real physician data from IPUMS.

# Load the data and re-encode for a regression
phys <- read_dta("acs_pers_phys.dta") %>%
  mutate(
    urban     = ifelse(metro %in% c(2, 3, 4), 1, 0),
    homeowner = ifelse(ownershp == 1, 1, 0),
    has_kid   = ifelse(nchild > 0, 1, 0),
    male      = ifelse(sex == 1, 1, 0),
    single    = ifelse(marst == 6, 1, 0),
    white     = ifelse(race == 1, 1, 0),
    hs_grad   = ifelse(educ > 6, 1, 0),
    employed  = ifelse(empstat == 1, 1, 0)
  ) %>%
  select(
    year, statefip, countyfips, perwt, age,
    inctot_cpi99, uhrswork, urban:employed
  ) %>%
  mutate(inctot_cpi99 = inctot_cpi99 * 1.5)  # Adjusting for modern inflation

# Sample model estimating income using the IPUMS data
inc_model <- lm(inctot_cpi99 ~ age + uhrswork + urban + single + male, data = phys)
summary(inc_model)

# Same model but with fixed effects
inc_model_fe <- lm(
  inctot_cpi99 ~ age + uhrswork + urban + single + male + factor(statefip),
  data = phys)
summary(inc_model_fe)

# Same model but with fixed effects + regression weights
inc_model_fe <- lm(
  inctot_cpi99 ~ age + uhrswork + urban + single + male + factor(statefip),
  data = phys, weights = perwt)
summary(inc_model_fe)

## Probit Models
# OLS depends on your dependent variable y_hat being continuous. Unfortunately, you'll often run into cases where the thing you want to predict is either a binary response variable or a categorical. Enter probit.

# A probit regression Within glm uses a link function (probit). Let's see an example.

# Predicting whether or not a doctor lives in an urban or rural area, urban = 1
linear_model <- lm(
  urban ~ age,
  data = phys)
summary(linear_model)

probit_model <- glm(
  urban ~ age,
  binomial(link = "probit"),
  data = phys)
summary(probit_model)

# install.packages("mfx")
library("mfx")

probit_model_mfx <- probitmfx(urban ~ age, data = phys, atmean=FALSE)
probit_model_mfx$mfxest

# Probit with fixed effects
linear_model_fe <- lm(
  urban ~ age + uhrswork + single + male + white + has_kid + factor(statefip),
  data = phys)
summary(linear_model_fe)

probit_model_fe <- glm(
  urban ~ age + uhrswork + single + male + white + has_kid + factor(statefip),
  binomial(link = "probit"),
  data = phys)
summary(probit_model_fe)

probit_model_fe_mfx <- probitmfx(urban ~ age + uhrswork + single + male + white + has_kid + factor(statefip), data = phys, atmean=FALSE)
probit_model_fe_mfx$mfxest

#linear:     uhrswork            0.0003423
#probit ape: uhrswork            0.0003095921

##### Workshop / Activity #####

# Let's use what we've learned about running regressions in R to do our own bit of causal inference. Choose one or more of the following variables:

#   VARIABLE                        : DATA SOURCE
# - Percent below the poverty line  : Census only
# - Median household income         : Census only
# - Number of homeless              : Online sources
# - Percent religious               : General Social Survey
# - Heart disease rate by state     : Kaiser / CDC
# - Other (Confirm with me first, I'll tell you if it's reasonable)

# Then, using STATE-LEVEL DATA from the U.S. Census and other sources, design a regression with the variable you chose as the dependent variable. Try to think of factors that may influence your variable and include them in your regression. You can start by pulling state-level aggregate data from the Census.

# If there are additional factors that you think may be influential, you can find them in other data sources and join them to your Census data. Be aware of what we've learned so far: you may want to include state fixed effects or interaction terms, depending on your model.

# Here's some code to get you started:

# Loading a list of all 2015 ACS 5-year Census variables
vars <- load_variables(2015, "acs5")

# Loading in state-level data of income and population
census_data <- get_acs(
  geography = "state",
  variables = c(total_pop = "B01001_001", med_income = "B06011_001"),
  year = 2015
)

# 1. Where to start: Spread into separate columns
# 2. What to do next: Start running some regressions
