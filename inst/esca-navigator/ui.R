shinyUI(
    fluidPage(
        use_cicerone(),
        includeCSS("extra.css"), 
        tags$style('.container-fluid {background-color: #FFFFFF;}'),
        titlePanel(
            tags$div(
                tags$img(src = "logo.png"), "ESCA Explorer",
                tags$span(actionButton('load_about', 'About'),
                          style = "position:absolute;right:0.5em;")
            ),
            windowTitle = "ESCA Explorer"
            ),
        theme = shinytheme("paper"),
        fluidRow(
            tags$style(type = "text/css", "#map {height: calc(100vh - 120px) !important;}"),
            absolutePanel(top = 120, left = 10, right = "auto", bottom = "auto", width = 250, height = "auto", draggable = FALSE,
                          wellPanel(
                              tags$h4("Parcel Glimpses"),
                              selectInput(inputId = "data_set",
                                          label = "Color by:",
                                          choices = c("Munitions Response Areas",
                                                      "Municipal Jurisdictions",
                                                      "Ownership",
                                                      "Proposed Reuse"))),
                          style = "opacity: 1; z-index:10;"),
            withSpinner(leafletOutput("map"), type = 6, size = 2)
        ) # fluidRow
    ) # fluidPage
)