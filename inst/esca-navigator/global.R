# Load up all required packages ================================================
# library(devtools)
# if(require(esca) == FALSE)
#   devtools::install_github("cjcallag/esca")

suppressPackageStartupMessages({
  library(htmltools)
  library(leaflet)
  library(sf)
  library(shiny)
  library(shinycssloaders)
  library(shinydashboard)
  library(shinythemes)
})

# Source files with additional functionalities =================================
source("modals.R")

# Import data ==================================================================
roads   <- esca::roads
gates   <- esca::gates
ftord   <- esca::ft_ord
parcels <- esca::parcels
esca    <- esca::esca_parcels

# Clean data ===================================================================
delete_me <- row.names(
  esca[esca$FortOrd.DBO.tblParcel.COENumber == "S1.3.2" &
         esca$imparea_id != "CSUMB Off-Campus", ]
  )
esca      <- esca[!row.names(esca) %in% delete_me, ]
delete_me <- row.names(
  esca[esca$FortOrd.DBO.tblParcel.COENumber %in% c("E38", "E39", "E42", "E41", "E40") &
         esca$imparea_id != "Interim Action Range", ])
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

# Add MRA LE POC ===============================================================
esca[["mra_poc"]] <- "<table>
                             <tr><th><b>Name: </b></th><td>TBD</td></tr>
                             <tr><th><b>Title: </b></th><td>TBD</td></tr>
                             <tr><th><b>Agency: </b></th><td>TBD</td></tr>
                             <tr><th><b>Number: </b></th><td>TBD</td></tr>
                             <tr><th><b>Email: </b></th><td>TBD</td></tr>
                      </table>"
esca[["mra_poc"]] <- ifelse(esca[["FortOrd.DBO.tblParcel.Jurisdiction"]] == "Seaside",
                            "<table>
                             <tr><th><b>Name: </b></th><td>Borges, Nicholas</td></tr>
                             <tr><th><b>Title: </b></th><td>Deputy Police Chief</td></tr>
                             <tr><th><b>Agency: </b></th><td>Seaside Police Department</td></tr>
                             <tr><th><b>Number: </b></th><td>(831) 899-6892</td></tr>
                             <tr><th><b>Email: </b></th><td>nborges@ci.seaside.ca.us</td></tr>
                            </table>",
                            esca[["mra_poc"]]
                            )
esca[["mra_poc"]] <- ifelse(esca[["FortOrd.DBO.tblParcel.Jurisdiction"]] == "Del Rey Oaks",
                            "<table>
                             <tr><th><b>Name: </b></th><td>Hoyne, Jeff</td></tr>
                             <tr><th><b>Title: </b></th><td>Police Chief</td></tr>
                             <tr><th><b>Agency: </b></th><td>Del Rey Oaks Police Department</td></tr>
                             <tr><th><b>Number: </b></th><td>(831) 375-8525</td></tr>
                             <tr><th><b>Email: </b></th><td>jhoyne@delreyoaks.org</td></tr>
                            </table>",
                            esca[["mra_poc"]]
)
esca[["mra_poc"]] <- ifelse(esca[["FortOrd.DBO.tblParcel.Jurisdiction"]] == "City of Monterey",
                            "<table>
                             <tr><th><b>Name: </b></th><td>Hober, Dave</td></tr>
                             <tr><th><b>Title: </b></th><td>Police Chief</td></tr>
                             <tr><th><b>Agency: </b></th><td>City of Monterey Police Department</td></tr>
                             <tr><th><b>Number: </b></th><td>(831) 646-3800</td></tr>
                             <tr><th><b>Email: </b></th><td>hober@monterey.org</td></tr>
                            </table>",
                            esca[["mra_poc"]]
)
esca[["mra_poc"]] <- ifelse(esca[["imparea_id"]] == "CSUMB Off-Campus",
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



# OLD ==========================================================================
# roads[["color"]] <- "#ff7f00"
# roads[["color"]] <- ifelse(roads[["surface_type"]] == "Highway",
#                            "#e41a1c",
#                            roads[["color"]])
# roads[["color"]] <- ifelse(roads[["surface_type"]] == "Paved",
#                            "#377eb8",
#                            roads[["color"]])
# roads[["color"]] <- ifelse(roads[["surface_type"]] == "Trail",
#                            "#4daf4a",
#                            roads[["color"]])
# roads[["color"]] <- ifelse(roads[["surface_type"]] == "Unpaved",
#                            "#984ea3",
#                            roads[["color"]])

