# dashboardHeader ==============================================================
header <- dashboardHeader(
    title      = 'ESCA Dashboard',
    titleWidth = 200
)

# dashboardSidebar =============================================================
sidebar <- dashboardSidebar(
    collapsed = FALSE,
    width     = 200,
    sidebarMenu(
        id = 'tabs',
        menuItem(
            text    = 'Explorer',
            tabName = 'explorer',
            icon    = icon('search')
        ),
        menuItem(
            text    = 'Reporter',
            tabName = 'reporter',
            icon    = icon('pencil')
        )
    )
)

# dashboardBody tabs ===========================================================

tab_explorer <- tabItem(
    tabName = 'explorer',
    fluidPage(
        titlePanel(
            tags$div(
                'Explorer',
                tags$span(actionButton('load_explorer_about', 'About'),
                          style = 'position:absolute;right:0.5em;')
                )),
        tags$br(),
        fluidRow(
            box(
                title       = 'Spatial Data', 
                width       = 12,
                collapsible = TRUE,
                collapsed   = FALSE, 
                height      = '100%',
                tags$style(
                    type = 'text/css',
                    '#map {height: calc(100vh - 100px) !important;}'),
                withSpinner(
                    leafletOutput('map'),
                    type    = 4
                ))),
        fluidRow(
            box(
                title       = 'Tabular Data',
                width       = 12,
                collapsible = TRUE,
                collapsed   = TRUE,
                height      = '100%',
                withSpinner(
                    dataTableOutput('table'),
                    type    = 4
                )))
    )
)

