suppressPackageStartupMessages({
  library(devtools)
  library(DT)
  library(googlesheets4)
  library(htmltools)
  library(htmlwidgets)
  library(leaflet)
  library(leaflet.extras)
  library(sf)
  library(shiny)
  library(shinycssloaders)
  library(shinydashboard)
  library(shinyjs)
  library(shinythemes)
  library(stringr)
})

# Source files with additional functionalities =================================
source("modals.R")

# Set up JS:
jsResetCode <- "shinyjs.reset = function() {history.go(0)}"

# Set up Google ================================================================
# https://medium.com/@JosiahParry/googlesheets4-authentication-for-deployment-9e994b4c81d6
options(gargle_oauth_cache = ".secrets",
        gargle_oauth_email = "cjcallaghan88@gmail.com")

# Additional functions =========================================================
# https://stackoverflow.com/questions/3518504/regular-expression-for-matching-latitude-longitude-coordinates
validate_coords <- function(coords) {
  str_detect(coords, paste0('^[-+]?([1-8]?\\d(\\.\\d+)?|90(\\.0+)?)\\s*,\\s*[-+]?(180(\\.0+)?|((1[0-7]\\d)',
                            '|([1-9]?\\d))(\\.\\d+)?)$'))
}

# Import data ==================================================================
roads   <- esca::roads
gates   <- esca::gates
ftord   <- esca::ft_ord
parcels <- esca::parcels
esca    <- esca::esca_parcels
signs   <- esca::signs

# Clean data ===================================================================
delete_me <- row.names(
  esca[esca$COENumber == "S1.3.2" & esca$imparea_id != "CSUMB Off-Campus", ]
)
esca      <- esca[!row.names(esca) %in% delete_me, ]
delete_me <- row.names(
  esca[esca$COENumber %in% c("E38", "E39", "E42", "E41", "E40") &
         esca$imparea_id != "Interim Action Range", ])
esca      <- esca[!row.names(esca) %in% delete_me, ]
delete_me <- row.names(
  esca[esca$COENumber == "L5.7" & esca$imparea_id != "County North", ]
)
esca      <- esca[!row.names(esca) %in% delete_me, ]
delete_me <- row.names(
  esca[esca$COENumber == "L20.5.1" & esca$imparea_id != "Barloy Canyon", ]
)
esca      <- esca[!row.names(esca) %in% delete_me, ]
delete_me <- row.names(
  esca[esca$COENumber == "E19a.4" & esca$imparea_id != "Parker Flats", ]
)
esca      <- esca[!row.names(esca) %in% delete_me, ]
delete_me <- row.names(
  esca[esca$COENumber == "E19a.3" & esca$imparea_id != "Parker Flats", ]
)
esca      <- esca[!row.names(esca) %in% delete_me, ]

# Add MRA variables ============================================================
esca[["mra"]] <- "Group 1"
esca[["mra"]] <- ifelse(esca[["imparea_id"]] %in% c("County North",
                                                    "CSUMB Off-Campus"),
                        "Group 2",
                        esca[["mra"]])
esca[["mra"]] <- ifelse(esca[["imparea_id"]] %in% c("Barloy Canyon", 
                                                    "DRO / Monterey", 
                                                    "Interim Action Range",
                                                    "Laguna Seca Parking",
                                                    "MOUT"),
                        "Group 3",
                        esca[["mra"]])
esca[["mra"]] <- ifelse(esca[["imparea_id"]] %in% c("Future East Garrison"),
                        "Group 4",
                        esca[["mra"]])

# Add MRA hyperlinks to LUCIP/OMPs =============================================
esca[["mra_link"]] <- "<a href='https://docs.fortordcleanup.com/ar_pdfs/AR-ESCA-0361B//ESCA-0361B.pdf'>Group 1</a>"
esca[["mra_link"]] <- ifelse(esca[["mra"]] == "Group 2",
                             "<a href='https://docs.fortordcleanup.com/ar_pdfs/AR-ESCA-0337B//ESCA-0337B.pdf'>Group 2</a>",
                             esca[["mra_link"]])
esca[["mra_link"]] <- ifelse(esca[["mra"]] == "Group 3",
                             "<a href='https://docs.fortordcleanup.com/ar_pdfs/AR-ESCA-0301B//ESCA-0301B.pdf'>Group 3</a>",
                             esca[["mra_link"]])
esca[["mra_link"]] <- ifelse(esca[["mra"]] == "Group 4",
                             "<a href='https://docs.fortordcleanup.com/ar_pdfs/AR-ESCA-0364B//ESCA-0364B.pdf'>Group 4</a>",
                             esca[["mra_link"]])

