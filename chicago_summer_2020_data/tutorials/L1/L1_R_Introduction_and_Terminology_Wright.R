########################################################################################################
### Programming in R                                                                                 ###
### Lecture 1 - R Introduction and Concepts                                                          ###
### Austin Wright, The University of Chicago                                                         ###
### Credit: the first iteration of this material was developed by Daniel Snow.                       ###
########################################################################################################


##########################
####### R Concepts #######
##########################

## This is a comment.
# Everything after a # (a hashtag) will have no effect if you run it in R.
# I have comments preceding all the following commands to explain what they do.
# In order to more easily read these comments:
# Click Tools >> Global Options >> Click the 'Code' Tab >> Check 'Soft-wrap R Source Files' >> Click 'Apply'

# TIP: You can comment (or uncomment) lines or highlighted areas in RStudio using Cmd + Shift + C or Ctrl + Shift + C on Windows

# TIP: To run a single line of code, put your cursor on the line you want to run, then hit "Run" in the top right corner of the console.
# Alternatively, use the keyboard shortcut Cmd + Enter or Ctrl + Enter on Windows

## Today we will cover basic concepts and terminology, including:
# 1. Vocabulary
# 2. Different RStudio panes and their functions
# 3. Using R as a calculator
# 4. Data types
# 5. Vectors and lists
# 6. Logical comparison
# 7. Loading and viewing a dataframe
# 8. Accessing data in a dataframe
# 9. Manipulating data in a dataframe
# 10. Installing and loading packages
# 11. Best practices
# 12. Getting help


##########################
####### Vocabulary #######
##########################

## Let's start with some simple vocabulary:
# - Working Directory : The folder on your computer that R is currently working in.
#   It will only check this folder for files to load, and will write any new files to this folder.
# - Vector : the basic unit of data storage in R. It contains a list of data points all of the same type.
# - List : similar to a vector, but can contain many different types of data
# - Dataframe : the R equivalent of an excel file. It holds relational data in rows and columns that can contain numbers or strings.
# - Assignment Operator '<-' : Gives the value on the right to the object on the left.

x <- 5
x = 7

y <- 9

# - Function : Anything that completes a task or set of tasks in R is a function. Most functions have a name, and take one or more arguments
#   within parentheses. Examples include 'head()', 'colnames()', 'hist()', 'mean()', 'and plot()'
# - Argument : An input or an option that affects the result of a function. This often includes the data that the function runs on,
#   AND specifications/options as to what the function should do. For example:

# do_this(to_this, like_this, with_those)  # this won't actually run

# The function above is given three arguments, separated by a comma. The first argument of a function is (usually) what it will be applied to,
# followed by options for modifying its output. We'll use some functions in a bit when we load a dataframe.

# Remember there are lots of sample data sets in R you can use to practice - you can see those by typing in data() and then looking at the list that appears
# To load a sample data set already in R, type in data(name_of_dataset) to load it, and then you can refer to it by that name.


###############################
### Using R as a Calculator ###
###############################

## You can do basic calculations in R

2 + 2  # addition

4 - 2  # subtraction

4 * 2  # multiplication

5 ^ 3  # exponentiation

5 ** 4  # same as ^

9 %% 4  # modulus operator (take the remainder) 模运算，取余数

9 %/% 4  # integer division (floor)

## And you can save things as variables using the assignment operator: <-

x <- 5
x
x * 2
x * x ^ x


###############################
######### Data Types ##########
###############################

## R supports many different types of numbers, including:

1  # integers
98

8.5  # floats
1.1

1 + 2i  # complex

## Besides numbers, R can also handle other data types, including:

"strings"  # characters, words or even numbers. Always wrapped in quotes
"cat"
"dog"

TRUE  # logical values that correspond to 1 (TRUE) or 0 (FALSE)
FALSE
TRUE + TRUE + TRUE * 3 # Don't forget PEMDAS (R won't)

# TIP: You can check the datatype of an object in R using class()

class(5.5)
class(1 + 9i)
class("dog")
class(FALSE)

## R also handles dataframes, which are the columnar data type for R (data is stored in rows and columns).
#  Dataframes can have many different types of data stored in them and can easily be subset using tidyverse functions (what we'll learn).
#  Matrices are a similar datatype. They store data in rows and columns, however they only contain one type of data (typically numbers).
#  We likely won't see any matrices in this class.

