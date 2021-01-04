shinyServer(function(input, output) {
  modal_about()
  # Set up observers ===========================================================
  observeEvent(input$load_about, {
    modal_about()
  })
  # Get map ====================================================================
  output$map <- renderLeaflet({
    my_pal <- colorFactor(palette  = c("#7fc97f", "#beaed4", "#fdc086", "#ffff99"),
                          domain   = esca[["mra"]],
                          na.color = "#ff7f00")
    leaflet() %>%
      # Base groups
      addProviderTiles(providers$Stamen.TonerLite, group = "Basemap") %>%
      addProviderTiles(providers$Esri.WorldImagery, group = "Imagery") %>%
      # Overlay groups
      addPolygons(data    = ftord,
                  fill    = FALSE,
                  weight  = 4, 
                  color   = "#000000",
                  opacity = 1,
                  group   = "Ft. Ord Boundary") %>%
      addPolygons(data        = esca,
                  fillColor   = ~my_pal(esca[["mra"]]),
                  fillOpacity = 1,
                  weight      = 1, 
                  opacity     = 1,
                  color       = "#000000",
                  popup       = paste0("<table>",
                                       # MRA Field -----------------------------
                                       "<tr><th><b>MRA: </b></th><td>", 
                                       esca[["imparea_id"]], 
                                       "</td></tr>",
                                       # COE Field -----------------------------
                                       "<tr><th><b>COE Id: </b></th><td>",
                                       esca[["FortOrd.DBO.tblParcel.COENumber"]],
                                       "</td></tr>",
                                       # Parcel Category Field -----------------
                                       "<tr><th><b>Parcel Category: </b></th><td>",
                                       esca[["FortOrd.DBO.tblParcel.HMP_category"]],
                                       "</td></tr>",
                                       # LUCIP/OMP Field -----------------------
                                       "<tr><th><b>LUCIP/OMP: </b></th><td>",
                                       esca[["mra_link"]], 
                                       "</td></tr>",
                                       # Jurisdiction Field --------------------
                                       "<tr><th><b>Jurisdiction: </b></th><td>",
                                       esca[["FortOrd.DBO.tblParcel.Jurisdiction"]], 
                                       "</td></tr>",
                                       # LE Contact Field ----------------------
                                       "<tr><th><b>LE POC: </b></th><td>",
                                       esca[["mra_poc"]],
                                       "</td></tr>",
                                       "</table>"),
                  group       = "ESCA Parcels") %>%
      addPolygons(data        = parcels,
                  fillColor   = "grey",
                  fillOpacity = 0.25,
                  weight      = 1,
                  opacity     = 1,
                  color       = "#000000",
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
                  group       = "County Parcels") %>%
      addPolylines(data      = roads,
                   group     = "Roads",
                   weight    = 3,
                   label     = roads$name,
                   opacity   = 0.5,
                   color     = "#000000",
                   dashArray = "5",
                   stroke    = TRUE,
                   popup     = paste0("<table>",
                                      # Name Field -------------------------------
                                      "<tr><th><b>Name: </b></th><td>",
                                      roads$name, 
                                      "</td></tr>",
                                      # Surface Field ----------------------------
                                      "<tr><th><b>Surface: </b></th><td>",
                                      roads$surface_type,
                                      "</td></tr>",
                                      "</table>")) %>%
      addCircles(data        = gates,
                 stroke      = TRUE,
                 group       = "Gates",
                 color       = "red",
                 fill        = "red",
                 fillOpacity = 1,
                 opacity     = 1,
                 popup       = paste0("<table>",
                                      # Name Field -----------------------------
                                      "<tr><th><b>Name: </b></th><td>",
                                      gates$name, 
                                      "</td></tr>",
                                      # Type Field -----------------------------
                                      "<tr><th><b>Type: </b></th><td>",
                                      gates$gate_type, 
                                      "</td></tr>",
                                      # Width Field ----------------------------
                                      "<tr><th><b>Width: </b></th><td>",
                                      gates$width, 
                                      " feet</td></tr>",
                                      "</table>")) %>%
      # Layers control
      addLayersControl(
          baseGroups    = c("Basemap", "Imagery"),
          overlayGroups = c("ESCA Parcels", "Ft. Ord Boundary", "Gates", "County Parcels", "Roads"),
          position      = "topright",
          options       = layersControlOptions(collapsed = FALSE)) %>%
      hideGroup(c("Gates", "County Parcels", "Roads")) %>%
      addLegend(position = "bottomright",
                pal      = my_pal,
                values   = esca[["mra"]],
                title    = "MRAs",
                opacity  = 1) %>%
      setView(lng = -121.78, lat = 36.611, zoom = 12.5) %>%
      addMiniMap(
        tiles         = providers$Stamen.TonerLite,
        toggleDisplay = TRUE,
        minimized     = FALSE,
        strings       = list(hideText = "Hide MiniMap",
                             showText = "Show MiniMap"),
        position      = "bottomleft")
  })
    }) 
