# ep 14
# Deriving values from raster time series

# extracting pixels from raters, saving summary values to a csv file 
# plotting pixel summary values using ggplot() 
# comparing NDVI values between two different sites 

current_episode <- 12


avg_NDVI_HARV <- global(NDVI_HARV_stack, mean)
avg_NDVI_HARV

head(avg_NDVI_HARV)

#clean up column names and change the name 
names(avg_NDVI_HARV) <- "meanNDVI"
head(avg_NDVI_HARV)

# do it again for site and year
avg_NDVI_HARV$site <- "HARV"
avg_NDVI_HARV$year <- "2011"

#voila
head(avg_NDVI_HARV)

#Julian Days 
julianDays <- gsub("X|_HARV_ndvi_crop", "", row.names(avg_NDVI_HARV))
julianDays

# add julian days as a column
avg_NDVI_HARV$julianDay <- julianDays
class(avg_NDVI_HARV$julianDay)

#converting julian dayes to date class


origin <- as.Date("2011-01-01")

avg_NDVI_HARV$julianDay <- as.integer(avg_NDVI_HARV$julianDay)

avg_NDVI_HARV$Date<- origin + (avg_NDVI_HARV$julianDay - 1)
head(avg_NDVI_HARV$Date)

class(avg_NDVI_HARV$Date)

#challenge: NDVI for SJER/San Joaquin 
#will need this to compare two sites later

NDVI_path_SJER <- "data/NEON-DS-Landsat-NDVI/SJER/2011/NDVI"

all_NDVI_SJER <- list.files(NDVI_path_SJER,
                            full.names = TRUE,
                            pattern = ".tif$")

NDVI_stack_SJER <- rast(all_NDVI_SJER)
names(NDVI_stack_SJER) <- paste0("X", names(NDVI_stack_SJER))

NDVI_stack_SJER <- NDVI_stack_SJER/10000

#mean values for each day > dataframe it
avg_NDVI_SJER <- as.data.frame(global(NDVI_stack_SJER, mean))

names(avg_NDVI_SJER) <- "meanNDVI"
avg_NDVI_SJER$site <- "SJER"
avg_NDVI_SJER$year <- "2011"

julianDays_SJER <- gsub("X|_SJER_ndvi_crop", "", row.names(avg_NDVI_SJER))
origin <- as.Date("2011-01-01")
avg_NDVI_SJER$julianDay <- as.integer(julianDays_SJER)

avg_NDVI_SJER$Date <- origin + (avg_NDVI_SJER$julianDay - 1)

head(avg_NDVI_SJER)

#plot NDVI using ggplot

ggplot(avg_NDVI_HARV, aes(julianDay, meanNDVI)) +
  geom_point() +
  ggtitle("Landsat Derived NDVI - 2011", 
          subtitle = "NEON Harvard Forest Field Site") +
  xlab("Julian Days") + ylab("Mean NDVI")

#challenge plot SJER/San Joaquin 
ggplot(avg_NDVI_SJER, aes(julianDay, meanNDVI)) +
  geom_point(colour = "SpringGreen4") +
  ggtitle("Landsat Derived NDVI - 2011", subtitle = "NEON SJER Field Site") +
  xlab("Julian Day") + ylab("Mean NDVI")


#comparing the NDVI of two sites on one plot 

# use rbind to merge the SJER and HARV datasets together
# same # of columns with same column names 
NDVI_HARV_SJER <- rbind(avg_NDVI_HARV, avg_NDVI_SJER)

ggplot(NDVI_HARV_SJER, aes(x = julianDay, y = meanNDVI, colour = site)) +
  geom_point(aes(group = site)) +
  geom_line(aes(group = site)) +
  ggtitle("Landsat Derived NDVI - 2011", 
          subtitle = "Harvard Forest vs San Joaquin") +
  xlab("Julian Day") + ylab("Mean NDVI")

# I dont like julian days, can I get it like a normal person?

ggplot(NDVI_HARV_SJER, aes(x = Date, y = meanNDVI, colour = site)) +
  geom_point(aes(group = site)) +
  geom_line(aes(group = site)) +
  ggtitle("Landsat Derived NDVI - 2011", 
          subtitle = "Harvard Forest vs San Joaquin") +
  xlab("Date") + ylab("Mean NDVI")

#removing outlier data
avg_NDVI_HARV_clean <- subset(avg_NDVI_HARV, meanNDVI > 0.1)
avg_NDVI_HARV_clean$meanNDVI < 0.1

ggplot(avg_NDVI_HARV_clean, aes(x = julianDay, y = meanNDVI)) +
  geom_point() +
  ggtitle("Landsat Derived NDVI - 2011", 
          subtitle = "NEON Harvard Forest Field Site") +
  xlab("Julian Days") + ylab("Mean NDVI")
head(avg_NDVI_HARV_clean)


#remove row names
row.names(avg_NDVI_HARV_clean) <- NULL
head(avg_NDVI_HARV_clean)

write.csv(avg_NDVI_HARV_clean, file="01272025_meanNDVI_HARV_2011.csv")
