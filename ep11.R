# episode 11
# Manipulating Rasters

# crop rasters to vector extents
# Manipulate Raster Data
# aka: cropping while dealing with CRSs

rm(list=ls())
current_episode <- 11


library(sf)
library(ggplot2)
library(dplyr)
library(terra)

# objects we will need:
aoi_boundary_HARV <- st_read(
  "data/NEON-DS-Site-Layout-Files/HARV/HarClip_UTMZ18.shp")

CHM_HARV <- rast("data/NEON-DS-Airborne-Remote-Sensing/HARV/CHM/HARV_chmCrop.tif")
CHM_HARV_df <- as.data.frame(CHM_HARV, xy=TRUE)

# this episode also needs the plot_locations_sp_HARV
# that was created in ep.10:
# ps: this is the version that was given to us by carpentry
# Plot Locations
plot_locations_sp_HARV <- st_read("data/NEON-DS-Site-Layout-Files/HARV/PlotLocations_HARV.shp")


# Crop a Raster Using Vector Extent
# show the setup diagram in the lesson

# we will crop the CHM to the AOI shapefile.
ggplot() +
  geom_raster(data = CHM_HARV_df, aes(x = x, y = y, fill = HARV_chmCrop)) +
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(10)) +
  geom_sf(data = aoi_boundary_HARV, color = "blue", fill = NA) +
  coord_sf()


# Crop a Raster Using Vector Extent
# 
# maybe we are only intersted in the height of the trees
# inside of our AOI
# make it so:
CHM_HARV_Cropped <- crop(x = CHM_HARV, y = aoi_boundary_HARV)

CHM_HARV_Cropped_df <- as.data.frame(CHM_HARV_Cropped, xy = TRUE)

ggplot() +
  geom_sf(data = st_as_sfc(st_bbox(CHM_HARV)), fill = "green",
          color = "green", alpha = .2) +
  geom_raster(data = CHM_HARV_Cropped_df,
              aes(x = x, y = y, fill = HARV_chmCrop)) +
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(10)) +
  ggtitle("Canopy Height w/extent of the original AOI")+
  coord_sf()

ggplot() +
  geom_raster(data = CHM_HARV_Cropped_df,
              aes(x = x, y = y, fill = HARV_chmCrop)) +
  geom_sf(data = aoi_boundary_HARV, color = "blue", fill = NA) +
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(10)) +
  ggtitle("Canopy Height of just our Plots")+
  coord_sf()

# We can look at the extent of all of our other objects for this field site.
st_bbox(CHM_HARV)
st_bbox(CHM_HARV_Cropped)
st_bbox(aoi_boundary_HARV)

# ###########
# Challenge: Crop to Vector Points Extent
#
# Crop the Canopy Height Model to the extent of the study plot locations.
# Plot the vegetation plot location points on top of the Canopy Height Model.

aoi_points <- st_bbox(plot_locations_sp_HARV)

ggplot() +
  geom_raster(data = CHM_HARV_df,
              aes(x = x, y = y, fill = HARV_chmCrop)) +
  geom_sf(data= st_as_sfc(aoi_points), color = "red", fill = NA) +
  geom_sf(data = aoi_boundary_HARV, color = "blue", fill = NA) +
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(10)) +
  ggtitle("Challenge")+
  coord_sf()

chm_plot_extent <- crop(CHM_HARV, aoi_boundary_HARV)

chm_plot_extent_df <- as.data.frame(chm_plot_extent, xy=TRUE)
str(chm_plot_extent_df)

ggplot() +
  geom_raster(data = chm_plot_extent_df,
              aes(x = x, y = y, fill = HARV_chmCrop)) +
  geom_sf(data= st_as_sfc(aoi_points), color = "red", fill = NA) +
  geom_sf(data = aoi_boundary_HARV, color = "blue", fill = NA) +
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(10)) +
  ggtitle("Challenge 2")+
  coord_sf()



# See the bounding box of previous HARV AOI, and from our new study plot locations
ggplot() +
  geom_raster(data = CHM_HARV_df, aes(x = x, y = y, fill = HARV_chmCrop)) +
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(10)) +
  geom_sf(data = aoi_boundary_HARV, color = "blue", fill = NA) +
  geom_sf(data = st_as_sfc(aoi_points), color = "red", fill = NA) +
  coord_sf()

CHM_plots_HARVcrop <- crop(CHM_HARV, aoi_points)
plot(CHM_plots_HARVcrop)

CHM_plots_HARVcrop_df <- as.data.frame(CHM_plots_HARVcrop, xy=TRUE)
str(CHM_plots_HARVcrop_df)


# Finally, use the study plot locations and plot them on top of the CHM

ggplot() +
  geom_raster(data = CHM_plots_HARVcrop_df,
              aes(x = x, y = y, fill = HARV_chmCrop)) +
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(10)) +
  geom_sf(data = plot_locations_sp_HARV) +
  coord_sf()



ggplot() +
  geom_raster(data = CHM_plots_HARVcrop_df,
              aes(x = x, y = y, fill = HARV_chmCrop)) +
  geom_sf(data = plot_locations_sp_HARV, color = "blue", fill = NA) +
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(10)) +
  coord_sf()


ggplot() +
  geom_raster(data = CHM_plots_HARVcrop_df,
              aes(x = x, y = y, fill = HARV_chmCrop)) +
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(10)) +
  geom_sf(data = plot_locations_sp_HARV, color = "blue", fill = NA) +
  coord_sf()

# 2 lonely dots live outside the extent. 
# Use a custom extent to crop the CHM
new_extent <- ext(732161.2, 732238.7, 4713249, 4713333)
CHM_HARV_manual_crop <- crop(CHM_HARV, new_extent)

# extract doesn't make a new dataframe. 


# Extract Data using x,y Locations
# make a buffer around a point

# location of the tower. a single point shapefile from episode 6:
point_HARV <- st_read("data/NEON-DS-Site-Layout-Files/HARV/HARVtower_UTM18N.shp")

# Let's figure out the 
# average tree height near our tower

str(point_HARV)

# A good teaching moment
# If you loaded tidyr, this will raise an error as extract()
# from tidyr will conflict with the one from terra. 
# don't forget how to specify which libraries get used: terra:extract()
# Jon' didn't get that error. is that because tidyr isn't loaded?

# if this throws an error:
mean_tree_height_tower <- extract(x = CHM_HARV,
                                   y = st_buffer(point_HARV, dist = 20),
                                   fun = mean)
# this will not:
mean_tree_height_tower <- terra::extract(x = CHM_HARV,
                                  y = st_buffer(point_HARV, dist = 20),
                                  fun = mean)

str(mean_tree_height_tower)
mean_tree_height_tower




# challenge:
# do it for all the plot location points plot_locations_sp_HARV

# extract data at each plot location
mean_tree_height_plots_HARV <- terra::extract(x = CHM_HARV,
                                       y = st_buffer(plot_locations_sp_HARV,
                                                     dist = 20),
                                       fun = mean)

# view data
mean_tree_height_plots_HARV



# Review challenge: let's graph our tree heights:
# plot data

ggplot(data = mean_tree_height_plots_HARV, aes(x=ID, y=HARV_chmCrop)) +
  geom_col() +
  ggtitle("Mean Tree Height at each Plot") +
  xlab("Plot ID") +
  ylab("Tree Height (m)")

# tallest to lowest plots:
ggplot(data = mean_tree_height_plots_HARV, aes(reorder(ID, -HARV_chmCrop), HARV_chmCrop)) +
  geom_col() +
  ggtitle("Plots by mean tree height") +
  xlab("Plot ID") +
  ylab("Tree Height (m)")
