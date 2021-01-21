shinyServer(function(input, output, session) {
    events <- googlesheets4::read_sheet("https://docs.google.com/spreadsheets/d/1gGeYpebQuhXFVDjec9_gpHzTckEPnL-xTOMwxlEtZ14/edit#gid=0",
                                        range = "reports")
    events <- sf::st_as_sf(events, coords = c("Lon", "Lat"), crs = '4326')
    # JS magic -----------------------------------------------------------------
    js_code <- 'function(el, x) {
                    this.addEventListener("mousemove", function(e) {
                        document.getElementById("coords").innerHTML = e.latlng.lat.toFixed(6) + ", " + e.latlng.lng.toFixed(6);
                    })
                }'
    shinyjs::runjs('document.getElementById("map").style.cursor = "crosshair"')
    shinyjs::runjs('document.getElementByClassName("leaflet-interactive").style.cursor = "crosshair"')
    # Add map ------------------------------------------------------------------
    output$map <- renderLeaflet({
        my_pal <- colorFactor(palette  = c("#7fc97f", "#beaed4", "#fdc086", "#ffff99"),
                              domain   = esca[["mra"]],
                              na.color = "#ff7f00")
        
        leaflet(options = leafletOptions(minZoom     = 4,
                                         maxZoom     = 18,
                                         zoomControl = FALSE)) %>%
            addProviderTiles(providers$Stamen.TonerLite, group = "Basemap") %>%
            # addProviderTiles(providers$Esri.WorldImagery, group = "Imagery") %>%
            setView(lng = -121.78, lat = 36.62, zoom = 12.5) %>%
            addPolygons(data        = esca,
                        fillColor   = ~my_pal(esca[["mra"]]),
                        fillOpacity = 0.25,
                        weight      = 1,
                        opacity     = 1,
                        color       = ~my_pal(esca[["mra"]])) %>%
            addPolygons(data    = ftord,
                        fill    = FALSE,
                        weight  = 4,
                        color   = "#000000",
                        opacity = 1,) %>%
            addCircles(data        = events, 
                       color       = "red",
                       fill        = "red",
                       # radius      = 5,
                       fillOpacity = 1,
                       opacity     = 1,
                       popup       = paste0("<table>",
                                            # Name Field -----------------------
                                            "<tr><th><b>Timestamp: </b></th><td>",
                                            events[["Timestamp"]], 
                                            "</td></tr>",
                                            # Type Field -----------------------
                                            "<tr><th><b>Author: </b></th><td>",
                                            events[["Author"]], 
                                            "</td></tr>",
                                            # Width Field ----------------------
                                            "<tr><th><b>Notes: </b></th><td>",
                                            events[["Notes"]], 
                                            "</td></tr>",
                                            "</table>")) %>%
            addLegend(position = "bottomright",
                      pal      = my_pal,
                      values   = esca[["mra"]],
                      title    = "MRAs",
                      opacity  = 1) %>%
            # addLayersControl(
            #     baseGroups    = c("Basemap", "Imagery"),
            #     position      = "topright",
            #     options       = layersControlOptions(collapsed = FALSE)) %>%
            addMiniMap(
                tiles         = providers$Stamen.TonerLite,
                toggleDisplay = TRUE,
                minimized     = FALSE,
                strings       = list(hideText = "Hide MiniMap",
                                     showText = "Show MiniMap"),
                position      = "bottomleft") %>%
            onRender(js_code)
        })
    # Map click ----------------------------------------------------------------
    observeEvent(input$map_click, {
        lat <- round(input$map_click$lat, digits = 6)
        lng <- round(input$map_click$lng, digits = 6)
        updateTextInput(session = session,
                        inputId = 'location',
                        value   = paste0(lat, ', ', lng))
    })
    # Update map ---------------------------------------------------------------
    observeEvent(input$location, ignoreInit = TRUE, {
        if(validate_coords(input$location)) {
            update_coords <- str_replace(input$location, ' ', '') %>% 
                str_split(',')
            lat <- update_coords[[1]][1] %>%
                as.numeric()
            lng <- update_coords[[1]][2] %>% 
                as.numeric()
            leafletProxy('map') %>%
                addAwesomeMarkers(lng     = lng,
                                  lat     = lat,
                                  layerId = 'location',
                                  icon = makeAwesomeIcon(icon        = 'circle', 
                                                         markerColor = 'black',
                                                         library     = 'fa', 
                                                         iconColor   = '#fff'),
                                  popup = paste0(lat,', ', lng),
                                  popupOptions = popupOptions(closeButton = FALSE))
        } else {
            leafletProxy('map') %>%
                removeMarker('location')
        }
    })
    # Add data to sheet --------------------------------------------------------
    observeEvent(input$submit_form, {
        lat  <- round(input$map_click$lat, digits = 6)
        lng  <- round(input$map_click$lng, digits = 6)
        temp <- data.frame(
            "Timestamp" = Sys.time(),
            "Author"    = input$author,
            "Notes"     = input$notes,
            "Lat"       = lat,
            "Lon"       = lng
        )
        sheet_append(temp,
                     ss = "https://docs.google.com/spreadsheets/d/1gGeYpebQuhXFVDjec9_gpHzTckEPnL-xTOMwxlEtZ14/edit#gid=0")
        js$reset()
    })
    # Add table ----------------------------------------------------------------
    output$table <- DT::renderDataTable({
        events[, c("Author", "Notes", "Timestamp")] %>%
            st_set_geometry(NULL) %>%
            DT::datatable(
                rownames = FALSE,
                escape = FALSE,
                width = "100%",
                extensions = c("Scroller"),
                options = list(
                    dom = "ti",
                    scroller     = TRUE,
                    scrollX      = TRUE,
                    scrollY      = TRUE,
                    ordering     = FALSE,
                    pageLength   = 3,
                    autoWidth    = FALSE,
                    lengthChange = FALSE,
                    searching    = TRUE,
                    bInfo        = FALSE,
                    bPaginate    = TRUE,
                    bFilter      = FALSE
                ))
    })
})
