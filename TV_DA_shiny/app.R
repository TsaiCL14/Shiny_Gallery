#### 製作一個觀察資料用的 shiny
## 主要針對資 06/02-07的資料

library(shiny)
library(DT)
library(dplyr)
library(tidyr)
library(ggplot2)
# library(ggpubr) 
# library(plotly)
# library(arules)
library(plyr)
##################### Define UI for application that draws a histogram

ui <- fluidPage(
  shinyUI(
    # 主頁
    navbarPage(title = "Viz", # 首頁左上角的字
               tabPanel(title = 'Ratings_ana',
                        source('ui/ui_Ratings_ana.R',local = TRUE)$value
               ) # close tabPanel
               
               
    ) # navbarPage
  ) # shinyUI
) # fluiPage

##################### Define server logic required to draw a histogram
server <- function(input, output, session) {
  source('server/server_Ratings_ana.R',local = TRUE)$value
 
  
}

# Run the application 
shinyApp(ui = ui, server = server)