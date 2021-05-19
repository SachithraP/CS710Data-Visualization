# install.packages("rgee")
library(mapedit) # (OPTIONAL) Interactive editing of vector data
library(raster)  # Manipulate raster data
library(scales)  # Scale functions for visualization
library(cptcity)  # cptcity color gradients!
library(tmap)    # Thematic Map Visualization <3
library(rgee)    # Bindings for Earth Engine
ee_Initialize()
# rgee::ee_install() 

# ee_search_dataset() %>%
#   ee_search_tags("mod11a1") %>%
#   ee_search_display()
# region <-ee$Geometry$Rectangle(28.65234,11.20371,62.05078,35.89617)
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
  name = 'Land Surface Temperature'
)
# library(mapview)
# library(mapedit)
# Map$addLayer(
#   eeObject = landSurfaceTemperature,
#   visParams = landSurfaceTemperatureVis,
#   name = 'Land Surface Temperature'
# ) %>% editMap() -> my_polygon
# mapview(my_polygon$finished)
# 
# Map$addLayer(
#   eeObject = my_polygon,
#   visParams = landSurfaceTemperatureVis,
#   name = 'Land Surface Temperature'
# )
# geometry <- ee$Geometry$Rectangle(
#   coords = c(28.65234,11.20371,62.05078,35.89617),
#   proj = "EPSG:4326",
#   geodesic = FALSE
# )
# 
# 
# 
# rgbVis <- landSurfaceTemperature$map(function(img) {
#   do.call(img$visualize, visParams) %>% 
#     ee$Image$clip(geometry)
# })
# gifParams <- list(
#   region = geometry,
#   dimensions = 600,
#   crs = 'EPSG:3857',
#   framesPerSecond = 10
# )
# animation <- ee_utils_gif_creator(landSurfaceTemperature, gifParams, mode = "wb")
# animation %>% 
#   ee_utils_gif_annotate(
#     text = "NDVI: MODIS/006/MOD13A2",
#     size = 15, color = "white",
#     location = "+10+10"
#   ) %>% 
#   ee_utils_gif_annotate(
#     text = "dates_modis_mabbr", 
#     size = 30, 
#     location = "+290+350",
#     color = "white", 
#     font = "arial",
#     boxcolor = "#000000"
#   ) # -> animation_wtxt
# animation
# 
# 
# 
# 
# 
