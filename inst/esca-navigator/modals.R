modal_about <- function() {
  showModal(
    modalDialog(
      box(
        width = 12,
        # h5("Background"),
        # p("This app was designed by City of Seaside personnel to engage with ESCA property data. To use the app, toggle on and off each desired layer on the upper right hand corner."),
        # tags$hr(),
        h5("Disclaimer"),
        p("The data included in this app are all made freely available by multiple data providers or gathered by the ESCA team. These data are provided 'AS IS.' SEASIDE makes no warranties, express or implied, including without limitation, any implied warranties of merchantability and/or fitness for a particular purpose, regarding the accuracy, completeness, value, quality, validity, merchantability, suitability, and/or condition, of the data. Users of SEASIDE's ESCA data are hereby notified that current public primary information sources should be consulted for verification of the data and information contained herein. Since the data are dynamic, it will by its nature be inconsistent with the official assessment roll file, surveys, maps and/or other documents produced by relevant data providers. Any use of SEASIDE's ESCA data is done exclusively at the risk of the party making such use."),
        tags$hr(),
        tags$h5("Metadata"),
        tags$p("The data for this application were procured through the following:"),
        tags$ol(
          tags$li(tags$b("County parcels:"), "Monterey County Open Data Portal", tags$a(href = "https://montereycountyopendata-12017-01-13t232948815z-montereyco.opendata.arcgis.com/datasets/parcels-data/geoservice?geometry=-122.026%2C36.559%2C-121.536%2C36.655", "Parcels Data layer.")),
          tags$li(tags$b("ESCA Parcels:"), "Ft. Ord Cleanup Open Data Portal,", tags$a(href = "https://maps.fodis.net/server/rest/services/FeatureServices/PublicParcels/MapServer/2", "Fort Ord Parcels layer.")),
          tags$li(tags$b("Former Ft. Ord boundaries:"), "Ft. Ord Cleanup Open Data Portal,", tags$a(href = "https://fort-ord-cleanup-open-data-cespk.hub.arcgis.com/datasets/installation-historical-area?geometry=-121.988%2C36.584%2C-121.542%2C36.681", "Installation Historical Area.")),
          tags$li(tags$b("Gates and Roads:"), tags$a(href = "https://csumb.edu/wee", "CSUMB's Watershed Environment and Ecology Lab.")),
          tags$li(tags$b("Land Use Controls (LUCS):"),"Recorded from the Land Use Controls Implementation Plan for each MRA, these can be found in the Administrative Record,", tags$a(href = "https://www.fortordcleanup.com/documents/administrative-record/", "here.")),
        ),
        tags$hr(),
        p("All code used for this app is available on", tags$a(href = "https://github.com/cjcallag/esca", "Github."), "For questions please email Chris Callaghan at ccallaghan@ci.seaside.ca.us.")
      )
    )
  )
}