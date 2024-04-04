library(tidyverse)
install.packages('leaflet')

# Task 1

leaflet() %>%  # Focusing on Denmark
  addTiles() %>% 
  setView(lng = 11, lat = 56, zoom = 7)
  addProviderTiles("Esri.WorldPhysical", group = "Physical") %>% 
  addProviderTiles("Esri.WorldImagery", group = "Aerial") %>% 
  addProviderTiles("MtbMap", group = "Geo") %>% 

addLayersControl(                                 # we are adding layers control to the maps
  baseGroups = c("Geo","Aerial", "Physical"),
  options = layersControlOptions(collapsed = T))

  l_dan <- leaflet() %>%   # assign the base location to an object
    setView(11, 56, zoom = 7)
  
esri <- grep("^Esri", providers, value = TRUE) # preparing backgrounds


for (provider in esri) {
  l_dan <- l_dan %>% addProviderTiles(provider, group = provider)
}  

### Map of Denmark
# We make a layered map out of the components above and write it to 
# an object called DANmap
DANmap <- l_dan %>%
  addLayersControl(baseGroups = names(esri),
                   options = layersControlOptions(collapsed = FALSE)) %>%
  addMiniMap(tiles = esri[[1]], toggleDisplay = TRUE,
             position = "bottomright") %>%
  addMeasure(
    position = "bottomleft",
    primaryLengthUnit = "meters",
    primaryAreaUnit = "sqmeters",
    activeColor = "#3D535D",
    completedColor = "#7D4479") %>% 
  htmlwidgets::onRender("
                        function(el, x) {
                        var myMap = this;
                        myMap.on('baselayerchange',
                        function (e) {
                        myMap.minimap.changeLayer(L.tileLayer.provider(e.name));
                        })
                        }") %>% 
  addControl("", position = "topright")   %>% 
  addTiles() %>% 
  addMarkers(lng = places$Longitude, 
             lat = places$Latitude,
             popup = places$Description,
             clusterOptions = markerClusterOptions())

DANmap
# Trying to save
library(htmlwidgets)
saveWidget(DANmap, "DANmap.html", selfcontained = TRUE)
??htmlwidget
createWidget(DANmap,"DANmap.html" ) # it worked!!!

########## Task 2

# activating packages
library(tidyverse)
library(googlesheets4)
library(leaflet)
# this code is added to line 49 - 53 to merge the two maps.
# it is reading the points, but there might be missing point, because of errors in formatting

# Read in a Google sheet
places <- read_sheet("https://docs.google.com/spreadsheets/d/1PlxsPElZML8LZKyXbqdAYeQCDIvDps2McZx1cTVWSzI/edit#gid=124710918",
                     col_types = "cccnncnc", range = "DM2023") # specifying range
glimpse(places)
########################################## Task 3
leaflet() %>% 
  addTiles() %>% 
  addMarkers(lng = places$Longitude, 
             lat = places$Latitude,
             popup = places$Placename,
             clusterOptions = markerClusterOptions()) # "markerClusterOptions()" clusters the points on the map for task 3

##################### Task 4
# This map is useful for finding danish landmarks added by the class, and similar maps could be made with data marking different 
# locations that could be useful to have mapped out.

##################### Task 5
# replace "Description" in line 82 with "placename". this gives small notes to the points added, that had notes in the spreadsheet.









