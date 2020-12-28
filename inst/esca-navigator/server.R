shinyServer(function(input, output) {
    output$map <- renderLeaflet({
      pal <- colorFactor(palette = c("#e41a1c", "#377eb8", "#4daf4a", "#984ea3"), domain = roads$surface_type, na.color = "#ff7f00")
      leaflet() %>%
        # Base groups
        addProviderTiles(providers$OpenStreetMap.Mapnik, group = "Basemap") %>%
        addProviderTiles(providers$Esri.WorldImagery, group = "Imagery") %>%
        # Overlay groups
        addCircles(data    = gates,
                   stroke  = TRUE,
                   group   = "Gates",
                   color   = "red",
                   opacity = 1,
                   popup   = ~htmlEscape(name)) %>%
        addPolygons(data   = ftord,
                    fill   = FALSE,
                    weight = 3, 
                    color  = "#000000",
                    group  = "Ft. Ord Boundary") %>%
        addPolylines(data    = roads,
                     group   = "Roads",
                     weight  = 2,
                     opacity = 1,
                     color   = ~pal(surface_type),
                     popup   = paste0("<b>Name: </b>", roads$name, "<br>",
                                      "<b>Surface: </b>", roads$surface_type)) %>%
        addPolygons(data        = parcels,
                    fillColor   = "grey",
                    fillOpacity = 0.1,
                    weight      = 2, 
                    color       = "#000000",
                    popup       = paste0("<b>APN: <b/>", parcels$APN, "<br>",
                                         "<b>Acres: <b/>", parcels$GIS_ACRES),
                    group       = "County Parcels") %>%
        # Layers control
        addLayersControl(
            baseGroups    = c("Basemap", "Imagery"),
            overlayGroups = c("Ft. Ord Boundary", "Gates", "County Parcels", "Roads"),
            position      = "topright",
            options       = layersControlOptions(collapsed = FALSE)) %>%
        hideGroup(c("Gates", "County Parcels")) %>%
        addLegend(position = "bottomright",
                  pal      = pal,
                  values   = roads$surface_type,
                  title    = "Road Types",
                  opacity  = 1) %>%
        setView(-121.78, 36.611, 13)
    })
})
