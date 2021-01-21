shinyServer(function(input, output, session) {
    # Global ===================================================================
    modal_about()
    observeEvent(input$load_explorer_about, {
        modal_explorer_about()
    })
    observeEvent(input$load_reporter_about, {
        modal_reporter_about()
    })
    shinyjs::runjs('document.getElementById("reporter_map").style.cursor = "crosshair"')

    events <- googlesheets4::read_sheet("https://docs.google.com/spreadsheets/d/1gGeYpebQuhXFVDjec9_gpHzTckEPnL-xTOMwxlEtZ14/edit#gid=0",
                                        range = "reports")
    events <- sf::st_as_sf(events, coords = c("Lon", "Lat"), crs = '4326')
    
    # Explorer Tab =============================================================
    # Set map ------------------------------------------------------------------
    output$map <- renderLeaflet({
        my_pal <- colorFactor(palette = c("#7fc97f", "#beaed4", "#fdc086",
                                          "#ffff99"), domain = esca[["mra"]],
                              na.color = "#ff7f00")
        leaflet() %>%
            addProviderTiles(providers$Stamen.TonerLite, group = "Basemap") %>%
            addProviderTiles(providers$Esri.WorldImagery, group = "Imagery") %>%
            addResetMapButton() %>% 
            addPolygons(data = ftord, fill = FALSE, weight = 4, opacity = 1,
                        color = "#000000", group = "Ft. Ord Boundary") %>%
            addPolygons(data = esca, fillColor   = ~my_pal(esca[["mra"]]),
                        fillOpacity = 1, weight = 1, opacity = 1,
                        color = "#000000", label = ~COENumber,
                        popup = paste0("<table>",
                                       "<tr><th><b>MRA: </b></th><td>", 
                                       esca[["imparea_id"]], "</td></tr>",
                                       "<tr><th><b>COE Id: </b></th><td>",
                                       esca[["COENumber"]], "</td></tr>",
                                       "<tr><th><b>Parcel Category: </b></th><td>",
                                       esca[["HMP_category"]], "</td></tr>",
                                       "<tr><th><b>LUCIP/OMP: </b></th><td>",
                                       esca[["mra_link"]], "</td></tr>",
                                       "<tr><th><b>Covenant: </b></th><td>",
                                       esca[["mra_luc"]], "</td></tr>",
                                       "<tr><th><b>Jurisdiction: </b></th><td>",
                                       esca[["Jurisdicti"]], "</td></tr>",
                                       "<tr><th><b>LE POC: </b></th><td>",
                                       esca[["mra_poc"]], "</td></tr>",
                                       "</table>"), 
                        group = "ESCA Parcels") %>%
            addPolygons(data = parcels, fillColor = "grey", fillOpacity = 0.25,
                        weight = 1, opacity = 1, color = "#000000",
                        popup = paste0("<table>",
                                       "<tr><th><b>APN: </b></th><td>",
                                       parcels$APN, "</td></tr>",
                                       "<tr><th><b>Acres: </b></th><td>",
                                       parcels$GIS_ACRES, "</td></tr>",
                                       "</table>"), 
                        group = "County Parcels") %>%
            addPolylines(data = roads, group = "Roads and Trails", weight = 3, 
                         label = roads$name, opacity = 0.5, color = "#000000",
                         dashArray = "5", stroke = TRUE,
                         popup = paste0("<table>",
                                        "<tr><th><b>Name: </b></th><td>",
                                        roads$name, "</td></tr>",
                                        "<tr><th><b>Surface: </b></th><td>",
                                        roads$surface_type, "</td></tr>",
                                        "</table>")) %>%
            addCircles(data = signs, stroke = TRUE, group = "MEC Signs", 
                       color = "blue", fill = "blue", radius = 2.5,
                       fillOpacity = 1, opacity = 1) %>%
            addCircles(data = gates, stroke = TRUE, radius = 5, group = "Gates",
                       color = "red", fill = "red", fillOpacity = 1, opacity = 1,
                       popup = paste0("<table>",
                                      "<tr><th><b>Name: </b></th><td>",
                                      gates$name, "</td></tr>",
                                      "<tr><th><b>Type: </b></th><td>",
                                      gates$gate_type, "</td></tr>",
                                      "<tr><th><b>Width: </b></th><td>",
                                      gates$width, " feet</td></tr>",
                                      "</table>")) %>%
            addLayersControl(baseGroups    = c("Basemap", "Imagery"),
                overlayGroups = c("ESCA Parcels", "Ft. Ord Boundary", "Gates",
                                  "County Parcels", "Roads and Trails",
                                  "MEC Signs"), position = "topright",
                options = layersControlOptions(collapsed = FALSE)) %>%
            hideGroup(c("Gates", "County Parcels", "Roads and Trails",
                        "MEC Signs")) %>%
            addLegend(position = "bottomright", pal = my_pal, title    = "MRAs",
                      values = esca[["mra"]], opacity  = 1) %>%
            setView(lng = -121.78, lat = 36.611, zoom = 12.5) %>%
            addMiniMap(tiles         = providers$Stamen.TonerLite,
                       toggleDisplay = TRUE, minimized     = FALSE,
                strings       = list(hideText = "Hide MiniMap",
                                     showText = "Show MiniMap"),
                position      = "bottomleft")
        })
    # Set table ----------------------------------------------------------------
    output$table <- renderDT({
        wants <- c("COENumber", "ParcelName", "HMP_category", "Acreage",
                   "NewFORAName", "MRA", "mra", "Jurisdicti", "Covenant", "C1", 
                   "C2", "C3", "C4", "C5", "C6", "C7", "C8", "C9")
        esca %>%
            `st_geometry<-`(NULL) %>%
            .[, wants] %>%
            `names<-`(c("COE", "Parcel Name", "HMP Category", "Acreage",
                        "FORA Name", "MRA Name", "MRA Group", "Jurisdiction",
                        "Covenant", "No sensitive uses?",
                        "No soil disturbance or violation of ordinance without soil management plan?",
                        "Notification of MEC?", "Access rights?", 
                        "No construction of groundwater wells?",
                        "No disturbance or creation of recharge area?",
                        "Notify damages to remedy and monitoring systems?",
                        "No structures unless protective for LFG per Title 27?",
                        "No disturbance of system or cap?")) %>%
            DT::datatable(rownames = FALSE, escape = FALSE, filter = "top",
                extensions = c("ColReorder", "FixedHeader", "KeyTable", "Buttons"),
                options    = list(
                    dom = 'Bfrtip', buttons = c('copy', 'csv'), 
                    searchDelay = 500, colReorder  = TRUE, keys = TRUE,
                    scrollX = TRUE, scrollY = TRUE, searchHighlight = TRUE)
                )
    })
    
    # Reporter Tab =============================================================
    ## Add map -----------------------------------------------------------------
    output$reporter_map <- renderLeaflet({
        my_pal <- colorFactor(palette  = c("#7fc97f", "#beaed4", "#fdc086",
                                           "#ffff99"),
                              domain   = esca[["mra"]], na.color = "#ff7f00")
        leaflet(options = leafletOptions(minZoom = 4, maxZoom = 18,
                                         zoomControl = FALSE)) %>%
            addProviderTiles(providers$Esri.WorldImagery, group = "Imagery") %>%
            addResetMapButton() %>% 
            setView(lng = -121.78, lat = 36.62, zoom = 12.5) %>%
            addPolygons(data = esca, fillColor = ~my_pal(esca[["mra"]]),
                        fillOpacity = 0.25, weight = 1, opacity = 1,
                        color = ~my_pal(esca[["mra"]])) %>%
            addPolygons(data = ftord, fill = FALSE, weight = 4, 
                        color = "#000000", opacity = 1) %>%
            addCircles(data = events, color = "red", fill = "red", 
                       fillOpacity = 1, opacity = 1,
                       popup = paste0("<table>",
                                      "<tr><th><b>Timestamp: </b></th><td>",
                                      events[["Timestamp"]], "</td></tr>",
                                      "<tr><th><b>Author: </b></th><td>",
                                      events[["Author"]], "</td></tr>",
                                      "<tr><th><b>Type: </b></th><td>",
                                      events[["Type"]], "</td></tr>",
                                      "<tr><th><b>Notes: </b></th><td>",
                                      events[["Notes"]], "</td></tr>",
                                      "</table>")) %>%
            addLegend(position = "bottomright", pal = my_pal,
                      values = esca[["mra"]], title = "MRAs", opacity = 1)  %>%
            addEasyButton(
                easyButton(
                    position = "topleft",
                    icon     = "fa-crosshairs",
                    title    = "Locate Me",
                    onClick  = JS(c('function () {
                        navigator.geolocation.getCurrentPosition(onSuccess, onError);

                        function onError(err) {
                            Shiny.onInputChange("geolocation", false);
                        }

                        function onSuccess(position) {
                            setTimeout(function() {
                                var coords = position.coords;
                                console.log(coords.latitude + ", " + coords.longitude);
                                Shiny.onInputChange("geolocation", true);
                                Shiny.onInputChange("me_lat", coords.latitude);
                                Shiny.onInputChange("me_lon", coords.longitude);
                            }, 0)
                        }}'))
                )
            )
    })
    # Map click ----------------------------------------------------------------
    observeEvent(input$reporter_map_click, {
        lat <- input$reporter_map_click$lat
        lng <- input$reporter_map_click$lng
        updateTextInput(session = session, inputId = 'location',
                        value = paste0(lat, ', ', lng))
    })
    # Update map ---------------------------------------------------------------
    observeEvent(input$location, ignoreInit = TRUE, {
        if(validate_coords(input$location)) {
            update_coords <- str_replace(input$location, ' ', '') %>% 
                str_split(',')
            lat <- update_coords[[1]][1] %>% as.numeric()
            lng <- update_coords[[1]][2] %>% as.numeric()
            leafletProxy('reporter_map') %>%
                addAwesomeMarkers(lng = lng, lat = lat, layerId = 'location',
                                  icon = makeAwesomeIcon(icon = 'circle', 
                                                         markerColor = 'black',
                                                         library = 'fa', 
                                                         iconColor = '#fff'),
                                  popup = paste0(lat,', ', lng),
                                  popupOptions = popupOptions(closeButton = FALSE))
        } else {
            leafletProxy('reporter_map') %>%
                removeMarker('location')
        }
    })
    # Add data to sheet --------------------------------------------------------
    observeEvent(input$submit_form, {
        lat  <- input$reporter_map_click$lat
        lng  <- input$reporter_map_click$lng
        validate(
            need(
                validate_coords(paste0(lat, ",",  lng)),
                "Please select a latitude and longitude."
            )
        )
        
        temp <- data.frame(
            "Timestamp" = Sys.time(), "Author" = input$author,
            "Notes" = input$notes, "Lat" = lat, "Lon" = lng, "Type" = input$type
        )
        sheet_append(temp,
                     ss = "https://docs.google.com/spreadsheets/d/1gGeYpebQuhXFVDjec9_gpHzTckEPnL-xTOMwxlEtZ14/edit#gid=0")
        js$reset()
    })
    # Locate you:
    observe({
        if(!is.null(input$me_lat) & !is.null(input$me_lon)) {
            leafletProxy('reporter_map') %>%
                addAwesomeMarkers(lng = input$me_lon, lat = input$me_lat, layerId = 'me',
                                  icon = makeAwesomeIcon(icon = 'circle', 
                                                         markerColor = 'blue',
                                                         library = 'fa', 
                                                         iconColor = '#fff'),
                                  popupOptions = popupOptions(closeButton = FALSE))
        }
    })
    # Add table ----------------------------------------------------------------
    output$reporter_table <- DT::renderDataTable({
        events[, c("Author", "Notes", "Type", "Timestamp")] %>%
            st_set_geometry(NULL) %>%
            DT::datatable(rownames = FALSE, escape = FALSE, width = "100%", 
                          filter = "top", extensions = c("Scroller",
                                                         "ColReorder",
                                                         "FixedHeader",
                                                         "KeyTable",
                                                         "Buttons"),
                options    = list(dom = 'Bfrtip', buttons = c('copy', 'csv'), 
                                  searchDelay = 500, colReorder  = TRUE,
                                  keys = TRUE, scrollX = TRUE, scrollY = TRUE,
                                  searchHighlight = TRUE))
    })
    # Add data to monthly sheet ------------------------------------------------
    observeEvent(input$submit_monthly_form, {
        # monthly <- googlesheets4::read_sheet("https://docs.google.com/spreadsheets/d/1gGeYpebQuhXFVDjec9_gpHzTckEPnL-xTOMwxlEtZ14/edit#gid=1968862371",
        #                                     range = "monthly")
        out <- data.frame(
            "Timestamp" = Sys.time(), 
            "Site" = input$monthly_site,
            "Author" = input$monthly_author, 
            "changes_residence" = input$changes_residence,
            "changes_residence_notes" = input$changes_residence_notes,
            "changes_conditions" = input$changes_conditions,
            "changes_conditions_notes" = input$changes_conditions_notes,
            "changes_ownership" = input$changes_ownership,
            "changes_ownership_notes" = input$changes_ownership_notes,
            "changes_occupancy" = input$changes_occupancy,
            "changes_occupancy_notes" = input$changes_occupancy_notes,
            "monthly_notes" = input$monthly_notes,
            "luc_residential" = input$luc_residential,
            "luc_residential_notes" = input$luc_residential_notes,
            "luc_mec_training" = input$luc_mec_training,
            "luc_mec_training_notes" = input$luc_mec_training_notes,
            "luc_construction_support" = input$luc_construction_support,
            "luc_construction_support_notes" = input$luc_construction_support_notes,
            "luc_procedures" = input$luc_procedures,
            "luc_procedures_notes" = input$luc_procedures_notes,
            "luc_signage" = input$luc_signage,
            "luc_signage_notes" = input$luc_signage_notes 
        )
        validate(
            need(
                nrow(out) >= 1,
                "data.frame must be valid"
            )
        )
        sheet_append(out,
                     ss = "https://docs.google.com/spreadsheets/d/1gGeYpebQuhXFVDjec9_gpHzTckEPnL-xTOMwxlEtZ14/edit#gid=1968862371",
                     sheet = "monthly")
        js$reset()
    })
    # Add bi-monthly data
    observeEvent(input$submit_bimonthly_form, {
        yearly <- googlesheets4::read_sheet("https://docs.google.com/spreadsheets/d/1gGeYpebQuhXFVDjec9_gpHzTckEPnL-xTOMwxlEtZ14/edit#gid=967055197",
                                             range = "yearly")
        out <- data.frame(
            "bi_apn" = input$bi_apn,
            "bi_coe" = input$bi_coe,
            "bi_author" = input$bi_author,
            "date" = Sys.time(),
            "bi_a1" = input$bi_a1,
            "bi_a1_notes" = input$bi_a1_notes,
            "bi_a2" = input$bi_a2,
            "bi_a2_notes" = input$bi_a2_notes,
            "bi_a3" = input$bi_a3,
            "bi_a3_notes" = input$bi_a3_notes,
            "bi_b1" = input$bi_b1,
            "bi_b1_notes" = input$bi_b1_notes,
            "bi_b2" = input$bi_b2,
            "bi_b2_notes" = input$bi_b2_notes,
            "bi_b3" = input$bi_b3,
            "bi_b3_notes" = input$bi_b3_notes,
            "bi_b3.1" = input$bi_b3.1,
            "bi_b3.2" = input$bi_b3.2,
            "bi_b3.3" = input$bi_b3.3,
            "bi_c1" = input$bi_c1,
            "bi_c1_notes" = input$bi_c1_notes,
            "bi_c2" = input$bi_c2,
            "bi_c2_notes" = input$bi_c2_notes,
            "bi_c3" = input$bi_c3,
            "bi_c3_notes" = input$bi_c3_notes,
            "bi_c4" = input$bi_c4,
            "bi_c4_notes" = input$bi_c4_notes,
            "bi_c5" = input$bi_c5,
            "bi_c5_notes" = input$bi_c5_notes,
            "bi_d1" = input$bi_d1,
            "bi_d1_notes" = input$bi_d1_notes,
            "bi_d2" = input$bi_d2,
            "bi_d2_notes" = input$bi_d2_notes,
            "bi_d3" = input$bi_d3,
            "bi_d3_notes" = input$bi_d3_notes,
            "bi_d4" = input$bi_d4,
            "bi_d4_notes" = input$bi_d4_notes,
            "bi_e1" = input$bi_e1,
            "bi_f1" = input$bi_f1,
            "bi_f1_notes" = input$bi_f1_notes,
            "bi_f2" = input$bi_f2,
            "bi_f2_notes" = input$bi_f2_notes,
            "bi_f3" = input$bi_f3,
            "bi_f3_notes" = input$bi_f3_notes,
            "bi_f4" = input$bi_f4,
            "bi_f4_notes" = input$bi_f4_notes,
            "bi_f5" = input$bi_f5,
            "bi_f5_notes" = input$bi_f5_notes,
            "bi_g1" = input$bi_g1,
            "bi_g1_notes" = input$bi_g1_notes,
            "bi_g2" = input$bi_g2,
            "bi_g2_notes" = input$bi_g2_notes,
            "bi_g3" = input$bi_g3,
            "bi_g3_notes" = input$bi_g3_notes,
            "bi_h1_notes" = input$bi_h1_notes
        )
        validate(
            need(
                nrow(out) >= 1,
                "data.frame must be valid"
            )
        )
        sheet_append(out,
                     ss = "https://docs.google.com/spreadsheets/d/1gGeYpebQuhXFVDjec9_gpHzTckEPnL-xTOMwxlEtZ14/edit#gid=967055197",
                     sheet = "yearly")
        js$reset()
    })
})