x <- data.frame(rbind(c(1, 2, 3), c(4, 5, 6)))
x <- data.frame(cbind(c(1, 2, 3), c(4, 5, 6)))
matrix(c(c(1, 2, 3), c(4, 5, 6)), nrow = 2, byrow = TRUE)

## There are also a few other datatypes that we'll work with, including dates and datetimes.
#  R stores datetime information as an integer (unix epoch time, the number of days or seconds since Jan 1, 1970),
#  but displays it to us a date + a time. These can be a huge headache to work with.

as.numeric(as.Date('1950/06/25')) # This is a date, stored as the number of days since Jan 1, 1970
as.Date('2020/06/25') + 10

as.numeric(as.POSIXlt("2020-06-25 13:30:30"))  # This is a datetime, stored as the number of seconds since Jan 1, 1970
as.POSIXlt("2020-06-25 13:30:30") + 30


###############################
###### Vectors and Lists ######
###############################

## the c() function means combine, it will combine comma-separated arguments into a vector.
#  NOTE: All data points inside c() will be coerced to the same type. Vectors which contain all the same type of data are known as atomic vectors

y <- c(1, 2, 3)
z <- c("cat", "dog", "fish", "cat")
w <- c("cat", "mouse", 3)
w <- list("cat", "mouse", 3)

# if you enter 'y' in R, you will see it is a list of 1,2,3
# if you enter 'z' in R, you will see it is a list of four words
# if you enter 'w' in R, you will see it is a list of three "words", with 3 coerced into a string

y
length(y)  # returns the number of items in y


z
length(z)
table(z)  # returns a frequency table of z


w
length(w)
table(w)
w * 2

## Saving w as a list() instead will allow for mixed types

w_list <- list("cat", "mouse", 3)
length(w)
w * 2

## We can subset a vector or list using brackets to extract a specific element
## NOTE: Unlike many other languages, R starts its indexing at 1, this means that if you trying to determine
#  the position of an item in a list, the first item will always be 1.

y[1]  # get the first value
y[2]  # get the second value
y[3]

## NOTE: When subsetting a list, brackets [ ] will always return another list. If you want to access the values
#  inside the list, you must use double brackets [[ ]].

w_list[3]
w_list[[3]] * 3
w_list[c(1,3)]  # subsetting with a list to get the first and third values
w_list_sub <- length(w_list) - 1
w_list[]  # omit the elements at the specified position
w_list[c(1, 1)]  # duplicate indices yield duplicate results

y[c(TRUE, FALSE, TRUE)]  # You can also subset with a vector of logical values
y[c(TRUE)]  # This vector of length 1 will be repeated since it's not the same length as the vector it's subsetting

y_long <- c(1:15) ^ 2  # list all numbers between 1 and 15 squared
y_long
y_long[c(1, 10, 12:15)]  # get values from positions 1, 10, and 12 to 15
y_long %in% c(9, 16, 121)  # return the original list, but with TRUE where the value of y_long is IN the second list and FALSE elsewhere

y_long[y_long %in% c(9, 16, 121)]  # subset the original list using the logical vector created above

## Elements of a list or vector can also have names. This is somewhat equivalent to a dictionary in python. Named lists can be
#  subset by their names. Dataframes are basically a list of named columns.

named_list <- list("dog" = 1, "cat" = 2, "human" = 3, "cow" = "grass")

# These elements can be accessed in the usual way using brackets OR they can be accessed using $, followed by the name. These two statements are equivalent:

named_list[[3]]
named_list$human

# You'll often use $ to access the columns of a dataframe


###############################
###### Logical Comparison #####
###############################

## Nearly all programming languages include some form of logical comparison, and R is no different.
#  It uses a variety of "logical operators" to compare numbers, words, and lists. These can be common expressions, such as >, <, >=, or things like %in% or &&.
#  These logical operators are often combined together to subset a larger dataset, e.g. I want all people older than 25 but younger than 50 with brown hair.

## Here's a handy guide to various operators: https://www.statmethods.net/management/operators.html

## NOTE: Logical operators will ALWAYS output TRUE or FALSE.

