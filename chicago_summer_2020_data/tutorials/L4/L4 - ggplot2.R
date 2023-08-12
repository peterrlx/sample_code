########################################################################################################
### Programming in R                                                                                 ###
### Lecture 4 - Exploratory Data Visualization                                                       ###
### Austin Wright, The University of Chicago                                                         ###
### Credit: the first iteration of this material was developed by Daniel Snow.                       ###
########################################################################################################

# Always start with the libraries you plan to use in your script!
library(tidyverse)
library(ggplot2)

#######################
####### Overview ######
#######################

# Today will focus exclusively on ggplot, Hadley Wickham's "attempt to take the good things about base and lattice graphics and improve on them with a strong, underlying model"

# This underlying model is the Grammar of Graphics, putting the gg in ggplot.

############## Great ggplot2 Resources ################

# Extremely thorough intro presentation from Princeton: https://opr.princeton.edu/workshops/Downloads/2015Jan_ggplot2Koffman.pdf

# R for Data Science, Data Visualization: http://r4ds.had.co.nz/data-visualisation.html

# ggplot2 introduction from Harvard: http://tutorials.iq.harvard.edu/R/Rgraphics/Rgraphics.html

# Cheatsheet: https://www.rstudio.com/wp-content/uploads/2016/11/ggplot2-cheatsheet-2.1.pdf

# R Color Cheatsheet: https://www.nceas.ucsb.edu/~frazier/RSpatialGuides/colorPaletteCheatsheet.pdf

# Chart type catalog: https://datavizcatalogue.com/

# List of visual encodings: http://complexdiagrams.com/properties

#######################################################


##### Prepping Data and Initial Plots #####

# Load the data and take a 3% sample
enr <- read_csv("enr.csv")
dim(enr)  # 100,000 points is a lot for a scatterplot
enr_lim <- sample_frac(enr, size = 0.03, replace=FALSE)

# Data comes first, easy, ALWAYS a dataframe for ggplot2.
ggplot(enr_lim)

ggplot(data = enr_lim)

enr_lim %>%
  ggplot()

# Aesthetics come next - interestingly, we see an axis! (ggplot has nice defaults)
ggplot(enr_lim, aes(x=read_score))
ggplot(data = enr_lim, mapping = aes(x=read_score))

# A geometry comes next
enr_lim %>%
ggplot(aes(x=read_score, y=math_score)) +
  geom_line()

# This will fail due to a missing y aesthetic
ggplot(enr_lim, aes(x=read_score)) + geom_point()


# Creating our first scatterplot with x and y aesthetics
ggplot(enr_lim, aes(x = read_score, y = math_score))
ggplot(enr_lim, aes(x = read_score, y = math_score)) + geom_point()

# Adding a third aesthetic
ggplot(enr_lim) +
  geom_point(aes(x = read_score, y = math_score, color = ell))

# Usually aesthetics are places within each geom
ggplot(enr_lim) +
  geom_point(mapping = aes(x=read_score, y=math_score, color=ell)) +
  geom_smooth(mapping = aes(x=read_score, y=math_score))


##### Adding More Layers #####

# We can do two layers (aesthetics are inherited from ggplot object)
# Note that legends get created automatically
ggplot(enr_lim, aes(x=read_score, y=math_score, color=ell)) +
  geom_point() +
  geom_smooth()  # geom_smooth creates a regression line

# Only one local average:
ggplot(enr_lim, aes(x=read_score, y=math_score)) +
  geom_point(aes(color=ell)) +
  geom_smooth()

ggplot(enr_lim, aes(x=read_score, y=math_score)) +
  geom_point(aes(color=ell)) +
  geom_smooth(aes(color=ell))

# Options outside of aes() are not aesthetics. Not driven by the data.
ggplot(enr_lim) +
  geom_point(aes(x=read_score, y=math_score, color = ell), color = "blue")

# Changing opacity/transparency of symbol and symbol shape
ggplot(enr_lim) +
  geom_point(aes(x=read_score, y=math_score, shape = ell), alpha = 0.9)

ggplot(enr_lim) +
  geom_point(aes(x=read_score, y=math_score, color = ell), shape = 2, alpha = 0.9)

# Basic scales (annoying default)
ggplot(enr_lim, aes(x=read_score, y=math_score, color=ell)) +
  geom_point(alpha = 0.3)  +
  scale_y_continuous(limits = c(-5, 5)) +
  scale_x_continuous(limits = c(-4, 4))

