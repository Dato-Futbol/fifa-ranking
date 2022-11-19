teams <- data %>% arrange(Team) %>% distinct(Team)

dateRangeInput2 <- function(inputId, label, minview = "days", maxview = "decades", ...) {
        d <- shiny::dateRangeInput(inputId, label, ...)
        d$children[[2L]]$children[[1]]$attribs[["data-date-min-view-mode"]] <- minview
        d$children[[2L]]$children[[3]]$attribs[["data-date-min-view-mode"]] <- minview
        d$children[[2L]]$children[[1]]$attribs[["data-date-max-view-mode"]] <- maxview
        d$children[[2L]]$children[[3]]$attribs[["data-date-max-view-mode"]] <- maxview
        d
}

shinyUI(
        dashboardPage(skin = "black",
                dashboardHeader(title = "Historical FIFA Ranking", titleWidth = 250), #disable = T),
                dashboardSidebar(width = 250,
                        dateRangeInput2('year',
                                       label = 'Date range:',
                                       start = "2010-01-01", end = "2022-10-01",
                                       min = min(data$Date), max = max(data$Date),
                                       separator = " - ", format = "mm/yyyy",
                                       startview = 'year', language = 'en-GB',
                                       minview = "months", maxview = "years"
                        ),
                        selectInput('x', 'Team 1 (red)', teams$Team, selected = "Qatar"),
                        div(style = "margin-top:-18px"),
                        selectInput('y', 'Team 2 (blue)', teams$Team, selected = "Ecuador"),
                        div(style = "margin-top:-18px"),
                        shinyjs::disabled(selectInput('z', 'Team 3 (green)', teams$Team, selected = "Senegal")),
                        div(style = "margin-top:-18px"),
                        shinyjs::disabled(selectInput('a', 'Team 4 (purple)', teams$Team, selected = "Netherlands")),
                        div(style = "margin-top: 36px"),
                        tags$style(type="text/css", "#down {color: black; margin-left: 60px}"),
                        downloadButton('down', 'Download image', class="butt1")
                ),
        
                dashboardBody(
                        shinyjs::useShinyjs(),
                        fluidRow(
                                column(12, align="center", box(plotlyOutput('plot', height = "550px", width = "98%"), 
                                                               width = 16, height = "580px", background = "black"))
                        )
                )
        )
                        
        # fluidPage(
        #         titlePanel("Historical FIFA Ranking"),
        #         fluidRow(
        #                 column(3,
        #                         selectInput('x', 'Team 1', unique(data$Team), selected = "Chile")
        #                 ),
        #                 column(3, offset = 1,
        #                         selectInput('y', 'Team 2', unique(data$Team), selected = "Chile")
        #                 ),
        #                 column(3, offset= 1,
        #                         selectInput('z', 'Team 3', unique(data$Team), selected = "Chile")
        #                 )
        #         ),
        # 
        #         mainPanel(
        #                 sliderInput('year', label = "Starting year", 
        #                         min = 1993, max = max(data$ye), value = 2010,
        #                         pre="Year: "),
        #                 plotlyOutput('plot'),
        #                 width=14
        #         )
        # )
)