x
x == 5  # x is exactly equal to 5
x >= 5  # x is greater than or equal to 5
x > 5  # x is greater than 5
x < 5  # x is less than 5
x != 5  # x is not equal to 5
!TRUE  # exclamation point is always used as negation
!x != 5

TRUE == 1  # TRUE is always equal to 1
TRUE < 0

## Logical comparisons also work on vectors and lists, and this is likely where you'll use them the most.
y_long <- 1:15  # Note that this replaces the y_long from earlier
w_list <- list(1, 5, 9, "cat", "dog", TRUE)  # And this replaces the w_list from earlier

y_long == 5  # Only the number 5 will be TRUE
y_long > 5  # All greater than 5 will be TRUE
y_long != 5  # All not equal to 5 will be TRUE

w_list > 3  # No output for strings in the list (we get NAs instead)
w_list == "dog"  # FALSE for all values except "dog"

## You can use these logical operations to subset larger lists by combining them with the brackets from earlier.
#  If we only want to get the values greater than 5 from y_long, we can do:

y_long[y_long > 5]  # only values of y_long greater than 5
w_list[w_list %in% c("cat", "dog", 1)]  # return values of w_list IN the second list

## Subsetting can become very complex. Here we only get elements of w_list that are strings, such as "dog" and "cat"
w_list_characters_only <- unlist(lapply(w_list, is.character))
w_list[w_list_characters_only]

## String comparison can get extremely weird and confusing:
"dog" > "cat"  # TRUE, because d comes after c
"apple" > "cat" # FALSE, because a comes before c
"cat" > 4  # TRUE, because 4 is converted to a character for the comparison
"cat" > "4"

## most often with strings you'll be doing direct equivalency comparison such as "==". This is useful for filtering
#  datasets to retain specific values or exclude others
"cat" == "dog"
"cat" == "cat"
w_list == "cat"

## Logical operators can be combined using things like & (and), | (or), and xor() (exclusive of). This will combine
#  the logical conditions and output a logical vector that meets all of them, for example:

x == 5 & x > 2  # TRUE, x is both equal to 5 and greater than 2
x > 2 & x < 4  # FALSE, x is greater than 2 but is NOT less than 4
x > 2 | x < 4  # TRUE, x is greater than 2, one condition is met, so TRUE

# This can be used to great effect when subsetting:

y_long > 5 & y_long < 10  # Returns TRUE for numbers 6 to 9
y_long[y_long > 5 & y_long < 10]

y_long_subset <- y_long >= 12 & y_long != 14 | y_long < 5  # What numbers will this output?
y_long[y_long_subset]

# All of these operators can be combined into complicated subsets
y_long[!y_long %in% c(3, 7, 14) & y_long >= 2 & y_long != 8]


#####################################
## Loading and Viewing a Dataframe ##
#####################################

## This will change your working directory - that is, it will change the default location that R will look for data files.
##
## setwd("/Users/YourUserName/Desktop")
## setwd("C:/Users/YourUserName/Desktop")
setwd("/Users/austinlw/Harris-Public-Policy Dropbox/Austin Wright/Summer_Scholars/Lecture_Materials_2020/coding_lectures/Lecture 1 - Introduction to R")

## This command tells you the current working directory. Use it to make sure that the above command worked properly.
getwd() ## Keep this empty!

## Use read.csv to read in your data. If you have navigated to the correct working directory (where you data is located) you
#  will only have to put the name of the data file in the quotes.

## data <- read.csv("name_of_your_datafile.csv")

pov <- read.csv("poverty.csv")

## Alternatively, you can use a browser window to navigate to your file, like so:
pov <- read.csv(file.choose(), header = TRUE)

## If you type the name of the data as you saved it, the entire data file will appear. Remember the name of the data file,
#  (in this case I used 'pov') is totally arbitrary, and can be anything you want it to be.

pov

# Alternatively, View(pov) will open a new window where you can see the data.
View(pov)

## Returns the first 6 lines of your data
head(pov)
head(pov, n = 10)  # now 10 lines

## Returns the names of columns of your data
colnames(pov)

## Returns the number of rows, then columns, of your data. You can generally assume R is indicating rows first, then columns:
dim(pov)


