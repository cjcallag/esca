shinyServer(function(input, output) {
  # Set up observers ===========================================================
  observeEvent(input$load_about, {
    modal_about()
  })
  
  # Get map ====================================================================
  output$map <- renderLeaflet({
    group_pal <- colorFactor(palette = c("#7fc97f", "#beaed4", "#fdc086", "#ffff99", "#386cb0"),
                          domain = esca[["group"]], na.color = "#ff7f00")
    reuse_pal <- colorFactor(palette = c("#7fc97f", "#beaed4", "#fdc086", "#ffff99"),
                             domain = esca[["hmp_category"]], na.color = "#ff7f00")
    owner_pal <- colorFactor(palette = c("#7fc97f", "#beaed4", "#fdc086", "#ffff99", "#386cb0", "#f0027f", "#bf5b17"),
                             domain = esca[["land_holder"]], na.color = "#ff7f00")
    juris_pal <- colorFactor(palette = c("#7fc97f", "#beaed4", "#fdc086", "#ffff99"),
                             domain = esca[["jurisdiction"]], na.color = "#ff7f00")
    
    my_map <- leaflet(options = leafletOptions(zoomControl = FALSE)) %>%
      addProviderTiles(providers$Esri.WorldGrayCanvas, group = "Basemap") %>%
      addProviderTiles(providers$Esri.WorldImagery, group = "Imagery") %>%
      addPolygons(data = ft_ord, fill = FALSE, weight  = 4, color = "#000000",
                  opacity = 1, group = "Ft. Ord Boundary") %>%
      addPolygons(data = parcels, fillColor = "grey", fillOpacity = 0.25,
                  weight = 1, opacity = 1, color = "#000000", 
                  popup       = paste0("<table>",
                                       # APN Field -----------------------------
                                       "<tr><th><b>APN: </b></th><td>",
                                       parcels$APN,
                                       "</td></tr>",
                                       "<tr><th><b>Acres: </b></th><td>",
                                       # Acres Field ---------------------------
                                       parcels$GIS_ACRES,
                                       "</td></tr>",
                                       "</table>"),
                  group = "County Parcels") %>%
      addPolylines(data = roads, group = "Roads and Trails", weight = 3,
                   label = roads$name, opacity = 0.5, color = "#000000",
                   dashArray = "5", stroke = TRUE,
                   popup = paste0("<table>",
                                  # Name Field ---------------------------------
                                  "<tr><th><b>Name: </b></th><td>",
                                  roads$name, 
                                  "</td></tr>",
                                  # Surface Field ------------------------------
                                  "<tr><th><b>Surface: </b></th><td>",
                                  roads$surface_type,
                                  "</td></tr>",
                                  "</table>")) %>%
      addLayersControl(baseGroups = c("Basemap", "Imagery"), position = "topright",
          overlayGroups = c("County Parcels", "Roads and Trails"),
          options = layersControlOptions(collapsed = FALSE)) %>%
      hideGroup(c("County Parcels", "Roads and Trails")) %>%
      setView(lng = -121.77, lat = 36.613, zoom = 12.5) %>%
      addMeasure(position = "topright", primaryLengthUnit = "feet",
                 primaryAreaUnit = "acres")
    my_map %>% clearControls()
    if (input$data_set == "Munitions Response Areas") {
      my_map %>% 
        addPolygons(data = esca, fillColor = ~group_pal(esca[["group"]]),
                    fillOpacity = 0.5, weight = 1, opacity = 1, color = "#000000",
                    label = ~coe, popup = ~popup, group = "ESCA Parcels") %>%
        addLegend(position = "bottomright", pal = group_pal, values = esca[["group"]],
                  title = "Groups", opacity  = 1)
    }
    else if (input$data_set == "Municipal Jurisdictions") {
      my_map %>%
        addPolygons(data = esca, fillColor = ~juris_pal(esca[["jurisdiction"]]),
                    fillOpacity = 0.5, weight = 1, opacity = 1, color = "#000000",
                    label = ~coe, popup = ~popup, group = "Municipal Jurisdicition") %>%
        addLegend(position = "bottomright", pal = juris_pal, values = esca[["jurisdiction"]],
                  title = "Groups", opacity  = 1)
    }
    else if (input$data_set == "Ownership") {
      my_map %>%
        addPolygons(data = esca, fillColor = ~owner_pal(esca[["land_holder"]]),
                    fillOpacity = 0.5, weight = 1, opacity = 1, color = "#000000",
                    label = ~coe, popup = ~popup, group = "Land Holder") %>%
        addLegend(position = "bottomright", pal = owner_pal, values = esca[["land_holder"]],
                  title = "Land Owners", opacity  = 1)
    }
    else if (input$data_set == "Proposed Reuse") {
      my_map %>%
        addPolygons(data = esca, fillColor = ~reuse_pal(esca[["hmp_category"]]),
                    fillOpacity = 0.5, weight = 1, opacity = 1, color = "#000000",
                    label = ~coe, popup = ~popup, group = "HMP Categories") %>%
        addLegend(position = "bottomright", pal = reuse_pal, values = esca[["hmp_category"]],
                  title = "Proposed Reuse", opacity  = 1)
    }
  })
  }) 
