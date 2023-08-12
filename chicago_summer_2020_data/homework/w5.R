# Week 5 Homework
# Rongli_Xue

library(tidyverse)
library(broom)
library(jsonlite)
library(purrr)

#### Question 5 ####
diamonds<-diamonds%>%
  mutate(idealcut=ifelse(cut=='Ideal','TRUE','FALSE'))
view(diamonds)

#### Question 6 ####
t.test(diamonds$price[diamonds$idealcut == 'TRUE'], diamonds$price[diamonds$idealcut == 'FALSE'])
# The result shows that the difference in means of price across two groups is statistically significant.

#### Question 7 ####
reg_model<-lm(price~idealcut+carat+idealcut*carat,data=diamonds)
x<-glance(reg_model)
x[2]
# The result shows that the adjusted R-squared of the model is 0.853.

#### Question 8 ####
##Note: For question 8, select and run the codes line 27 to 38.The R console will first ask you to enter the year for the crime data (For example, you can enter 2018,or any given year that is available). After you enter the year, wait for about 10 seconds, the data frame of crime for that year will eventually show up.

{
crime<-function(year){
   url <- paste("https://data.cityofchicago.org/resource/ijzp-q8t2.json?year=",year,sep='')
   df <- read_json(url, simplifyVector = TRUE)
   df <- df[,-22] #Here I dropped the three columns named "location.latitude", "location.longitude", and "location human_address ".
   view(df)
};
  year<-as.numeric(readline(prompt = "This is Question 8, please enter the year (E.g. 2018): "))
  ;
  print('Please wait ... The data frame for this year will show up in a few seconds');
crime(year)
}


#### Question 9 ####
##Note: For question 9, select and run the codes line 44 to 52. Wait for about 20 seconds, and the new data frame will eventually show up.

crime<-function(year){
  url <- paste("https://data.cityofchicago.org/resource/ijzp-q8t2.json?year=",year,sep='')
  df <- read_json(url, simplifyVector = TRUE)
  df <- df[,-22]#Here I dropped the three columns named "location.latitude", "location.longitude", and "location human_address ".
  df
}
year<-2018:2020
crime_18_20<-map_dfr(year, crime)
view(crime_18_20)

####End####