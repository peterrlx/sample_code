# Homework for "Programming in R" at UChicago summer school in 2020

# The following code needs to be run by using auxiliary datasets (e.g., importing .xls, .shp files). Notice that since the datasets are not in the current repo, running the code directly may produce errors.

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



# Week 6 Homework
# Rongli Xue

library(sf)
library(tmap)
library(tidyverse)
library(ggplot2)

#### Question 5 ####
comarea <- st_read("ComArea_ACS14_f.shp")
plot(comarea[c("community","geometry")])
# The result is a graph of basic geometry of Chicago neighborhoods.

#### Question 6 ####
new_comarea <- comarea %>% 
  mutate(chldpov.density = ChldPov14/shape_area)%>%
  group_by(ComAreaID) %>%
  summarize(chldpov.density)

#### Question 7 ####
# NOTE: Here I break the "chldpov.density" into quantiles for easier viewing using the ntile() function.

new_comarea<-new_comarea %>%
  mutate(qtile = factor(ntile(chldpov.density, 7)))

### Use tmap package to plot the map.###
tm_shape(new_comarea)+
  tm_borders("grey40", lwd = 1)+
  tm_fill(col = "qtile", palette = "YlGn")+
  tm_scale_bar(text.size = 0.5,position=c("right", "top"))+
  tm_compass(type = "arrow", position=c("right", "top"))+
  tm_layout(title= 'Child poverty density in Chicago',title.position=c('right','bottom'),title.bg.color='Yellow')

### Use geom_sf package to plot the map.###
new_comarea %>%
  ggplot()+
  geom_sf(aes(fill=qtile))+
  scale_fill_brewer(palette = "YlGn",direction=1) +
  scale_color_brewer(palette = "YlGn",direction=1) +
  theme_void() +
  labs(title = " Child poverty density in Chicago")

### As you can see, the two graphs above (plotted in different ways) are almost the same.

#### Question 8 ####
groceries <- st_read("groceries.shp")
groceries_crs <- st_crs(groceries)

### Q8(a)
x <- st_transform(groceries,4326)
y <- st_transform(new_comarea,4326)

### Q8(b)
x<-st_geometry(x)
tm_shape(y,add=TRUE)+
  tm_borders("grey40", lwd = 1)+
  tm_fill(col = "qtile", palette = "YlGn")+
  tm_shape(x,add=TRUE)+
  tm_dots(col = 'red',size=0.09,alpha=0.9)+ 
  tm_layout(title= 'Child poverty density + grocery store location in Chicago',title.position=c('right','bottom'))


####End####