# Variables type matter! Note that atrisk gives a continuous color scale despite being binary variable. We can fix this with factor()
ggplot(enr_lim, aes(x=read_score, y=math_score, color=atrisk)) +
  geom_point()

ggplot(enr_lim, aes(x=read_score, y=math_score, color=factor(atrisk))) +
  geom_point()

# Same as above but with opacity set lower (more transparent symbol)
ggplot(enr_lim, aes(
  x=read_score,
  y=math_score,
  shape=ell,
  color=factor(atrisk))) +
  geom_point(alpha = 0.5)


##### Using Different Geoms #####

# Different geoms can represent the same underlying data; overlapping coverage masks density; use random jitter to recover density at given point.
ggplot(enr_lim, aes(x=read_score, y=0, color=factor(atrisk))) +
  geom_point(alpha = 0.5)

ggplot(enr_lim, aes(read_score, y=0, color=factor(atrisk))) +
  geom_jitter(alpha = 0.5)

# Adding new geoms and layers to the same plot can help you quickly explore and visualize data
# Here we start with simple histogram
ggplot(enr, aes(x=read_score)) +
  geom_histogram()

# Notice that R warn us to set a bin width for better values (intentional choices = key)

# Then we change the bars so they're easier to read
ggplot(enr, aes(x=read_score)) +
  geom_histogram(binwidth=0.5, colour="black", fill="white")

# Next we add a vertical line at the median of the distribution; but visual is weak
ggplot(enr, aes(x=read_score)) +
  geom_histogram(binwidth=.2, colour="black", fill="white") +
  geom_vline(aes(xintercept=median(read_score)))

# Changing the color of the line
ggplot(enr, aes(x=read_score)) +
  geom_histogram(binwidth=.2, colour="black", fill="white") +
  geom_vline(
    aes(xintercept=median(read_score)),
    color="red",
    linetype="dashed",
    size=1)

# You can continue to move around where information is called to add layers, geoms, and modifiers from here
ggplot(enr) +
  geom_histogram( aes(x=read_score), binwidth=.2, colour="black", fill="white") +
  geom_vline(aes(
    xintercept=median(read_score)),
    color="red", linetype="dashed", size=1)

# It's easy to iterate through different geom types to see which one best displays your data
df <- data.frame(x = c(3,1,5),
                 y = c(2,4,6),
                 label=c("A","B","C"))

g1 <- ggplot(df, aes(x=x, y=y, label=label))

g1 + geom_point()
g1 + geom_text()
g1 + geom_point() + geom_text()
g1 + geom_area()
g1 + geom_tile()
g1 + geom_polygon()
g1 + geom_line()
g1 + geom_path()

##### Building Up Layers #####

# geom_density is similar to a histogram, but shows proportions
ggplot(enr, aes(x=read_score)) +
  geom_density()

# It's very useful for comparing different distribution; notice that our atrisk measure here is a three bin measure
ggplot(enr, aes(x=read_score)) +
  geom_density(aes(fill=factor(at_risk3)))

# It's still hard to read since the distributions overlap so much; remember the ALPHA!
ggplot(enr, aes(x=read_score)) +
  geom_density(aes(fill=factor(at_risk3)), size=0.5, alpha=0.5) +
  scale_y_continuous(expand = c(0, 0)) +
  scale_x_continuous(expand = c(0, 0))

# We can break into separate mini plots with facet_wrap() with a stack
ggplot(enr, aes(x=read_score)) +
  geom_density(aes(fill=factor(at_risk3)), size=0.8, alpha=0.3) +
  scale_y_continuous(expand = c(0, 0)) +
  scale_x_continuous(expand = c(0, 0)) +
  facet_wrap(~factor(at_risk3), ncol = 1)

# or make it wide
ggplot(enr, aes(x=read_score)) +
  geom_density(aes(fill=factor(at_risk3)), size=0.8, alpha=0.3) +
  scale_y_continuous(expand = c(0, 0)) +
  scale_x_continuous(expand = c(0, 0)) +
  facet_wrap(~factor(at_risk3), ncol = 3)

