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