###### Ratings_ana ui



###### UI ###############
fluidPage(
  ## 第一欄 暫時先不要製作側邊
  column(2,
         style = 'background-color: #E8E8E8',
         div(style = 'display: inline-block;vertical-align:top;text-align:center; width: 100%;',
             strong(""),
         ),# close div
         br(),
         ## input 挑選資料夾,v2/v3/v4
         div(style = 'display: inline-block;vertical-align:top;text-align:left; width: 100%;',
             radioButtons('Choose_type',
                          '電視台排名_分類',
                          c('未分類','去除新聞台','去除新聞台及電影')),
             selectInput('Choose_TV',
                         '挑選電視台',
                         c('TVBS新聞台(55)'))
             )# ,
         # br(),
         # br(),
         # textOutput('bubble_text')
  ), # close column 
  ## 第二欄
  column(10,
         navbarPage('',
                    navbarMenu('電視台',
                               tabPanel('排名及平均觀看時間',
                                        plotOutput('Program_Frequency',height = "600px")),
                               tabPanel('電視台分類差距',
                                        plotly::plotlyOutput('Program_scatter_bubble',height = "600px"))
                           ),# close navbarMenu
                    navbarMenu('時間數列圖',
                               tabPanel('觀看次數',
                                        plotly::plotlyOutput('TimeSeries_Frequency',height = "600px")),
                               tabPanel('電視台選擇',
                                        plotly::plotlyOutput('TimeSeries_TV_Choose',height = "600px"))
                           )#,# close navbarMenu 
                    # navbarMenu('關聯分析',
                    #            tabPanel('未分類',
                    #                     DTOutput('Apriori_all')),
                    #            tabPanel('去除新聞台',
                    #                     DTOutput('Apriori_Remove_news')),
                    #            tabPanel('去除新聞台及電影',
                    #                     DTOutput('Apriori_Remove_news_movie'))
                    #   
                    # )# close navbarMenu
                    
                    
         )# navbarPage 
         
  )# close column
)# closee fluidPage
