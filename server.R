shinyServer(function(input, output, session) {
        
        d <- reactive({
                req(input$x)
                req(input$y)
                req(input$z)
                req(input$a)
                req(input$year)
                
                data <- data %>%
                        filter(team == input$x & date >= input$year[1] & date <= input$year[2]) %>%
                        dplyr::select(team, rank, points, date) %>%
                        mutate(team = paste("1)", team)) %>%
                        bind_rows(data %>%
                                  filter(team == input$y & date >= input$year[1] & date <= input$year[2]) %>%
                                  dplyr::select(team, rank, points, date) %>%
                                  mutate(team = paste("2)", team))

                        ) %>%
                        bind_rows(data %>%
                                  filter(team == input$z & date >= input$year[1] & date <= input$year[2]) %>%
                                  dplyr::select(team, rank, points, date) %>%
                                  mutate(team = paste("3)", team))
                        ) %>% 
                        bind_rows(data %>%
                                  filter(team == input$a & date >= input$year[1] & date <= input$year[2]) %>%
                                  dplyr::select(team, rank, points, date) %>%
                                  mutate(team = paste("4)", team))
                        )

                data
        })

        observeEvent(input$y,{
                if (input$y != input$x){
                        shinyjs::enable(id = "z")
                }
        })

        observeEvent(input$z,{
                if ((input$y != input$x) && (input$z != input$x)) {
                        shinyjs::enable(id = "a")
                }
        })

        output$plot <- renderPlotly({
                q <- d()
                
                if( (max(q$rank)-min(q$rank)) <= 30 ) {b <- 1} 
                else {b <- round((max(q$rank) - min(q$rank))/30, 0) }
                
                q$date <- as.yearmon(q$date)
                q$Details <- paste('<br>Team:', q$team, '<br>Rank: ', q$rank, '<br>Points:', q$points, '<br>Date: ', q$date)
                
                p <- ggplot(data = q, aes(y = rank, x = date, colour = team, label = Details), stat = "density") +
                     geom_line(linewidth=0.5) + 
                     geom_point(size=1.2)
                
                p <- p + 
                    scale_y_continuous(trans = "reverse", limits = c(max(q$rank) + 1, 0), 
                                       breaks = seq(max(q$rank), 1, -b), expand = c(0.01,0.01)) +
                        
                    scale_x_continuous(breaks = seq(min(year(q$date)), max(year(q$date)), 1), 
                                       limits = c(min(year(q$date)), max(year(q$date)) + 1), 
                                       expand = c(0,0)) +
                    theme_bw() +
                    labs(x = "Year", y = "FIFA Ranking", caption = "@DatoFutbol_cl",
                         col = "Team:", 
                         subtitle = paste0("Historical men's FIFA ranking\n\n",
                                           "From ", as.yearmon(input$year[1], "%B%Y"), " to ", as.yearmon(input$year[2], "%B%Y"))) +
                    scale_colour_brewer(palette = "Set1") +
                    theme(legend.position = "bottom", 
                          legend.direction = "horizontal",

                          axis.text.x = element_text(angle = 90, size = 8),
                          axis.title.x = element_text(size = 14),
                          axis.title.y = element_text(size = 12),
                          plot.margin = margin(0.5, 0.1, 0.4, 0.2, "cm")) 
                
                p <- suppressWarnings(print(ggplotly(p, tooltip="label") %>% 
                        layout(legend = list(orientation = "h", x = 0, y = 1.1),
                               margin = list(l = 80, r = 15, b = 80, t = 10))))
        })
        
        output$down <- downloadHandler(
                filename = "image.png",
                content = function(file) {
                        ggsave(file, width = 12, height = 6)
                }
        )  
})
