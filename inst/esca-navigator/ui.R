shinyUI(
    fluidPage(
        includeCSS("extra.css"), 
        tags$style('.container-fluid {background-color: #FFFFFF;}'),
        titlePanel(tags$div(
            tags$img(src = "logo.png"), 
            "ESCA Explorer",
            tags$span(actionButton('load_about', 'About'),
                      style = "position:absolute;right:0.5em;")
            ),
            windowTitle = "ESCA-Explorer"
            ),
        theme = shinytheme("paper"),
        tags$br(),
        fluidRow(
            tags$style(type = "text/css", "#map {height: calc(100vh - 110px) !important;}"),
            withSpinner(
                leafletOutput("map"),
                type = 4
                )
        )
    )
)