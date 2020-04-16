library(readr)
library(shiny)
library(ggplot2)
library(plotly)
library(lubridate)
library(zoo)
library(dplyr)
options(shiny.usecairo = TRUE)

data <- readRDS("FIFA_ranking.rds") %>%
        mutate(Date = ymd(paste0(Date, "-01")))

shinyServer(function(input, output, session) {
        
        d <- reactive({
                req(input$x)
                req(input$y)
                req(input$z)
                req(input$year)
                
                data <- data %>%
                        filter(Team == input$x & Date >= input$year[1] & Date <= input$year[2]) %>%
                        dplyr::select(Team, Rank, Date) %>%
                        mutate(Team = paste("1)", Team)) %>%
                        bind_rows(data %>%
                                          filter(Team == input$y & Team != input$x & Date >= input$year[1] & Date <= input$year[2]) %>%
                                          dplyr::select(Team, Rank, Date) %>%
                                          mutate(Team = paste("2)", Team))

                        ) %>%
                        bind_rows(data %>%
                                          filter(Team == input$z & Team != input$x & Date >= input$year[1] & Date <= input$year[2]) %>%
                                          dplyr::select(Team, Rank, Date) %>%
                                          mutate(Team = paste("3)", Team))
                        )

                # if(input$x != input$y & input$y != input$z & input$x != input$z){
                #         data <- data %>%
                #                 mutate(Team = ifelse(Team == input$z, paste("3)", Team),
                #                              ifelse(Team == input$y, paste("2)", Team), paste("1)", Team))))
                # }else{
                #         if(input$x != input$y & input$y != input$z){
                #                 data <- data %>%
                #                         mutate(Team = ifelse(Team == input$y, paste("2)", Team), paste("1)", Team)))
                #         }else{
                #                 data <- data %>%
                #                         mutate(Team = paste("1)", Team))
                #         }
                #         
                # }
                
                data
        })

        observeEvent(input$y,{
                if (input$y != input$x){
                        shinyjs::enable(id = "z")
                }
        })
        
        output$plot <- renderPlotly({
                q <- d()
                
                if( (max(q$Rank)-min(q$Rank)) <= 30 ) {b <- 1} 
                else {b <- round((max(q$Rank) - min(q$Rank))/30, 0) }
                
                q$Date <- as.yearmon(q$Date)
                q$Details <- paste('<br>Team:', q$Team, '<br>Rank: ', q$Rank, '<br>Date: ', q$Date)
                
                p <- ggplot(data=q, aes(y = Rank, x = Date, colour = Team, label = Details), stat = "density") +
                        geom_line(size=0.5) + 
                        geom_point(size=1.2)
                
                p <- p + 
                    scale_y_continuous(trans = "reverse", limits = c(max(q$Rank) + 1, 0), 
                                       breaks = seq(max(q$Rank), 1, -b), expand = c(0.01,0.01)) +
                        
                    scale_x_continuous(breaks = seq(min(year(q$Date)), max(year(q$Date)), 1), 
                                       limits = c(min(year(q$Date)), max(year(q$Date)) + 1), 
                                       expand = c(0,0)) +
                    theme_bw() +
                    labs(x="Year", y="FIFA Ranking", caption = "@DatoFutbol_cl", 
                         subtitle = paste0("Historical men FIFA ranking\n\n",
                                           "From ", as.yearmon(input$year[1], "%B%Y"), " to ", as.yearmon(input$year[2], "%B%Y"))) +
                    scale_colour_brewer(palette = "Set1") +
                    theme(legend.position = c(0.5, 1.05), legend.direction = "horizontal",
                          #legend.title = element_blank(),
                          axis.text.x = element_text(angle=90, size=8),
                          axis.title.x = element_text(size=14),
                          axis.title.y = element_text(size=12),
                          plot.margin = margin(0.5, 0.1, 0.4, 0.2, "cm")) 
                
                p <- ggplotly(p, tooltip="label") %>% 
                        layout(legend = list(orientation = "h", x = 0, y = 1.1),
                               margin = list(l = 80, r = 15, b = 80, t = 10))
        })
        
        output$down <- downloadHandler(
                filename = "image.png",
                content = function(file) {
                        ggsave(file, width = 12, height = 6)
                }
        )  
})
