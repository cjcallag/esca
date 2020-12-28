# Load up all required packages ================================================
devtools::install_github("cjcallag/esca")
suppressPackageStartupMessages({
  library(esca)
  library(htmltools)
  library(leaflet)
  library(shiny)
  library(shinythemes)
})

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