# Add MRA LUC ==================================================================
checkmark <- function(x) {
  sapply(x, function(y) ifelse(y != "Yes" | is.na(y),  "", "<span>&#10003;</span>"))
}
esca[["mra_luc"]] <- paste0("<table><thead>
                             <tr><th colspan='9'><center>", esca[["Covenant"]],"</center></th></tr>",
                            "<tr><th>C1</th><th>C2</th><th>C3</th><th>C4</th><th>C5</th><th>C6</th><th>C7</th><th>C8</th><th>C9</th></tr></thead>",
                            "<tr>",
                            "<td>", checkmark(esca[["C1"]]), "</td>",
                            "<td>", checkmark(esca[["C2"]]), "</td>",
                            "<td>", checkmark(esca[["C3"]]), "</td>",
                            "<td>", checkmark(esca[["C4"]]), "</td>",
                            "<td>", checkmark(esca[["C5"]]), "</td>",
                            "<td>", checkmark(esca[["C6"]]), "</td>",
                            "<td>", checkmark(esca[["C7"]]), "</td>",
                            "<td>", checkmark(esca[["C8"]]), "</td>",
                            "<td>", checkmark(esca[["C9"]]), "</td>",
                            "</tr>",
                            "</table>")


# Add MRA LE POC ===============================================================
esca[["mra_poc"]] <- "<table>
                             <tr><th><b>Name: </b></th><td>TBD</td></tr>
                             <tr><th><b>Title: </b></th><td>TBD</td></tr>
                             <tr><th><b>Agency: </b></th><td>TBD</td></tr>
                             <tr><th><b>Number: </b></th><td>TBD</td></tr>
                             <tr><th><b>Email: </b></th><td>TBD</td></tr>
                      </table>"
esca[["mra_poc"]] <- ifelse(esca[["Jurisdicti"]] == "Seaside" |
                              esca[["Jurisdicti"]] == "MPC (Seaside)",
                            "<table>
                             <tr><th><b>Name: </b></th><td>Borges, Nicholas</td></tr>
                             <tr><th><b>Title: </b></th><td>Deputy Police Chief</td></tr>
                             <tr><th><b>Agency: </b></th><td>Seaside Police Department</td></tr>
                             <tr><th><b>Number: </b></th><td>(831) 899-6892</td></tr>
                             <tr><th><b>Email: </b></th><td>nborges@ci.seaside.ca.us</td></tr>
                            </table>",
                            esca[["mra_poc"]]
)
esca[["mra_poc"]] <- ifelse(esca[["Jurisdicti"]] == "Del Rey Oaks",
                            "<table>
                             <tr><th><b>Name: </b></th><td>Hoyne, Jeff</td></tr>
                             <tr><th><b>Title: </b></th><td>Police Chief</td></tr>
                             <tr><th><b>Agency: </b></th><td>Del Rey Oaks Police Department</td></tr>
                             <tr><th><b>Number: </b></th><td>(831) 375-8525</td></tr>
                             <tr><th><b>Email: </b></th><td>jhoyne@delreyoaks.org</td></tr>
                            </table>",
                            esca[["mra_poc"]]
)
esca[["mra_poc"]] <- ifelse(esca[["Jurisdicti"]] == "City of Monterey",
                            "<table>
                             <tr><th><b>Name: </b></th><td>Hober, Dave</td></tr>
                             <tr><th><b>Title: </b></th><td>Police Chief</td></tr>
                             <tr><th><b>Agency: </b></th><td>City of Monterey Police Department</td></tr>
                             <tr><th><b>Number: </b></th><td>(831) 646-3800</td></tr>
                             <tr><th><b>Email: </b></th><td>hober@monterey.org</td></tr>
                            </table>",
                            esca[["mra_poc"]]
)
esca[["mra_poc"]] <- ifelse(esca[["Jurisdicti"]] == "CSUMB (Monterey County)",
                            "<table>
                             <tr><th><b>Name: </b></th><td>Folsom, Ken</td></tr>
                             <tr><th><b>Title: </b></th><td>Emergency Manager</td></tr>
                             <tr><th><b>Agency: </b></th><td>University Police Department</td></tr>
                             <tr><th><b>Number: </b></th><td>(831) 582-3000</td></tr>
                             <tr><th><b>Email: </b></th><td>kfolsom@csumb.edu</td></tr>
                            </table>",
                            esca[["mra_poc"]]
)
## TODO: Figure out who the county LE POC would be...
