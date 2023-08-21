#### 製作一個觀察資料用的 shiny
## 主要針對資 06/02-07的資料

library(shiny)
library(ggplot2)
library(plotly)
library(dplyr)
library(tidyr)
library(ggpubr) 
library(plotly)
##################### Define UI for application that draws a histogram

ui <- fluidPage(
  shinyUI(
    # 主頁
    navbarPage(title = "Viz", # 首頁左上角的字
               tabPanel(title = 'Ratings_ana',
                        source('ui/ui_Ratings_ana.R',local = TRUE)$value
               ), # close tabPanel
               tabPanel(title = 'test_code',
                        HTML('<pre class="shiny-text-output noplaceholder" id="notes-uiNoteContents" aria-live="polite">my <span style="color: red;">marked up</span> text</pre>'),
                        tags$pre(
                          class = "shiny-text-output noplaceholder", 
                          uiOutput("test", inline = TRUE)
                        ),
                        br(),
                        p("p creates a paragraph of text."),
                        p("A new p() command starts a new paragraph. Supply a style attribute to change the format of the entire paragraph.", style = "font-family: 'times'; font-si16pt"),
                        strong("strong() makes bold text."),
                        em("em() creates italicized (i.e, emphasized) text."),
                        br(),
                        code("code displays your text similar to computer code"),
                        div("div creates segments of text with a similar style. This division of text is all blue because I passed the argument 'style = color:blue' to div", style = "color:blue"),
                        br(),
                        p("span does the same thing as div, but it works with",
                          span("groups of words", style = "color:blue"),
                          "that appear inside a paragraph.")
               )
               
    ) # navbarPage
  ) # shinyUI
) # fluiPage

##################### Define server logic required to draw a histogram
server <- function(input, output, session) {
  source('server/server_Ratings_ana.R',local = TRUE)$value
  output$test <- renderUI({
    HTML('my <span style="color: red;">marked up</span> text')
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)