#####################################
### Accessing Data in a Dataframe ###
#####################################

## Just like with vectors and lists, you can subset a dataframe using brackets and item positions (their index values).
#  The difference is we're now working in two dimensions, so we must include multiple dimensions of subsetting arguments.
#  For a dataframe, you can specify individual rows and columns (again rows first and columns second) using brackets, like so:

pov[1,1]  # returns the cell in the first row and first column
pov[1] # returns the first column. Remember, dataframes are just lists of columns
pov[1,]

pov[2,1]  # returns the cell in the second row and first column
pov[2,2]  # returns the cell in the second row and second column

## We can specify a range of the data using brackets and a colon
pov[1:3,2]  # returns the first 3 rows of column 2
pov[,2]  # returns the entire second column

## Just like with named lists, you can use the dollar sign to specify a column name. Below, you can see the 'Country'
#  column being referenced. This shorthand (dataframe$column_name) is very useful, and we will use it often.
pov$Country

## We can use the subsetting rules we learned earlier on dataframes as well to extract only the specific parts we want:
pov[pov$Country %in% c("Mexico", "France", "Iran"),]  # get only rows for the specified countries

pov[1:50,colnames(pov) == "BirthRt" | colnames(pov) == "Country"]  # get only the first 50 rows of birthrate and country name

## You can create new dataframes using the assignment operator "<-", like the line below. This creates a limited subset of the
#  original data, called 'lim', which only consists of the data where Region is equal to "Europe Mostly"
lim <- subset(pov, Region == "Europe Mostly")

## R has some built-in functions to make subsetting easier. Here we create a new dataframe using multiple subset conditions:
lim <- subset(pov, (Region == "Europe Mostly" & LExpM <= 68) |
                   (Region == "Asia" & InfMort < 15))

## The which() function will return the indices of a logical vector where TRUE
which(c(TRUE, TRUE, FALSE, TRUE))

# This can be used to subset dataframes where a logical condition is met
pov[which(pov$LExpM > 74),]  # Get only countries with a male life expectancy over 74
pov[order(pov$BirthRt)[1:10],]  # Get 10 countries with the lowest birth rate
pov[order(pov$BirthRt, decreasing = TRUE)[1:10],]


########################################
### Manipulating Data in a Dataframe ###
########################################

## You can see how long the column is:
length(pov$Region)

## Or get all the unique values in that column:
length(unique(pov$Region))

## Or make a frequency table to see all the unique values and how often they appear:
table(pov$Region)

## If the column is a number, you can use functions to get the sum, average, median, standard deviation, five number summary, or range:
sum(pov$GNP, na.rm=TRUE)  # sum
mean(pov$BirthRt)  # average
median(pov$BirthRt)  # median
sd(pov$LExpM)  # standard deviation
range(pov$GNP)  # range
range(pov$GNP, na.rm=TRUE)
fivenum(pov$LExpM)  # five number summary

## Column aggregations by group - hm, this is getting a bit confusing:
aggregate(pov$GNP, by=list(pov$Region), FUN=mean, na.rm=TRUE)
aggregate(pov$InfMort, by=list(pov$Region), FUN=median, na.rm=TRUE)
aggregate(pov$LExpM, by=list(pov$Region), FUN=sd, na.rm=TRUE)

pov$new_column <- c(1, 2)

## Creating a new column:
pov$DeathRt_over10 <- 0  # Set all values to 0
pov$DeathRt_over10[which(pov$DeathRt > 10)] <- 1  # Conditionally change some to 1

## You can look at a histogram of a column
hist(pov$DeathRt)
hist(pov$DeathRt, breaks=10) # Sets number of bins
hist(pov$DeathRt, breaks=30, main = "Histogram of Country Death Rates")

## You can plot two columns together in a scatterplot using
plot(pov$LExpM, pov$LExpF)

## You can write new data to a new file using write.csv. That new file would appear in your current working directory.
write.csv(lim, file = "new_file.csv", row.names=FALSE)

## Reading in and merging on a second dataframe:
gnp_pc <- read.csv("gnp_pc.csv")

pov$Country %in% gnp_pc$Country
table(pov$Country %in% gnp_pc$Country)

pov2 <- merge(pov, gnp_pc, by = "Country")
dim(pov2)

