library(mapedit) # (OPTIONAL) Interactive editing of vector data
library(raster)  # Manipulate raster data
library(scales)  # Scale functions for visualization
library(cptcity)  # cptcity color gradients!
library(tmap)    # Thematic Map Visualization <3
library(rgee)    # Bindings for Earth Engine

# Install rgee ; Need to run this only for the first time
# rgee::ee_install()

# Initialize your Earth Engine session, you will need to have a google earth engine account prior to the initialization
ee_Initialize()

# Load the MOD11A1 ImageCollection. Filter it, for instance, for a specific month, and create a mean composite.
dataset <- ee$ImageCollection("MODIS/006/MOD11A1")$
  filter(ee$Filter$date('2020-02-01', '2020-02-28'))$
  mean()
# dataset <- ee$ImageCollection("MODIS/006/MOD11A1")$
#   filter(ee$Filter$date('2020-06-01', '2020-06-30'))$
#   mean()
# dataset <- ee$ImageCollection("MODIS/006/MOD11A1")$
#   filter(ee$Filter$date('2020-08-01', '2020-08-31'))$
#   mean()
# dataset <- ee$ImageCollection("MODIS/006/MOD11A1")$
#   filter(ee$Filter$date('2020-10-01', '2020-10-31'))$
#   mean()

# each of this dataset produce a seasonal plot

# The 'LST_Day_1km' is the band that contains daytime land surface temperature values. We select it and transform the values from kelvin to celsius degrees.
landSurfaceTemperature <- dataset$
  select("LST_Day_1km")$
  multiply(0.02)$
  subtract(273.15)

# Define the list of parameters for visualization. 
landSurfaceTemperatureVis <- list(
  min = -50, 
  max = 50,
  palette = cpt("grass_bcyr")
)
# create an interactive map
Map$addLayer(
  eeObject = landSurfaceTemperature,
  visParams = landSurfaceTemperatureVis,
  name = "Global monthly mean LST (°C) from MODIS: Oct 2020",
  legend = TRUE,
  
)

#########################SAUDI ARABIA###############
# Select the gemometry location of Saudi Arabia, and perform the same steps to extract the land
# surface temperatures for Saudi Arabia

geom1 <- ee$Geometry$Point(list(47, 17))
Map$centerObject(geom1, zoom = 4)

geometry <- ee$Geometry$Rectangle(
  coords = c(28.65234,11.20371,62.05078,35.89617),
  proj = "EPSG:4326",
  geodesic = FALSE
)
dataset <- ee$ImageCollection("MODIS/006/MOD11A1")$
  filter(ee$Filter$date('2020-08-01', '2020-08-31'))$
  mean()$
  clip(geometry)

landSurfaceTemperature <- dataset %>%
  ee$Image$select("LST_Day_1km") %>%
  ee$Image$multiply(0.02) %>%
  ee$Image$subtract(273.15)

landSurfaceTemperatureVis <- list(
  min = -50, 
  max = 50,
  palette = cpt("grass_bcyr")
)

Map$addLayer(
  eeObject = landSurfaceTemperature,
  visParams = landSurfaceTemperatureVis,
  name = "Monthly mean LST (°C) for Saudi Arabia from MODIS: Aug 2020",
  legend = TRUE,
)

################Time series#################
# Since this is an ongoing research project time series data and that coding part is restricted. Sorry for the inconvinience!



###############Time lapse###########################
# Following is the code to create a time lapse using vegetation data.Unfortunately it didn't work with 
# the land surface temperature data. Still,you can enjoy creating this time lapse!
library(magick)
library(rgee)
library(sf)

# ee_Initialize()
mask <- system.file("shp/arequipa.shp", package = "rgee") %>% 
  st_read(quiet = TRUE) %>% 
  sf_as_ee()
region <- mask$geometry()$bounds()
col <- ee$ImageCollection('MODIS/006/MOD13A2')$select('NDVI')
col <- col$map(function(img) {
  doy <- ee$Date(img$get('system:time_start'))$getRelative('day', 'year')
  img$set('doy', doy)
})
distinctDOY <- col$filterDate('2013-01-01', '2014-01-01')
filter <- ee$Filter$equals(leftField = 'doy', rightField = 'doy')
join <- ee$Join$saveAll('doy_matches')
joinCol <- ee$ImageCollection(join$apply(distinctDOY, col, filter))
comp <- joinCol$map(function(img) {
  doyCol = ee$ImageCollection$fromImages(
    img$get('doy_matches')
  )
  doyCol$reduce(ee$Reducer$median())
})
visParams = list(
  min = 0.0,
  max = 9000.0,
  bands = "NDVI_median",
  palette = c(
    'FFFFFF', 'CE7E45', 'DF923D', 'F1B555', 'FCD163', '99B718', '74A901',
    '66A000', '529400', '3E8601', '207401', '056201', '004C00', '023B01',
    '012E01', '011D01', '011301'
  )
)
rgbVis <- comp$map(function(img) {
  do.call(img$visualize, visParams) %>% 
    ee$Image$clip(mask)
})
gifParams <- list(
  region = region,
  dimensions = 600,
  crs = 'EPSG:3857',
  framesPerSecond = 10
)
animation <- ee_utils_gif_creator(rgbVis, gifParams, mode = "wb")
animation %>% 
  ee_utils_gif_annotate(
    text = "NDVI: MODIS/006/MOD13A2",
    size = 15, color = "white",
    location = "+10+10"
  ) %>% 
  ee_utils_gif_annotate(
    text = 'dates_modis_mabbr', 
    size = 30, 
    location = "+290+350",
    color = "white", 
    font = "arial",
    boxcolor = "#000000"
  ) # -> animation_wtxt
