# Historical men's FIFA ranking R Shiny app

This repository contains the codes of a R Shiny app where you can visualize the men's FIFA ranking timeline of different nations.

[Link to R Shiny app](https://bustami.shinyapps.io/ranking_fifa/) (last update: April 2024). This version still considers some extended features done by [Piet Stam](https://github.com/pjastam) in a previous pull request.

* The data (from December 1992 to April 2024) was scraped from the official [FIFA website](https://www.fifa.com/fifa-world-ranking/men). Data is in the "ranking_fifa_historical.csv" file.

* The app has a date range selector and 4 nation selectors. It is possible to visualize from 1 to 4 nations at the same time (if you prefer the 2nd, 3rd & 4th teams could be set as "None"). The default is the selection of countries in group A of the 2022 world cup.

* Downloading graphs option as PNG file. 

Output example:

![](image.png)
