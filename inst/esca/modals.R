modal_about <- function() {
  showModal(
    modalDialog(
      box(
        width = 12,
        tags$br(),
        tags$div(
          tags$img(src = "logo.png", align = "center"),
          style="text-align: center;"), 
        tags$br(),
        tags$h3("Background"),
        tags$p("This app was designed to enable City of Seaside (SEASIDE) staff to engage with Environmental Services Cooperative Agreement (ESCA) program data."),
        tags$p("The data sets included in this app are all made freely available by multiple data providers or gathered by the ESCA team. This data is provided 'AS IS.' SEASIDE makes no warranties, express or implied, including without limitation, any implied warranties of merchantability and/or fitness for a particular purpose, regarding the accuracy, completeness, value, quality, validity, merchantability, suitability, and/or condition, of the data. Users of SEASIDE's ESCA data are hereby notified that current public primary information sources should be consulted for verification of the data and information contained herein. Since the data are dynamic, it will by its nature be inconsistent with the official assessment roll file, surveys, maps and/or other documents produced by relevant data providers. Any use of SEASIDE's ESCA data is done exclusively at the risk of the party making such use. "),
        tags$p("All code used for this app is available on", tags$a(href = "https://github.com/cjcallag/esca", "Github."), "For questions please email Chris Callaghan at ccallaghan@ci.seaside.ca.us.")
      )
    )
  )
}

modal_reporter_about <- function() {
  showModal(
    modalDialog(
      box(
        width = 12,
        tags$h3("FAQs"),
        tags$p("Below is a list of commonly asked questions:"),
        tags$ol(
          tags$li(tags$b("Should I complete one form per trip or per MRA?"), "Per MRA, ideally you should capture data on the changes for each area."),
          tags$li(tags$b("What if I missed a data point?"), "Not to worry, try to fill it in as soon as practical to the best of your knowledge."),
          tags$li(tags$b("What do I do when in doubt about a question?"), "When you are not sure, put your observations in the notes section."),
          tags$li(tags$b("Who can I ask for more information?"), "Any City of Seaside ESCA staff member, or the site admin.")
        )
      )
    )
  )
}

modal_explorer_about <- function() {
  showModal(
    modalDialog(
      box(
        width = 12,
        tags$h3("Metadata"),
        tags$p("The data for this section were procured from following sources:"),
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
        )
      )
    )
  )
}