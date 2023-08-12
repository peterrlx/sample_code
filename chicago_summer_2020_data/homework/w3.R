# Week 3 Homework
# Rongli_Xue

library(tidyverse)

#### Question 5 ####
diamonds <- diamonds
temp<-diamonds%>%
  filter(cut=='Fair'|cut=='Ideal',price>3000)%>%
  group_by(color)%>%
  summarize(average_price = mean(price),count=n())
view(temp)

#### Question 6####
new_table5<-table5%>%
  unite(year,century,year,sep='')%>%
  separate(rate,into=c("cases", "population"))%>%
  mutate(year=as.integer(year),
         cases=as.integer(cases),
         population=as.integer(population))
identical(table1,new_table5)#The result shows that table 5 has been turned into table 1, and now they are the same.
view(new_table5)

#### Question 7####
new_table2<-pivot_wider(table2,names_from=type,values_from=count)
identical(new_table2,table1)#The result shows that table 2 has been turned into table 1, and now they are the same.
view(new_table2)

#### Question 8 ####
table6 <- table4a %>%
  pivot_longer(cols = "1999":"2000",
               names_to = "year",
               values_to = "cases")
table7 <- table4b %>%
  pivot_longer(cols = "1999":"2000",
               names_to = "year",
               values_to = "population")
new_table<-table6 %>%
  left_join(table7, by = c("country" = "country","year"="year"))%>%
  mutate(year=as.integer(year))
identical(new_table,table1)#The result shows that the new table has been turned into table 1, and now they are the same.
view(new_table)

#### Question 9 ####
#9a
levels(diamonds$cut)
#9b
new_cut<-recode(diamonds$cut,'Very Good'='Superb')
new_diamonds<-mutate(diamonds,cut=new_cut)
levels(new_diamonds$cut)
#The final result of question 9 can be found in the console panes.

#End