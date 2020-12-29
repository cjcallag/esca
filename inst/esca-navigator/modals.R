modal_about <- function() {
  showModal(
    modalDialog(
      box(
        width = 12,
        h3("Background"),
        p("This app was designed to enable City of Seaside personnel to engage with ESCA property data. As such, layers for roads, access points (gates), and parcels have been included. To use the app, toggle on and off each desired layer on the upper right hand corner."),
        tags$hr(),
        tags$h3("Metadata"),
        tags$p("The data for this application were procured through the following:"),
        tags$ol(
          tags$li(tags$b("County parcels:"), "Monterey County Open Data Portal, Parecels Data layer, found", tags$a(href = "https://montereycountyopendata-12017-01-13t232948815z-montereyco.opendata.arcgis.com/datasets/parcels-data/geoservice?geometry=-122.026%2C36.559%2C-121.536%2C36.655", "here.")),
          tags$li(tags$b("Former Ft. Ord boudaries:"), "Ft. Ord Cleanup Open Data Portal, Installation Historical Area layer, found", tags$a(href = "https://fort-ord-cleanup-open-data-cespk.hub.arcgis.com/datasets/installation-historical-area?geometry=-121.988%2C36.584%2C-121.542%2C36.681", "here.")),
          tags$li(tags$b("Roads and gates:"), "CSUMB's Watershed Environment and Ecology Lab,", tags$a(href = "www.csumb.edu/wee", "here.")),
        ),
        p("All code used for this app if freely available on Github,", tags$a(href = "https://github.com/cjcallag/esca", "here."))
      )
    )
  )
}