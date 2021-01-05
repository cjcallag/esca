modal_about <- function() {
  showModal(
    modalDialog(
      box(
        width = 12,
        h5("Background"),
        p("This app was designed to enable City of Seaside personnel to engage with ESCA property data. As such, layers for roads, access points (gates), and parcels have been included. To use the app, toggle on and off each desired layer on the upper right hand corner."),
        tags$hr(),
        tags$h5("Metadata"),
        tags$p("The data for this application were procured through the following:"),
        tags$ol(
          tags$li(tags$b("County parcels:"), "Monterey County Open Data Portal", tags$a(href = "https://montereycountyopendata-12017-01-13t232948815z-montereyco.opendata.arcgis.com/datasets/parcels-data/geoservice?geometry=-122.026%2C36.559%2C-121.536%2C36.655", "Parcels Data layer.")),
          tags$li(tags$b("ESCA Parcels:"), "Ft. Ord Cleanup Open Data Portal,", tags$a(href = "https://maps.fodis.net/server/rest/services/FeatureServices/PublicParcels/MapServer/2", "Fort Ord Parcels layer.")),
          tags$li(tags$b("Former Ft. Ord boundaries:"), "Ft. Ord Cleanup Open Data Portal,", tags$a(href = "https://fort-ord-cleanup-open-data-cespk.hub.arcgis.com/datasets/installation-historical-area?geometry=-121.988%2C36.584%2C-121.542%2C36.681", "Installation Historical Area.")),
          tags$li(tags$b("Gates and Roads:"), tags$a(href = "https://csumb.edu/wee", "CSUMB's Watershed Environment and Ecology Lab.")),
          tags$li(tags$b("Land Use Controls (LUCS):"), tags$a(href = "https://montereyco.maps.arcgis.com/apps/webappviewer/index.html?id=3ff375b917a74caf94671a2c8090e9c1", "Monterey County Resource Management Agency's Fort Ord Land Use Covenants."), "Here the LUCs have been recorded as follow:"),
          tags$br(),
          tags$table(id = "compacttable",
            tags$tr(
              tags$th("No sensitive uses?"),
              tags$td("C1"),
            ),
            tags$tr(
              tags$th("No soil disturbance or violation of ordinance without soil management plan?"),
              tags$td("C2"),
            ),
            tags$tr(
              tags$th("Notification of MEC?"),
              tags$td("C3"),
            ),
            tags$tr(
              tags$th("Access rights?"),
              tags$td("C4"),
            ),
            tags$tr(
              tags$th("No construction of groundwater wells?"),
              tags$td("C5"),
            ),
            tags$tr(
              tags$th("No disturbance or creation of recharge area?"),
              tags$td("C6"),
            ),
            tags$tr(
              tags$th("Notify damages to remedy and monitoring systems?"),
              tags$td("C7"),
            ),
            tags$tr(
              tags$th("No structures unless protective for LFG per Title 27?"),
              tags$td("C8"),
            ),
            tags$tr(
              tags$th("No disturbance of system or cap?"),
              tags$td("C9"),
            )
          )
        ),
        p("All code used for this app is available on", tags$a(href = "https://github.com/cjcallag/esca", "Github."), "For questions please email Chris Callaghan at ccallaghan@ci.seaside.ca.us.")
      )
    )
  )
}