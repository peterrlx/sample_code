#######################################################################################################
### Programming in R                                                                                 ###
### Lecture 9 - Working with Spatial Data                                                            ###
### Austin Wright, The University of Chicago                                                         ###
### Credit: the first iteration of this material was developed by Daniel Snow.                       ###
########################################################################################################

library(sf)
library(tidyverse)
library(tidycensus)

###########################
######### Overview ########
###########################

# Today we'll be covering the basics of spatial data using R's simple features (sf). The sf help manual can be found here: https://r-spatial.github.io/sf/ and is very useful, please read it!

# 1. Loading and plotting shapefiles
# 2. Attaching more data
# 3. Spatial joins
# 4. Better map plots
# 5. Other geometric operations
# 6. Mapping with Census data


##### Loading and Plotting Shapefiles #####

# Most vector spatial data still comes in the shapefile format. Shapefiles are separated into multiple files in a directory. All the components of the shapefile (.shp, .dbf, .proj) must be in the same directory to be read.

# Unzipping the Chicago shapefiles
unzip("chicago_tracts_2010.zip")

# Reading in the shapefile. Note the geometry column, this is what stores the coordinates that make up a shape
chicago_gdf <- st_read("chicago_tracts_2010.shp")

glimpse(chicago_gdf)

# Plotting the 'commarea' column of our shapefile, this shows all 77 Chicago community areas
plot(chicago_gdf["commarea"])

# plot() will always plot every column unless you tell it a specific one
plot(chicago_gdf)


##### Attaching More Data #####

# Generally speaking, you will need to join interesting data TO a shapefile in order to create meaningful plots. We can accomplish this using the simple joins (left_join, right_join, etc...) that we learned earlier.

# Loading some more interesting data on Chicago incomes
chicago_income <- read_csv("chicago_tracts_income.csv")
glimpse(chicago_income)

# Columns of data imported with sf sometimes start as factors, we should convert them to characters
chicago_gdf <- chicago_gdf %>%
  mutate(
    geoid = as.character(geoid),
    commarea = as.character(commarea)
  )

# Same for the income data imported with read_csv. Must use characters so that leading zeroes are not dropped. as.numeric() will drop leading zeroes
chicago_income <- chicago_income %>%
  mutate(geoid = as.character(geoid))

# Geospatial dataframes are just like normal ones. They can be filtered, joined, and mutated, but ONLY st_ functions will work on the geometry column.
chicago_gdf <- left_join(chicago_gdf, chicago_income, by = "geoid")
glimpse(chicago_gdf)

# Plot the new columns added to our spatial data frame
plot(chicago_gdf["total"])
plot(chicago_gdf[4])
plot(chicago_gdf["per_under_25k"])

## Plot them side-by-side for comparison, they're very different maps
plot(chicago_gdf[c("total", "per_under_25k")])

# Plot a random sample of half the rows in our dataframe, note that each row is equal to one shape
chicago_gdf_sample <- chicago_gdf %>%
  sample_frac(0.5)

plot(chicago_gdf_sample["per_under_25k"])

# Now let's read in some point data, note that this isn't a spatial data frame
chicago_permits <- read_csv("chicago_latlon_permits.csv")

# We need to convert the latitude and longitude here into a geometry column. Latitude and longitude almost always use the CRS 4326
chicago_permits <- st_as_sf(
  chicago_permits,
  coords = c("longitude", "latitude"),
  crs = 4326)
glimpse(chicago_permits)

# Don't plot the whole dataframe, it may take a long time
chicago_permits_sample <- chicago_permits %>%
  sample_frac(0.1)

# As you can see, most permits aren't for very expensive things, but let's see where the expensive development is happening
plot(chicago_permits_sample["estimated_cost"])

# Filter the data so that only 99th quantile of projects remain
chicago_permits_sample <- chicago_permits_sample %>%
  filter(estimated_cost >= quantile(
    chicago_permits_sample$estimated_cost, 0.99))

# Now we can see a trend, but it's still hard to visualize. There are too many points and no points of reference (roads, boundaries, etc.)
plot(chicago_permits_sample["estimated_cost"])

chicago_permits_sample %>%
  ggplot() +
  geom_sf(aes(color = estimated_cost))

##### Spatial Joins ######

# We can somewhat solve this problem by performing a spatial join, merging the boundary data of the tract shapes with the point data of the permits. This will display aggregated data using larger geometries, rather than individual points.

# First reload the tract data to get rid of the data we added to it
chicago_gdf <- st_read("chicago_tracts_2010.shp")

# We must set the CRS of the read Chicago tracts file before performing a join. Spatial joins only work on two geometries with the same CRS
chicago_gdf <- st_transform(chicago_gdf, 4326)

