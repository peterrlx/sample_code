# Week 4 Homework
# Rongli_Xue

library(tidyverse)
library(ggplot2)

#### Question 4 ####

diamonds<-diamonds 
ggplot(diamonds,aes(x=carat, y=price,color=cut))+
  geom_point(alpha = 0.5) 


#### Question 5####

ggplot(diamonds,aes(x=carat, y=price,color=cut))+
  geom_hex(alpha=0.5)+
  scale_fill_gradient(trans = "log")

#### Question 6####

#a)

ggplot(diamonds) +
  geom_point(aes(x=carat,y=price,color=cut), size=0.6, alpha=0.8) +
  facet_wrap(~cut, nrow = 5)

#b)

ggplot(diamonds,aes(x=carat,y=price,color=cut), size=0.6, alpha=0.8) +
  geom_point() +
  facet_wrap(~cut, nrow = 5)+
  geom_smooth(formula=y~x,method = lm,color="red")
 
#### Question 7 ####

 ggplot(diamonds)+
  geom_boxplot(aes(x=cut,y=price))

#### Question 8 ####

#a)

library(nycflights13)
flights <- flights[1:100,]
ggplot(data = flights) +
  geom_bar(mapping = aes(x = dest)) +
  labs(title="Destination distribution of the first 100 flights out of New York in 2013")

#b)

ggplot(data = flights) +
  geom_bar(mapping = aes(x = dest)) +
  labs(title="Destination distribution of the first 100 flights out of New York in 2013")+theme(axis.text.x = element_text(angle = 90))
  

####End####