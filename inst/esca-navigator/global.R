# Load up all required packages ================================================
# require(devtools)
# devtools::install_github("cjcallag/esca")
suppressPackageStartupMessages({
  require(esca)
  library(htmltools)
  library(leaflet)
  library(sf)
  library(shiny)
  library(shinydashboard)
  library(shinythemes)
})

# Source files with additional functionalities =================================
source("modals.R")

# repare data ==================================================================
roads <- esca::roads
gates <- esca::gates
ftord <- esca::ft_ord
parcels <- esca::parcels

roads[["color"]] <- "#ff7f00"
roads[["color"]] <- ifelse(roads[["surface_type"]] == "Highway",
                           "#e41a1c",
                           roads[["color"]])
roads[["color"]] <- ifelse(roads[["surface_type"]] == "Paved",
                           "#377eb8",
                           roads[["color"]])
roads[["color"]] <- ifelse(roads[["surface_type"]] == "Trail",
                           "#4daf4a",
                           roads[["color"]])
roads[["color"]] <- ifelse(roads[["surface_type"]] == "Unpaved",
                           "#984ea3",
                           roads[["color"]])

