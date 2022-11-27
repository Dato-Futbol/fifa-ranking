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

data <- readRDS("FIFA_ranking.rds") %>%
  mutate(Date = ymd(paste0(Date, "-01")))
