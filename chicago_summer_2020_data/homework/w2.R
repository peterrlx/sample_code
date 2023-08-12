# Week 2 Homework
# Rongli_Xue

library(tidyverse)

#### Question 6 ####
diamonds <- diamonds
carat <- diamonds$carat
price <- diamonds$price
my_vector<- c(length(price),sum(price),mean(price),median(price),var(price),sd(price),min(price),max(price))
View(my_vector)

#### Question 7####
annual_returns<-c(0.11, 0.06, 0.15, 0.09, -0.03, -0.02, 0.25)+1
revenue<-data.frame(cumprod(annual_returns)*5000)
View(revenue)
# The amount of money at the end of each year for the next 7 years is shown in the data frame "revenue".

#### Question 8####
#8a#
starwars <- starwars
starwars2<- starwars %>% filter(eye_color!='blue'& skin_color!='pale')
view(starwars2)
#8b#
condion1<- starwars %>% filter(hair_color=='brown'& skin_color=='fair')
condion2<-starwars %>% filter(hair_color=='black'& skin_color=='dark')
starwars3<-merge(condion1,condion2,all.x=TRUE,all.y=TRUE)
view(starwars3)

#### Question 9 ####
starwars4<-starwars%>%
  group_by(homeworld)%>%
  mutate(count=n())%>%
  summarize(average_height=mean(height,na.rm=T),minimum_mass=min(mass,na.rm=T))
view(starwars4)

#### Question 10 ####
starwars5<-starwars%>%
  filter(is.na(hair_color))%>%
  group_by(homeworld)%>%
  summarise(avr_height=mean(height,na.rm=T))%>%
  arrange(desc(avr_height))
view(starwars5)

#End