# Add labels with labs()
ggplot(enr, aes(x=read_score)) +
  geom_density(aes(fill=factor(at_risk3)), size=0.8, alpha=0.3) +
  scale_y_continuous(expand = c(0, 0)) +
  scale_x_continuous(expand = c(0, 0), limits = c(-4, 4)) +
  labs(
    title="At-Risk Students Receive Lower Reading Scores",
    caption="Source: DC OSSE Data",
    y="Normalized Reading Scores",
    x="Density"
  )

# Change colors or fill with scale_color_manual() and scale_fill_manual()
ggplot(enr, aes(x=read_score)) +
  geom_density(aes(fill=factor(at_risk3)), size=0.8, alpha=0.3) +
  scale_fill_manual(
    name = "Risk Level",
    values = c("green", "yellow", "red")
  ) +
  scale_y_continuous(expand = c(0, 0)) +
  scale_x_continuous(expand = c(0, 0)) +
  labs(
    title="At-Risk Students Receive Lower Reading Scores",
    caption="Source: DC OSSE Data",
    y="Normalized Reading Scores",
    x="Density"
  )

# Split again using facet_wrap(), notice that the header for each facet doesn't have a label
ggplot(enr, aes(x=read_score)) +
  geom_density(aes(fill=factor(at_risk3)), size=0.8, alpha=0.3) +
  scale_fill_manual(
    name = "Risk Level",
    values = c("green", "yellow", "red")
  ) +
  scale_y_continuous(expand = c(0, 0)) +
  scale_x_continuous(expand = c(0, 0)) +
  labs(
    title="At-Risk Students Receive Lower Reading Scores",
    caption="Source: DC OSSE Data",
    y="Normalized Reading Scores",
    x="Density"
  ) +
  facet_wrap(~factor(at_risk3), nrow = 3) +
  theme(legend.position = "none")

# We can fix the labels using factors
library(forcats)

# Note here that we can save our entire plot to a variable
plot <- enr %>%
  mutate(at_risk3 = fct_recode(
    factor(at_risk3),
    High = "2",
    Medium = "1",
    Low  = "0"
    )
  ) %>%
ggplot(aes(x=read_score)) +
  geom_density(aes(fill=at_risk3), size=0.8, alpha=0.3) +
  scale_fill_manual(
    name = "Risk Level",
    values = c("green", "yellow", "red")
  ) +
  scale_y_continuous(expand = c(0, 0)) +
  scale_x_continuous(expand = c(0, 0)) +
  labs(
    title="At-Risk Students Receive Lower Reading Scores",
    caption="Source: DC OSSE Data",
    y="Normalized Reading Scores",
    x="Density"
  ) +
  facet_wrap(~at_risk3, nrow = 3) +
  theme(legend.position = "none")

# Display the `plot' produced with headings for values
plot

##### Themes #####

# Adding a theme will change the look of much of your plot. You can create custom themes, use pre-made ones, or do both:

# Some handy theme resources:

# The ggplot2 theme reference: https://ggplot2.tidyverse.org/reference/theme.html
# List of available ggplot2 themes: https://ggplot2.tidyverse.org/reference/ggtheme.html

plot +
  theme_bw()

plot +
  theme_dark()

# Make changes to a theme using the theme() function
plot +
  theme_bw() +
  theme(
    legend.position = "left",
    panel.grid.minor = element_blank()
  )


##### More Plot Types #####

# Creating a starter plot with no geom
plot2 <- ggplot(enr,
  aes(
    x=factor(atrisk),
    y=read_score,
    fill=factor(atrisk))
  ) +
  scale_fill_manual(values = c("#800000","#000080"))

# Box plot
plot2 +
  geom_boxplot()

# Violin plot; beautiful
plot2 +
  geom_violin()

# geom_tile() can be useful showing variation across categories
enr %>%
  ggplot() +
  geom_tile(aes(x = grade, y = at_risk3, fill = math_score))

# But that plot looks messed up (ie, missingness, weird color scale), let's use factors and filter() to clean it up
enr %>%
  filter(as.numeric(grade) >= 9) %>%  # filter out low grades for which data is missing
  ggplot() +
  geom_tile(aes(
    x = fct_rev(grade),
    y = factor(at_risk3),
    fill = math_score)
  ) +
  scale_y_discrete(expand = c(0, 0)) +  # remove axis padding
  scale_x_discrete(expand = c(0, 0)) +
  scale_fill_distiller(palette = "Spectral") + # change the color palette
  labs(
    x = "Grade Level",
    y = "Risk Score"
  )



