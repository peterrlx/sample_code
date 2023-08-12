########################################################################################################
### Programming in R                                                                                 ###
### Lecture 6 - Programmatic concepts                                                                ###
### Austin Wright, The University of Chicago                                                         ###
### Credit: the first iteration of this material was developed by Daniel Snow.                       ###
########################################################################################################

library(tidyverse)

###########################
######### Overview ########
###########################

# Today we'll be covering some basic programming concepts such as loops, functions, and control flow. These are the building blocks of most larger programs and analyses, so it's important to understand how they work.

# 1. If statements
# 2. Ifelse
# 3. Case when
# 4. For loops
# 5. While loops

##### If Statements #####

# If statements provide a way to conditionally execute code (to check that something is TRUE before running later code). They are handy inside of simple scripts but are especially useful (and used) inside of functions.

# Here's the syntax of a simple if statement:

if (this_is_true) {
  do_this
}

# Here's a very simple potential example:
x <- 5

if(x > 0) {
  print("Positive number")
}

x <- -4
if(x > 0) {
  print("Positive number")
}

# NOTE: If is not vectorized, meaning if you pass it a vector x, it will NOT perform the logical test on all elements of the vector

x <- c(5, -4, 10, 4)
if(x > 0) {
  print("Positive number")
}

# If statements can be easily extended with more conditions using else

x <- -3
if(x > 0){
  print("Positive number")  # if first condition is met, do this
} else {
  print("Negative number")  # otherwise do this
}

# But what about zero? We can extend even further with else if
x <- 0

if(x > 0){
  print("Positive number")
} else if(x == 0) {
  print("x is zero")
} else {
  print("Negative number")
}

# If statements can be (and often are) nested together
x <- -20
if(x > 0) {
  print("Positive number")
  if(x > 10) {
    print("Greater than 10")
  }
} else if(x == 0) {
  print("x is zero")
} else {
  print("Negative number")
  if(x < -10) {
    print("Less than -10")
  }
}

# QUESTION: Write an if statement that checks if a varible is a vector. If it is a vector, write a nested if statement that whether the variable is a number, string, or logical, then print a message saying the data type.

if (is.vector(x)) {
  if(is.numeric(x)) {
    print("Is a number")
  } else if (is.character(x)) {
    print("Is a string")
  } else if (is.logical(x)) {
    print("Is a logical")
  } else {
    print("Is none")
  }
}

if (x > 0) {
  print("gt0")
} else if (x == 0) {
  print("lt0")
} else {
  print("blah")
}

# CHALLENGE: Write an if statement to test if a number is prime.

# put your code here

##### ifelse #####

# ifelse() is a vectorized version of if with a simpler syntax. The basic syntax of ifelse() is:

ifelse(logical_test, output_when_true, output_when_false)

# ifelse() will still work using single variables:

x <- 5
ifelse(x > 10, "Greater than 10", "Less than 10")

if (x > 10) {
  print("Greater than 10")
} else {
  print("Less than 10")
}

# But it can also test entire vectors:

x <- c(5, -4, 13, 4)
ifelse(x > 10, "Greater than 10", "Less than 10")

# This can be very handy in combination with mutate() which is usually operating on the whole column of a dataframe. For example:

data("midwest") # us (regional) county level dataset

midwest %>%
  mutate(majority = ifelse(popwhite > popblack, "white", "black")) %>%
  group_by(majority) %>%
  summarize(count = n())

midwest %>%
  mutate(prof = ifelse(percprof > 15, "prof", "non-prof")) %>%
  group_by(prof) %>%
  summarize(count = n())

##### case_when #####

# case_when() is the vectorized version of an if statement with additional else ifs attached. It is INCREDIBLY useful for making categorical variables from some sort of continuous range. Any time you're thinking of using nested ifelse, replace it with case_when(). Here's an example of its utility:

case_when(
  x < 10 ~ "Lt 10",
  x > 10 ~ "Gt 10",
  x == 0 ~ "X = 0",
  TRUE ~ "X is none of the above"
)

case_when(
  x > 10 & x < 20 ~ "(10, 20)"
)

x <- 1:100

cut(x, breaks = c(0, 10, 20, 30, 100))

