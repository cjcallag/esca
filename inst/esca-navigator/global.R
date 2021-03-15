# Load up all required packages ================================================
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
load("data/esca.rda")
load("data/ft_ord.rda")
load("data/roads.rda")
load("data/gates.rda")
load("data/parcels.rda")


# Add MRA LUC ==================================================================
checkmark <- function(x) {
  sapply(x, function(y) ifelse(y != "Yes" | is.na(y),  "N/A", "<span>&#10003;</span>"))
}

lucs <- data.frame("group" = c("Group 1", "Group 2", "Group 3", "Group 4", "Interim Action Ranges"),
                   "lucip" = c("https://docs.fortordcleanup.com/ar_pdfs/AR-ESCA-0361E//ESCA-0361E.pdf",
                               "https://docs.fortordcleanup.com/ar_pdfs/AR-ESCA-0305B//ESCA-0305B.pdf",
                               "https://docs.fortordcleanup.com/ar_pdfs/AR-ESCA-0301B//ESCA-0301B.pdf",
                               "https://docs.fortordcleanup.com/ar_pdfs/AR-ESCA-0364B//ESCA-0364B.pdf",
                               "https://docs.fortordcleanup.com/ar_pdfs/AR-ESCA-0337B//ESCA-0337B.pdf"),
                   "rod"   = c("https://docs.fortordcleanup.com/ar_pdfs/AR-ESCA-0359//ESCA-0359.pdf",
                               "https://docs.fortordcleanup.com/ar_pdfs/AR-ESCA-0298/ESCA-0298.pdf",
                               "https://docs.fortordcleanup.com/ar_pdfs/AR-ESCA-0293/ESCA-0293.pdf",
                               "https://docs.fortordcleanup.com/ar_pdfs/AR-ESCA-0360//ESCA-0360.pdf",
                               "https://docs.fortordcleanup.com/ar_pdfs/AR-ESCA-0331//ESCA-0331.pdf"),
                   "Munitions recognition training" = c("Yes", "Yes", "Yes", "Yes", "Yes"),
                   "Construction support" = c("Yes", "Yes", "Yes", "Yes", "Yes"),
                   "Access management for habitat reserve" = c("Yes", NA, NA, "Yes", NA),
                   "Restrictions in residential use" = c("Yes", "Yes", "Yes", "Yes", "Yes"),
                   "Restriction against inconsistent use" = c("Yes", NA, NA, "Yes", "Yes")
                   )
esca <- merge(esca, lucs, by = "group")
esca[["Munitions.recognition.training"]] <- ifelse(esca[["mra"]] == "County North", "N/A", esca[["Munitions.recognition.training"]])
esca[["Construction.support"]] <- ifelse(esca[["mra"]] == "County North", "N/A", esca[["Construction.support"]])
esca[["Access.management.for.habitat.reserve"]] <- ifelse(esca[["mra"]] == "County North", "N/A", esca[["Access.management.for.habitat.reserve"]])
esca[["Restrictions.in.residential.use"]] <- ifelse(esca[["mra"]] == "County North", "N/A", esca[["Restrictions.in.residential.use"]])
esca[["Restriction.against.inconsistent.use"]] <- ifelse(esca[["mra"]] == "County North", "N/A", esca[["Restriction.against.inconsistent.use"]])

esca[["popup"]] <- paste0("<table>",
                          # COE Field -----------------------------
                          "<tr><th><b>COE Id: </b></th><td>",
                          esca[["coe"]],
                          "</td></tr>",
                          # MRA Field -----------------------------
                          "<tr><th><b>MRA: </b></th><td>", 
                          esca[["mra"]], 
                          "</td></tr>",
                          # Parcel Category Field -----------------
                          "<tr><th><b>HMP Category: </b></th><td>",
                          esca[["hmp_category"]],
                          "</td></tr>",
                          # Jurisdiction Field --------------------
                          "<tr><th><b>Land Owner: </b></th><td>",
                          esca[["land_holder"]], 
                          "</td></tr>",
                          # Jurisdiction Field --------------------
                          "<tr><th><b>Jurisdiction: </b></th><td>",
                          esca[["jurisdiction"]], 
                          "</td></tr>",
                          # Army ROD Field -----------------------
                          "<tr><th><b>ROD: </b></th><td>",
                          paste0("<a href=", esca[["rod"]], ">Here</a>"), 
                          "</td></tr>",
                          # LUCIP/OMP Field -----------------------
                          "<tr><th><b>LUCIP/OMP: </b></th><td>",
                          paste0("<a href=", esca[["lucip"]], ">Here</a>"), 
                          "</td></tr>",
                          # LUCs Field ----------------------------
                          "<tr><th><b>MRA LUCS: </b></th><td>",
                          "<table>
                            <tr><th scope='row'>Munitions recognition training</th><td>", checkmark(esca[["Munitions.recognition.training"]]),"</td></tr>",
                            "<tr><th scope='row'>Construction support</th><td>", checkmark(esca[["Construction.support"]]),"</td></tr>",
                            "<tr><th scope='row'>Access management for habitat reserve</th><td>", checkmark(esca[["Access.management.for.habitat.reserve"]]),"</td></tr>",
                            "<tr><th scope='row'>Restrictions in residential use</th><td>", checkmark(esca[["Restrictions.in.residential.use"]]),"</td></tr>",
                            "<tr><th scope='row'>Restrictions agains inconsistent use</th><td>", checkmark(esca[["Restriction.against.inconsistent.use"]]),"</td></tr>",
                          "</table>",
                          "</table>")