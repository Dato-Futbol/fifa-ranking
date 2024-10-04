library(readr)
library(shiny)
library(ggplot2)
library(plotly)
library(lubridate)
library(zoo)
library(dplyr)
library(shinydashboard)
library(shinyjs)

options(shiny.usecairo = TRUE)

data_path = "https://raw.githubusercontent.com/Dato-Futbol/fifa-ranking/refs/heads/master/ranking_fifa_historical.csv"

data = read_csv(data_path, show_col_types = FALSE) %>% 
       filter(!is.na(total_points)) %>%
       mutate(team = ifelse(team == "Curaçao", "Curacao", team),
              team = ifelse(team == "Hong Kong, China", "Hong Kong", team),
              team = ifelse(team == "Czech Republic", "Czechia", team),
              team = ifelse(team == "Turkey", "Türkiye", team)) %>% 
       group_by(date) %>% 
       mutate(rank = rank(-total_points)) %>% 
       rename("points" = "total_points")
