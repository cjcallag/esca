tagList(useShinyjs(),
        navbarPage(theme = shinytheme('paper'),
                   title = tags$div(id = 'reporter',
                                    'ESCA Reporter'),
                   id    = 'navbar',
                    ),
        tabPanel(title = ' ',
                 # map panel ---------------------------------------------------
                 div(class = 'outer',
                     tags$head(tags$link(rel  = 'stylesheet',
                                         type = 'text/css',
                                         href = 'styles.css')),
                 absolutePanel(id    = 'coord_panel',
                               top   = 30,
                               right = 6,
                               width = 'auto',
                               pre(
                                   id = 'coords',
                                   '36.6066, -121.7818')
                               ),
                 # map ---------------------------------------------------------
                 leafletOutput('map', width = '100%', height = '80%'),
                 # withSpinner(
                 #   leafletOutput('map', width = '100%', height = '80%'),
                 #   type = 4
                 # ),
                 # table -------------------------------------------------------
                 DT::dataTableOutput('table', width = '100%', height = '20%')
             ),
             div(id = "side",
                 tags$head(tags$link(rel  = 'stylesheet',
                                     type = 'text/css',
                                     href = 'styles.css')),
                 absolutePanel(id    = 'sidebar',
                               top   = 60,
                               left  = 6,
                               width = 'auto',
                               checkboxInput(inputId = 'show_hide',
                                             label   = 'Add record?',
                                             value   = FALSE),
                               conditionalPanel(
                                   condition = 'input.show_hide == true',
                                   wellPanel(id = 'controls',
                                             textInput(inputId     = 'location',
                                                       label       = 'Incident location:',
                                                       placeholder = 'Location (e.g., 36.607, -121.782)',
                                                       width       = '100%'),
                                             textInput(inputId     = 'notes',
                                                       label       = 'Notes:',
                                                       width       = '100%',
                                                       placeholder = 'Add notes of find.'),
                                             selectInput(input   = 'author',
                                                         label   = 'Choose a reporter:',
                                                         width   = '100%',
                                                         choices = c('Abraam', 'Chris', 'Lesley')),
                                             fluidRow(
                                                 column(width =12,
                                                        align = 'center',
                                                        useShinyjs(),
                                                        extendShinyjs(text = jsResetCode, functions = 'reset'),
                                                        actionButton(
                                                            inputId = 'submit_form',
                                                            label   = 'Submit')))
                                             )) # End conditional panel --------
                           )
                 )
             )
        )