tab_reporter <- tabItem(
    tabName = 'reporter',
    fluidPage(
        titlePanel(
            tags$div(
                'Reporter',
                tags$span(actionButton('load_reporter_about', 'About'),
                          style = 'position:absolute;right:0.5em;')
        )),
        tags$br(),
        fluidRow(
            box(
                title       = 'Spatial Indicent Reporter',
                width       = 12,
                collapsible = TRUE,
                collapsed   = TRUE,
                height      = '100%',
                tags$p("To add geotagged report of an incident, first check the 'Add record?' box and proceed to complete the form. If you are unsure about the latitute and longitude of the location, select it on the map to autopopulate the 'Incident location:' field. Once ready, proceed to 'Submit' the data."),
                checkboxInput(inputId = 'show_hide',
                              label   = 'Add record?',
                              value   = FALSE),
                conditionalPanel(
                    condition = 'input.show_hide == true',
                    wellPanel(id = 'controls',
                              fluidRow(
                                  column(width = 6,
                                         textInput(inputId     = 'location',
                                                   label       = 'Incident location:',
                                                   placeholder = 'Location (e.g., 36.607, -121.782)',
                                                   width       = '100%')),
                                  column(width = 6,
                                         textInput(inputId     = 'notes',
                                                   label       = 'Notes:',
                                                   width       = '100%',
                                                   placeholder = 'Add notes of find.'))
                                  ),
                              fluidRow(
                                  column(width = 6,
                                         selectInput(input   = "type",
                                                     label   = "Choose a type:",
                                                     width   = "100%",
                                                     choices = c("Development",
                                                                 "Gates",
                                                                 "Fence",
                                                                 "Trespass", 
                                                                 "Signage",
                                                                 "Soil disturbance"))),
                                  column(width = 6,
                                         selectInput(input   = 'author',
                                                     label   = 'Choose a reporter:',
                                                     width   = '100%',
                                                     choices = c('Abraam', 'Chris', 'Lesley')))
                                  ),
                              fluidRow(
                                  column(width = 12, align = 'center', 
                                         useShinyjs(),
                                         extendShinyjs(text = jsResetCode, functions = 'reset'),
                                         actionButton(
                                             inputId = 'submit_form',
                                             label   = 'Submit')))
                    )),
                tabsetPanel(type = "tabs",
                            tabPanel(title = "Map", 
                                     withSpinner(leafletOutput('reporter_map'),
                                                                type = 4)),
                            tabPanel(title = "Table",
                                     withSpinner(DT::dataTableOutput('reporter_table',
                                                                     width  = '100%',
                                                                     height = '20%'),
                                                 type = 4))
                            )
            )
        ),
        fluidRow(
            box(
                title       = 'Montly Reporting',
                width       = 12,
                collapsible = TRUE,
                collapsed   = TRUE,
                height      = '100%',
                tags$p(""),
                fluidRow(
                    column(width = 6,
                           selectInput(inputId = "monthly_site",
                                       label   = "Which MRA?",
                                       choices = c("Campus North",
                                                   "CSUMB",
                                                   "Del Rey Oaks",
                                                   "Interim Action Ranges",
                                                   "Future East Garrison",
                                                   "Monterey",
                                                   "MOUT",
                                                   "Laguna Seca Parking Area",
                                                   "Parker Flats",
                                                   "Seaside"))),
                    column(width = 6,
                           selectInput(input   = 'monthly_author',
                                       label   = 'Choose a reporter:',
                                       width   = '100%',
                                       choices = c('Abraam', 'Chris', 'Lesley')))
                ),
                tags$br(),
                tags$h3("Changes in:"),
                fluidRow(
                    column(width = 4, 
                           checkboxGroupInput(inputId = 'changes_residence',
                                        label   = 'Land use - residential use restriction, habitat',
                                        choices = c("Yes", "No"),
                                        selected = "No")),
                    column(width = 8,
                           textInput(inputId     = 'changes_residence_notes',
                                     label       = 'Any notes on land use changes?',
                                     width       = '100%',
                                     placeholder = 'Add notes...'))),
                fluidRow(
                    column(width = 4,
                           checkboxGroupInput(inputId = 'changes_conditions',
                                        label   = 'Site conditions',
                                        choices = c("Yes", "No"),
                                        selected = "No")),
                    column(width = 8,
                           textInput(inputId     = 'changes_conditions_notes',
                                     label       = 'Any notes on site condition changes?',
                                     width       = '100%',
                                     placeholder = 'Add notes...'))),
                fluidRow(
                    column(width = 4,
                           checkboxGroupInput(inputId = 'changes_ownership',
                                        label   = 'Ownership',
                                        choices = c("Yes", "No"),
                                        selected = "No")),
                    column(width = 8,
                           textInput(inputId     = 'changes_ownership_notes',
                                     label       = 'Any notes on onwership changes?',
                                     width       = '100%',
                                     placeholder = 'Add notes...'))),
                fluidRow(
                    column(width = 4,
                           checkboxGroupInput(inputId = 'changes_occupancy',
                                        label   = 'Occupancy',
                                        choices = c("Yes", "No"),
                                        selected = "No")),
                    column(width = 8,
                           textInput(inputId     = 'changes_occupancy_notes',
                                     label       = 'Any notes on occupancy changes?',
                                     width       = '100%',
                                     placeholder = 'Add notes...'))),
                tags$br(),
                tags$h3("Additional response/remedy modification compliance"),
                fluidRow(column(width = 12,
                       textInput(inputId     = 'monthly_notes',
                                 label       = 'Notes:',
                                 width       = '100%',
                                 placeholder = 'Add notes...'))),
                tags$br(),
                tags$h3("LUC conformity/non-conformity"),
                fluidRow(
                    column(width = 4,
                           checkboxGroupInput(inputId = 'luc_residential',
                                        label   = 'Residential use restrictions',
                                        choices = c("Yes", "No"),
                                        selected = "No")),
                    column(width = 8,
                           textInput(inputId     = 'luc_residential_notes',
                                     label       = 'Any notes on residential use restrictions?',
                                     width       = '100%',
                                     placeholder = 'Add notes...'))),
                fluidRow(
                    column(width = 4,
                           checkboxGroupInput(inputId = 'luc_mec_training',
                                        label   = 'Munitions recognition safety training',
                                        choices = c("Yes", "No"),
                                        selected = "No")),
                    column(width = 8,
                           textInput(inputId     = 'luc_mec_training_notes',
                                     label       = 'Any notes on munitions recognition safety training?',
                                     width       = '100%',
                                     placeholder = 'Add notes...'))),
                fluidRow(
                    column(width = 4,
                           checkboxGroupInput(inputId = 'luc_construction_support',
                                        label   = 'Construction support',
                                        choices = c("Yes", "No"),
                                        selected = "No")),
                    column(width = 8,
                           textInput(inputId     = 'luc_construction_support_notes',
                                     label       = 'Any notes on construction support?',
                                     width       = '100%',
                                     placeholder = 'Add notes...'))),
                fluidRow(
                    column(width = 4,
                           checkboxGroupInput(inputId = 'luc_procedures',
                                        label   = 'Procedures and document requirements',
                                        choices = c("Yes", "No"),
                                        selected = "No")),
                    column(width = 8,
                           textInput(inputId     = 'luc_procedures_notes',
                                     label       = 'Any notes on procedures and document requirements?',
                                     width       = '100%',
                                     placeholder = 'Add notes...'))),
                fluidRow(
                    column(width = 4,
                           checkboxGroupInput(inputId = 'luc_signage',
                                        label   = 'Signage',
                                        choices = c("Yes", "No"),
                                        selected = "No")),
                    column(width = 8,
                           textInput(inputId     = 'luc_signage_notes',
                                     label       = 'Any notes on signage?',
                                     width       = '100%',
                                     placeholder = 'Add notes...'))),
                tags$hr(),
                column(width = 12, align = 'center',
                                useShinyjs(),
                                extendShinyjs(text = jsResetCode,
                                              functions = 'reset'),
                                actionButton(
                                    inputId = 'submit_monthly_form',
                                    label   = 'Submit')
                                )
            )
        ),
        fluidRow(
            box(title       = 'Bi-Annual Walking Site Inspections',
                width       = 12,
                collapsible = TRUE,
                collapsed   = TRUE,
                height      = '100%',
                fluidRow(
                    column(width = 6,
                           textInput(inputId     = "bi_apn",
                                     label       = "Which MRA?",
                                     width       = '100%',
                                     placeholder = 'Add APNs...')),
                    column(width = 6,
                           textInput(input   = 'bi_coe', label   = 'COE?',
                                     width   = '100%',
                                     placeholder = 'Add COEs...'))
                ),
                fluidRow(
                    column(width = 12,
                           selectInput(input   = 'bi_author',
                                       label   = 'Choose a reporter:',
                                       width   = '100%',
                                       choices = c('Abraam', 'Chris', 'Lesley')))
                ),
                tags$br(),
                tags$h3("Discussion Points"),
                tags$p("Meet with the jurisdictions or property owner for joint inspection and discuss the following:"),
                tags$h4("Property Transfers"),
                fluidRow(
                    column(width = 4,
                           checkboxGroupInput(inputId = 'bi_a1',
                                              label   = 'Upcoming property transfers',
                                              choices = c("Yes", "No"),
                                              selected = "No")),
                    column(width = 8,
                           textInput(inputId     = 'bi_a1_notes',
                                     label       = 'Any notes on upcoming property transfers?',
                                     width       = '100%',
                                     placeholder = 'Add notes...'))
                    ),
                fluidRow(
                    column(width = 4,
                           checkboxGroupInput(inputId = 'bi_a2',
                                              label   = 'Notice of planned property conveyance',
                                              choices = c("Yes", "No"),
                                              selected = "No")),
                    column(width = 8,
                           textInput(inputId     = 'bi_a2_notes',
                                     label       = 'Any notes on notice of planned property conveyance?',
                                     width       = '100%',
                                     placeholder = 'Add notes...'))
                ),
                fluidRow(
                    column(width = 4,
                           checkboxGroupInput(inputId = 'bi_a3',
                                              label   = 'Past years property transfers',
                                              choices = c("Yes", "No"),
                                              selected = "No")),
                    column(width = 8,
                           textInput(inputId     = 'bi_a3_notes',
                                     label       = 'Any notes on past years property transfers?',
                                     width       = '100%',
                                     placeholder = 'Add notes...'))
                ),
                tags$h4("Upcoming Construction"),
                fluidRow(
                    column(width = 4,
                           checkboxGroupInput(inputId = 'bi_b1',
                                              label   = 'Jurisdiction/owners construction support requirement coordination',
                                              choices = c("Yes", "No"),
                                              selected = "No")),
                    column(width = 8,
                           textInput(inputId     = 'bi_b1_notes',
                                     label       = 'Any notes on jurisdiction/owners construction support requirement coordination?',
                                     width       = '100%',
                                     placeholder = 'Add notes...'))
                ),
                fluidRow(
                    column(width = 4,
                           checkboxGroupInput(inputId = 'bi_b2',
                                              label   = 'Jurisdiction/owners construction support implementation and enforcement',
                                              choices = c("Yes", "No"),
                                              selected = "No")),
                    column(width = 8,
                           textInput(inputId     = 'bi_b2_notes',
                                     label       = 'Any notes on jurisdiction/owners construction support implementation and enforcement',
                                     width       = '100%',
                                     placeholder = 'Add notes...'))
                ),
                fluidRow(
                    column(width = 4,
                           checkboxGroupInput(inputId = 'bi_b3',
                                              label   = 'Digging and excavation ordinance',
                                              choices = c("Yes", "No"),
                                              selected = "No")),
                    column(width = 8,
                           textInput(inputId     = 'bi_b3_notes',
                                     label       = 'Any notes on digging and excavation ordinance?',
                                     width       = '100%',
                                     placeholder = 'Add notes...')),
                    column(width = 12,
                           checkboxGroupInput(inputId = 'bi_b3.1',
                                              label   = 'Does it require a qualified UXO construction support contractor?',
                                              choices = c("Yes", "No"),
                                              selected = "No")),
                    column(width = 12,
                           checkboxGroupInput(inputId = 'bi_b3.2',
                                              label   = 'Does it require a construction support plan?',
                                              choices = c("Yes", "No"),
                                              selected = "No")),
                    column(width = 12,
                           checkboxGroupInput(inputId = 'bi_b3.3',
                                              label   = 'Are metal detectors prohibited?',
                                              choices = c("Yes", "No"),
                                              selected = "No")),
                ),
                tags$h4("Current Projects Construction Support"),
                fluidRow(
                    column(width = 4,
                           checkboxGroupInput(inputId = 'bi_c1',
                                              label   = 'MEC-related data identified during construction support',
                                              choices = c("Yes", "No"),
                                              selected = "No")),
                    column(width = 8,
                           textInput(inputId     = 'bi_c1_notes',
                                     label       = 'Any notes on MEC-related data identified during construction support?',
                                     width       = '100%',
                                     placeholder = 'Add notes...'))
                ),
                fluidRow(
                    column(width = 4,
                           checkboxGroupInput(inputId = 'bi_c2',
                                              label   = 'MEC recognition and safety training',
                                              choices = c("Yes", "No"),
                                              selected = "No")),
                    column(width = 8,
                           textInput(inputId     = 'bi_c2_notes',
                                     label       = 'Any notes on MEC recognition and safety training?',
                                     width       = '100%',
                                     placeholder = 'Add notes...'))
                ),
                fluidRow(
                    column(width = 4,
                           checkboxGroupInput(inputId = 'bi_c3',
                                              label   = 'MEC construction support',
                                              choices = c("Yes", "No"),
                                              selected = "No")),
                    column(width = 8,
                           textInput(inputId     = 'bi_c3_notes',
                                     label       = 'Any notes on MEC construction support?',
                                     width       = '100%',
                                     placeholder = 'Add notes...'))
                ),
                fluidRow(
                    column(width = 4,
                           checkboxGroupInput(inputId = 'bi_c4',
                                              label   = 'MEC finds during construction',
                                              choices = c("Yes", "No"),
                                              selected = "No")),
                    column(width = 8,
                           textInput(inputId     = 'bi_c4_notes',
                                     label       = 'Any notes on MEC finds during construction?',
                                     width       = '100%',
                                     placeholder = 'Add notes...'))
                ),
                fluidRow(
                    column(width = 4,
                           checkboxGroupInput(inputId = 'bi_c5',
                                              label   = 'Additional MEC investigations/actions',
                                              choices = c("Yes", "No"),
                                              selected = "No")),
                    column(width = 8,
                           textInput(inputId     = 'bi_c5_notes',
                                     label       = 'Any notes on additional MEC investigations/actions?',
                                     width       = '100%',
                                     placeholder = 'Add notes...'))
                ),
                tags$br(),
                tags$h3("Inspection Points"),
                tags$p("Walk the property with the jurisdiction or property owner and inspect for:"),
                tags$h4("Changes in:"),
                fluidRow(
                    column(width = 4,
                           checkboxGroupInput(inputId = 'bi_d1',
                                              label   = 'Land use - residential use restriction, habitat',
                                              choices = c("Yes", "No"),
                                              selected = "No")),
                    column(width = 8,
                           textInput(inputId     = 'bi_d1_notes',
                                     label       = 'Any notes on changes in land use?',
                                     width       = '100%',
                                     placeholder = 'Add notes...'))
                ),
                fluidRow(
                    column(width = 4,
                           checkboxGroupInput(inputId = 'bi_d2',
                                              label   = 'Site conditions',
                                              choices = c("Yes", "No"),
                                              selected = "No")),
                    column(width = 8,
                           textInput(inputId     = 'bi_d2_notes',
                                     label       = 'Any notes on changes in site conditions?',
                                     width       = '100%',
                                     placeholder = 'Add notes...'))
                ),
                fluidRow(
                    column(width = 4,
                           checkboxGroupInput(inputId = 'bi_d3',
                                              label   = 'Ownership',
                                              choices = c("Yes", "No"),
                                              selected = "No")),
                    column(width = 8,
                           textInput(inputId     = 'bi_d3_notes',
                                     label       = 'Any notes on changes in ownership?',
                                     width       = '100%',
                                     placeholder = 'Add notes...'))
                ),
                fluidRow(
                    column(width = 4,
                           checkboxGroupInput(inputId = 'bi_d4',
                                              label   = 'Occupancy',
                                              choices = c("Yes", "No"),
                                              selected = "No")),
                    column(width = 8,
                           textInput(inputId     = 'bi_d4_notes',
                                     label       = 'Any notes on changes in occupancy?',
                                     width       = '100%',
                                     placeholder = 'Add notes...'))
                ),
                fluidRow(
                    column(width = 12,
                           textInput(inputId     = 'bi_e1',
                                     label       = 'Additional response remedy modification compliance:',
                                     width       = '100%',
                                     placeholder = 'Add notes...')) 
                ),
                tags$h4("LUC conformity/non-conformity"),
                fluidRow(
                    column(width = 4,
                           checkboxGroupInput(inputId = 'bi_f1',
                                              label   = 'Residential use restrictions',
                                              choices = c("Yes", "No"),
                                              selected = "No")),
                    column(width = 8,
                           textInput(inputId     = 'bi_f1_notes',
                                     label       = 'Any notes on residential use restrictions?',
                                     width       = '100%',
                                     placeholder = 'Add notes...'))
                ),
                fluidRow(
                    column(width = 4,
                           checkboxGroupInput(inputId = 'bi_f2',
                                              label   = 'Muntions recognition safety training',
                                              choices = c("Yes", "No"),
                                              selected = "No")),
                    column(width = 8,
                           textInput(inputId     = 'bi_f2_notes',
                                     label       = 'Any notes on munitions recognition safety training?',
                                     width       = '100%',
                                     placeholder = 'Add notes...'))
                ),
                fluidRow(
                    column(width = 4,
                           checkboxGroupInput(inputId = 'bi_f3',
                                              label   = 'Construction support',
                                              choices = c("Yes", "No"),
                                              selected = "No")),
                    column(width = 8,
                           textInput(inputId     = 'bi_f3_notes',
                                     label       = 'Any notes on construction support?',
                                     width       = '100%',
                                     placeholder = 'Add notes...'))
                ),
                fluidRow(
                    column(width = 4,
                           checkboxGroupInput(inputId = 'bi_f4',
                                              label   = 'Procedures and document requirements',
                                              choices = c("Yes", "No"),
                                              selected = "No")),
                    column(width = 8,
                           textInput(inputId     = 'bi_f4_notes',
                                     label       = 'Any notes on procedures and document requirements?',
                                     width       = '100%',
                                     placeholder = 'Add notes...'))
                ),
                fluidRow(
                    column(width = 4,
                           checkboxGroupInput(inputId = 'bi_f5',
                                              label   = 'Signage',
                                              choices = c("Yes", "No"),
                                              selected = "No")),
                    column(width = 8,
                           textInput(inputId     = 'bi_f5_notes',
                                     label       = 'Any notes on signage?',
                                     width       = '100%',
                                     placeholder = 'Add notes...'))
                ),
                tags$h4("Soil Disturbance"),
                fluidRow(
                    column(width = 4,
                           checkboxGroupInput(inputId = 'bi_g1',
                                              label   = 'Erosion',
                                              choices = c("Yes", "No"),
                                              selected = "No")),
                    column(width = 8,
                           textInput(inputId     = 'bi_g1_notes',
                                     label       = 'Any notes on erosion?',
                                     width       = '100%',
                                     placeholder = 'Add notes...'))
                ),
                fluidRow(
                    column(width = 4,
                           checkboxGroupInput(inputId = 'bi_g2',
                                              label   = 'Road/trail grading',
                                              choices = c("Yes", "No"),
                                              selected = "No")),
                    column(width = 8,
                           textInput(inputId     = 'bi_g2_notes',
                                     label       = 'Any notes on road/trail grading?',
                                     width       = '100%',
                                     placeholder = 'Add notes...'))
                ),
                fluidRow(
                    column(width = 4,
                           checkboxGroupInput(inputId = 'bi_g3',
                                              label   = 'Potential new trails',
                                              choices = c("Yes", "No"),
                                              selected = "No")),
                    column(width = 8,
                           textInput(inputId     = 'bi_g3_notes',
                                     label       = 'Any notes on potential new trails?',
                                     width       = '100%',
                                     placeholder = 'Add notes...'))
                ),
                tags$br(),
                tags$h3("Follow Up"),
                tags$p("Please use this section to add any potetial follow up notes:"),
                fluidRow(
                    column(width = 12,
                           textInput(inputId     = 'bi_h1_notes',
                                     label       = 'Any notes to follow up on?',
                                     width       = '100%',
                                     placeholder = 'Add notes...'))
                ),
                tags$hr(),
                column(width = 12, align = 'center',
                       useShinyjs(),
                       extendShinyjs(text = jsResetCode,
                                     functions = 'reset'),
                       actionButton(
                           inputId = 'submit_bimonthly_form',
                           label   = 'Submit')
                )
                )
        )
    )
)

# dashboardPage ================================================================
dashboardPage(
    title   = "SEASIDE ESCA",
    skin    = 'black',
    header  = header,
    sidebar = sidebar,
    body    = dashboardBody(
        includeCSS('extra.css'), 
        tabItems(
            tab_explorer,
            tab_reporter
        )
    )
)