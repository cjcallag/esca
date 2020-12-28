shinyUI(
    fluidPage(
        tags$style('.container-fluid {background-color: #FFFFFF;}'),
        titlePanel(tags$div(
            tags$img(src = "logo.png"), "ESCA Explorer")
            ),
        theme = shinytheme("paper"),
        tags$br(),
        fluidRow(
            tags$style(type = "text/css", "#map {height: calc(100vh - 110px) !important;}"),
            leafletOutput("map")
        )
    )
)