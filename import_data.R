# Purpose: import zip file with data, do some data transformations and convert to rds input file for Shiny app

# Data source: https://www.kaggle.com/datasets/cashncarry/fifaworldranking
# Instructions: download this csv file, create a sub directory called data, put the zip file in there, and run this R file

data <- read.table(unz("data/fifa_ranking-2022-10-06.csv.zip", "fifa_ranking-2022-10-06.csv"), header=T, quote="\"", sep=",") %>% 
  mutate(Date = substr(rank_date, 1, 7)) %>% 
  select(Team = country_full, Rank = rank, Points = total_points, Date = Date) %>% 
  saveRDS("FIFA_ranking.rds")