# To perform a merge, use st_join(). The left-hand geometry is preserved. Here we are checking which Census tract each permit is in, then joining that tract's data to the record for the point.
chicago_permits_merged <- st_join(
  chicago_permits,  # points
  chicago_gdf,      # polygons
  join = st_within  # which polygon is the point WITHIN
  )

# Now that we have the tract information for each point, we can aggregate using group_by() to get the mean estimated cost of a building permit for each tract, we no longer need the point geometries. We can get rid of them using:
chicago_permits_merged$geometry <- NULL

# Notice the new geoid and commarea columns, which were merged on from the tracts. Now we know which tract each building permit is in, so we can aggregate them:

chicago_permits_merged <- na.exclude(chicago_permits_merged)

chicago_permits_agg <- chicago_permits_merged %>%
  group_by(geoid) %>%
  summarize(
    cost = mean(estimated_cost),
    count = n()
  )

# The result is the mean cost of permits per census tract, but now we have no geometry to plot. To fix this, we can merge back on the Chicago census tracts using their geoid
chicago_permits_agg <- chicago_gdf %>%
  left_join(chicago_permits_agg, by = "geoid")

### NOTE ###
# In order to make R recognize the geometry column as the thing you're trying to plot, you must merge ONTO the data frame which already contains geometry. Merging a data frame with geometry onto one without geometry will cause R to lose the attribute that makes the geometry column special, and it will just plot your data normally
############

## Now we can finally plot our choropleth!
plot(chicago_permits_agg["cost"]) # what is wrong with this map? why isn't it useful?

##### Better Map Plots #####

# We can fix some of the issues by adjusting the scale using ggplot. ggplot uses a special geom for sf objects called geom_sf(), the color and fill aesthetics are what will give the choropleth its color

# First we should make a new set of breaks by which to classify the data, we can break it into quantiles for easier viewing using the ntile() function
chicago_permits_agg <- chicago_permits_agg %>%
  mutate(qtile = factor(ntile(cost, 9)))

# Now we can create a ggplot with our binned, factorized data
ggplot() +
  geom_sf(
    data = chicago_permits_agg,
    aes(color = qtile, fill = qtile)
  )

# But ggplot alone is just as ugly as plot(), so let's clean it up
# First, we should reorder our factors:
chicago_permits_agg <- chicago_permits_agg %>%
  mutate(qtile = fct_rev(qtile))

# Now plot with labels and a proper color palette
ggplot() +
  geom_sf(data = chicago_permits_agg,
          aes(fill = qtile, color = qtile)) +
  scale_fill_brewer(palette = "YlGn", name = "Quantile", direction = -1) +
  scale_color_brewer(palette = "YlGn", name = "Quantile", direction = -1) +
  theme_void() +
  labs(
    title = "Quantiles of Estimated Costs\nfor Building Permits in Chicago",
    subtitle = "2006 to Present"
  )

##### Mapping with Census Data #####

# Tidycensus provides an incredibly easy way to gather data for mapping. Using the geometry = TRUE argument in get_acs() or get_decennial() will automatically return shapefiles. Let's test it out.


vars <- load_variables(2016, "acs5")


citi_data_state <- get_acs(
  geography = "state",
  variables = c(total = "B05001_001", noncitizen = "B05001_006"),
  year = 2016,
  geometry = TRUE,
  shift_geo = TRUE,
  output = "wide"
)

citi_data_state %>%
  mutate(pct_noncitizen = noncitizenE / totalE) %>%
ggplot() +
  geom_sf(aes(fill = pct_noncitizen, color = pct_noncitizen)) +
  scale_color_distiller(palette = "RdYlBu") +
  scale_fill_distiller(palette = "RdYlBu") +
  theme_bw()


race_data_state <- get_acs(
  geography = "state",
  variables = c(total_pop = "B01001_001", white = "B01001A_001"),
  year = 2016,
  geometry = TRUE,
  shift_geo = TRUE,
  output = "wide"
)

# Creating a state-level map of pct white
race_data_state %>%
  mutate(pct_white = whiteE / total_popE) %>%
  st_transform(2163) %>%
  ggplot() +
    geom_sf(aes(fill = pct_white, color = pct_white)) +
    scale_color_distiller(palette = "RdYlBu") +
    scale_fill_distiller(palette = "RdYlBu") +
    theme_bw()

## CHALLENGE EXERCISE

# Plotting median income in california by county
med_income_cali <- get_acs(
  geography = "county",
  state = "CA",
  variables = c(med_income = "B06011_001"),
  year = 2016,
  geometry = TRUE
)

med_income_cali %>%
  st_transform(2163) %>%
  ggplot() +
    geom_sf(aes(fill = estimate, color = estimate)) +
    scale_color_distiller(palette = "YlGnBu") +
    scale_fill_distiller(palette = "YlGnBu") +
    theme_bw()

# Try: introducing a new color scale; changing the thresholds for the color breaks.