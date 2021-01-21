suppressWarnings(suppressMessages({
  library(shiny)
  library(shinycssloaders)
  library(shinythemes)
  library(shinyjs)
  library(DT)
  library(googlesheets4)
  library(htmlwidgets)
  library(leaflet)
  library(sf)
  library(stringr)
}))

# Set up Google ================================================================
# https://medium.com/@JosiahParry/googlesheets4-authentication-for-deployment-9e994b4c81d6
options(gargle_oauth_cache = ".secrets",
        gargle_oauth_email = "cjcallaghan88@gmail.com")
jsResetCode <- "shinyjs.reset = function() {history.go(0)}"

# # Spatial data =================================================================
# ftord   <- esca::ft_ord
# esca    <- esca::esca_parcels
# # Clean data -------------------------------------------------------------------
# delete_me <- row.names(
#   esca[esca$COENumber == "S1.3.2" & esca$imparea_id != "CSUMB Off-Campus", ]
# )
# esca      <- esca[!row.names(esca) %in% delete_me, ]
# delete_me <- row.names(
#   esca[esca$COENumber %in% c("E38", "E39", "E42", "E41", "E40") &
#          esca$imparea_id != "Interim Action Range", ])
# esca      <- esca[!row.names(esca) %in% delete_me, ]
# delete_me <- row.names(
#   esca[esca$COENumber == "L5.7" & esca$imparea_id != "County North", ]
# )
# esca      <- esca[!row.names(esca) %in% delete_me, ]
# delete_me <- row.names(
#   esca[esca$COENumber == "L20.5.1" & esca$imparea_id != "Barloy Canyon", ]
# )
# esca      <- esca[!row.names(esca) %in% delete_me, ]
# delete_me <- row.names(
#   esca[esca$COENumber == "E19a.4" & esca$imparea_id != "Parker Flats", ]
# )
# esca      <- esca[!row.names(esca) %in% delete_me, ]
# delete_me <- row.names(
#   esca[esca$COENumber == "E19a.3" & esca$imparea_id != "Parker Flats", ]
# )
# esca      <- esca[!row.names(esca) %in% delete_me, ]
# # Add MRA variables ------------------------------------------------------------
# esca[["mra"]] <- "Group 1"
# esca[["mra"]] <- ifelse(esca[["imparea_id"]] %in% c("County North",
#                                                     "CSUMB Off-Campus"),
#                         "Group 2",
#                         esca[["mra"]])
# esca[["mra"]] <- ifelse(esca[["imparea_id"]] %in% c("Barloy Canyon", 
#                                                     "DRO / Monterey", 
#                                                     "Interim Action Range",
#                                                     "Laguna Seca Parking",
#                                                     "MOUT"),
#                         "Group 3",
#                         esca[["mra"]])
# esca[["mra"]] <- ifelse(esca[["imparea_id"]] %in% c("Future East Garrison"),
#                         "Group 4",
#                         esca[["mra"]])
# saveRDS(esca, file = "data/esca.RDS")
# saveRDS(ftord, file = "data/ftord.RDS")

esca  <- readRDS("data/esca.RDS")
ftord <- readRDS("data/ftord.RDS")

# Additional functions =========================================================
# https://stackoverflow.com/questions/3518504/regular-expression-for-matching-latitude-longitude-coordinates
validate_coords <- function(coords) {
  str_detect(coords, paste0('^[-+]?([1-8]?\\d(\\.\\d+)?|90(\\.0+)?)\\s*,\\s*[-+]?(180(\\.0+)?|((1[0-7]\\d)',
                            '|([1-9]?\\d))(\\.\\d+)?)$'))
}