## Variable Creation
pov2$gnp_pc_log <- log(pov2$gnp_pc)
pov2$gnp_pc_sqrt <- sqrt(pov2$gnp_pc)
pov2$gnp_pc_squared <- (pov2$gnp_pc) ^ 2


##########################################
## Installing and Loading Packages in R ##
##########################################

## To install an R package, run:
install.packages("package_name")
## You only have to do this once.

## To load the functionality of that package into an R session, run:
library("package_name")
## You have to do this in every R session where you want to use this package.
#  You load the packages you're using for a given session a lot like you'd load a backpack: you only pack what you need.

## Let's try with the dplyr package, which is for working with dataframes. The term dplyr refers to 'plyr for dataframes'
install.packages("tidyverse")
glimpse(pov)

# This didn't work! Why? You need to both install the package (once) and load the package (everytime you want to use it).
library(dplyr)
library(tidyverse)


glimpse(pov)

# TIP: Generally speaking, every script should begin with library() functions that load the packages used in that script.


############################
##### R Best Practices #####
############################

## 1. ALWAYS use projects
# Using projects makes your work far more organized, more reproducible, and more reusable. You should rarely, if ever, use setwd().

## 2. Name files something meaningful
#  Instead of "analysis.R", name your file something meanful. Try to describe what the script actually does in as
#  few words as possible, i.e. "00_load_data.R" or "04_create_models.R".

## 3. Always comment your code
#  Not only will commenting make your code easier for other people to understand, it will also make it easier for you to understand
#  6 months later when you've forgotten what you wrote. Comment everything, including analysis decisions, missing data drops, different steps in your analysis, etc.

## 4. Don't save .RData (your environment)
# When writing R code, you should ideally be creating scripts that, when run, will precisely reproduce your analysis.
# There's very rarely a reason to save your environment (your .RData) since the script should reproduce your work.


############################
####### Getting Help #######
############################

## Most R functions are well-documented. To read the documentation and see their different arguments, you can use help() or ?function_name.
#  These will load the documentation in the help pane. I use this frequently, even as an experienced programmer. It's simply impossible to remember all the syntax and arguments of every function.

help("read.csv")
?read.csv
?table
?read_csv

# Some documentation is better than others. The tidyverse documentation tends to be very good. Base R's documentation is often lacking.

## The internet is your friend when you get stuck on a coding problem. Stack Overflow, Google, and R Bloggers are all great resources
#  when looking for answers. Knowing how to google a coding question and get useable results is a skill in and of itself. Try to be as specific as possible. For example:

# "filter with multiple values in a list R dplyr" is a great seach and returns useful results
# "subset with list in R" is okay, but will return older, base R results
# "subset with list" will return lots of non-R results

## If you encounter a specific error when running your code, try googling the error in full. Often you'll find other people that encountered the same problem as you + a posted solution.


################################################
## Introduction to Data Analysis in R's dplyr ##
################################################

glimpse(pov)

filter(pov, Region == "Africa") ## Row Subsetting
arrange(pov, LExpM) ## Row Ordering
select(pov, Region, Country, LExpM, GNP) ## Column Selection
## Did pov change?

## No! There was no assignment.
## Row ordering with assignment:
pov <- arrange(pov, LExpM)
glimpse(pov)

## Chain operator (we'll cover this more later):
new_data <- pov %>%
  filter(Region == "Africa" | Region == "Eastern Europe") %>%
  select(Region, Country, LExpM, GNP) %>%
   arrange(LExpM)
## We will cover dplyr more tomorrow, here's a more thorough introduction to dplyr:
## http://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html

## Another example of why you want to use packages: Reading in SAS/STATA/SPSS Files w/ the Haven package.
install.packages("haven")
library(haven)

sas_data <- read_sas("path/to/file")
stata_data <- read_dta("path/to/file")
spss_data <- read_sav("path/to/file")
## https://cran.r-project.org/web/packages/haven/README.html

## Additionally, the read_csv() function of reader is significantly better than the base R version. It can even read CSVs directly from the internet:
library(readr)
cabinet <- read_csv("https://raw.githubusercontent.com/fivethirtyeight/data/master/cabinet-turnover/cabinet-turnover.csv")