midwest %>%
  mutate(poverty = case_when(
    percbelowpoverty < 10   ~ "Very Low Poverty",
    percbelowpoverty < 15   ~ "Low Poverty",
    percbelowpoverty < 20   ~ "Med. Poverty",
    percbelowpoverty >= 20  ~ "High Poverty",
    TRUE                    ~ "Other"
    )
  ) %>%
  ggplot() +
    geom_point(aes(
      x = percbelowpoverty,
      y = percwhite,
      color = poverty),
    alpha = 0.5
    ) +
  lims(
    y = c(70, 100),
    x = c(0, 40)
  )


##### For Loops #####

# Frequently, when programming, you will find yourself inclined to do the same thing many times. Here is a simple example:

print(paste("The year is", "2013"))
print(paste("The year is", "2014"))
print(paste("The year is", "2015"))
print(paste("The year is", "2016"))
print(paste("The year is", "2017"))
print(paste("The year is", "2018"))

# Try to follow the principle of 'DRY' - Don't Repeat Yourself
# If you ever need to do something more than twice in a row, it should be in a function or for loop

for (i in 1:10) {
  print(i)
}

# We can automate the process above in a 'for' loop.
years <- c("2013", "2014", "2015", "2016", "2017", "2018")

for(year in years){
  print(paste("The year is", year))
}

## Or even better:

for(i in 2013:2018){
  print(paste("The year is", i))
}

## There are four important parts of a for loop:
# OUTPUT
# for(ITERABLE in RANGE){ BODY OF CODE }

# OUTPUT - we will come back to this shortly.
# ITERABLE - usually called 'i', but it can be anything you want. This is the term that will be changing in each iteration of the for loop
# RANGE - this is the series of values over which the for loop will iterate. The iterable will be each value in this range one time.
# BODY - this is the code that runs for each iteration of the for loop. The body of code, encompassed in curly braces {}, runs once for every value of the range.

# Another example - you want to find the square of a series of numbers:

1^2
2^2
3^2
4^2
5^2

# Instead:
for(i in 1:5){
  print(i^2)
}

# NOTE: Without print(), nothing will appear. Automatic printing is turned off within an R function, so we need to use print()

for(i in 1:5){
  if (i > 2) {
    print("Gt 2")
  }
}

# What about for finding even numbers?
# We can use the %% or modulus operator, which returns the remainder, combined with the if statements we learned earlier:

6 %% 2  # 6 / 2 = 3, which has a remainder of 0
7 %% 3  # 7 / 3 = 2.333333 (which is 2 with a remainder of 1)
12 %% 5  # 12 / 5 = 2.4 (which is 2 with a remainder of 2)

for(i in 1:20){
  if(i %% 2 == 0) {
    print(i)
  }
}

# Often, we want to save, not print the results of our for loop. So, before we run the loop, we can create an object in R in which to save the output. This is called pre-allocating your output. It saves time compared to creating a vector inside of your loop and then extending it.
# Create an empty vector first:
output <- numeric(ncol(midwest))

for(i in 1:ncol(midwest)) {
  output[i] <- mean(midwest[[i]], na.rm = TRUE)
  names(output)[i] <- colnames(midwest)[i]
}

output_df <- as.data.frame(output)
output_df

# EXERCISE: One handy use of for loops is to read in all the files in a folder. Write a for loop that reads in all the provided CSVs. Use list.files(), read_csv(), and bind_rows().

list_of_files <- list.files(pattern = "*.csv")

output_df <- tibble()

for(file in list_of_files) {
  df <- read_csv(file)
  output_df <- bind_rows(output_df, df)
}

# NOTE: For loops, while very common and extremely useful, CAN be slower than vectorized functions in some cases. Generally speaking, if a function exists that accomplishes the same thing as your for loop, you should use it.

##### While Loops #####

# Rather than looping over a range of values, a while loop will continue the iterations until the logical returns FALSE:

wins <- 0
while (wins <= 5) {
  if (wins < 5) {
    print(paste(wins, "is not enough, the team does not make the playoffs."))
  } else {
    print (paste(wins, "is enough, the team makes the playoffs."))
  }
  wins <- wins + 1
}

