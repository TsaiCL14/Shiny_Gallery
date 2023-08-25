##### make server 

##### use function ####
source('function/TV_rank_plot.R')
# source('function/TV_Frequency_plotly.R')
source('function/TV_Frequency_Timeinterval_plotly.R')
source('function/TV_choose_plotly.R')
source('function/TV_bubble_plotly.R')


###### 準備資料  ########

z <- readr::read_csv('data/Final_report_data.csv',show_col_types = F)
# remove_z <- readr::read_csv(file = 'data/Final_report_remove.csv',show_col_types = F)
# z <- z %>% 
#   filter(!客戶編號 %in% unique(remove_z$mac)) %>% 
#   filter(電視台 <= 412)

# TimeZ <- readr::read_csv('data/Final_Report_Time.csv',show_col_types = F)
# TimeZ <- readr::read_csv('data/TimeSeries_06_UTC_remove_under412.csv',show_col_types = F)
# Seat <- which(TimeZ[,-1] > 300,arr.ind = T)
# Problem_names <- names(TimeZ)[-1][unique(Seat[,2])]

tr_all <- arules::read.transactions('data/market_basket_transactions.csv', format = 'basket', sep=',')
tr_Rnews <- arules::read.transactions('data/market_basket_transactions_remove_news.csv', format = 'basket', sep=',')
tr_RnewsMovie <- arules::read.transactions('data/market_basket_transactions_remove_news_movie.csv', format = 'basket', sep=',')

####### server output ##########

# Program_Frequency 電視台排名及平均觀看時間
output$Program_Frequency <- renderPlot({
  TV_rank_plot(z,Choose = input$Choose_type)
})

# Program_scatter_bubble 電視台依 總時間/總觀看次數/平均觀看
output$Program_scatter_bubble <- plotly::renderPlotly({
  TV_bubble_plotly(z)
  # # 設定 plotlyProxy 對象
  # proxy <- plotly::plotlyProxy("bubble_plot")
  # 
  # # 註冊點擊事件
  # plotly::event_register(proxy, 'plotly_click')
  
})

# observeEvent(plotly::event_data("plotly_click", source = "bubble_plot"), {
#   # 獲取點選的資料點數據
#   # plotly::event_data()
#   click_data <- plotly::event_data("plotly_click", source = "bubble_plot")
#   # print(click_data)
#   # 在這裡處理點選的資料，例如顯示在 Shiny 應用中或執行其他操作
#   # 更新 bubble_text 文本，以顯示點選的資料
#   plotly::updatePlotlyProxy(session, "bubble_plot", text = list(click_data$hovertext))
# })


# TimeSeries_Frequency
output$TimeSeries_Frequency <- plotly::renderPlotly({
  TV_Frequency_TimeInterval_plotly(z)
})

# upload select input
# 製作要挑選的電視台
get_TV <- eventReactive(input$Choose_type,{
  PlotData_Program <- z %>% 
    dplyr::group_by(電視台名稱,電視台) %>% 
    dplyr::summarise(
      Freq = dplyr::n_distinct(觀看時間),
      Avg = mean(觀看時間)/60,
      .groups = 'drop'
    ) %>% 
    arrange(desc(Freq))
  PlotData_Program$useName <- paste0(PlotData_Program$電視台名稱,'(',PlotData_Program$電視台,')')
  PlotData_Program$useName <- reorder(PlotData_Program$useName,PlotData_Program$Freq)
  if(input$Choose_type == '未分類'){
    # PD <- PlotData_Program[c(1:20),]
    PD <- PlotData_Program$useName
  }else if(input$Choose_type == '去除新聞台'){
    # PD <- PlotData_Program[!grepl('新聞|TVBS',PlotData_Program$電視台名稱),][1:20,]
    # PD <- PlotData_Program[!PlotData_Program$電視台 %in% c(49:58),][1:20,]
    PD <- PlotData_Program$useName[!PlotData_Program$電視台 %in% c(49:58)]
  }else if(input$Choose_type == '去除新聞台及電影'){
    # PD <- PlotData_Program[!grepl('新聞|TVBS|電影',PlotData_Program$電視台名稱),][1:20,]
    PD <- PlotData_Program$useName[!PlotData_Program$電視台 %in% c(49:58,61:69)]
  }
  
  return(PD)
})
observeEvent(eventExpr = input$Choose_type,{
  updateSelectInput(session, "Choose_TV",
                    label = "挑選電視台",
                    choices = get_TV(),
                    selected = NULL  # 選擇值的初始狀態，這裡設為 NULL，可以自行修改
  )
})

# TimeSeries_TV_Choose
output$TimeSeries_TV_Choose <- plotly::renderPlotly({
  TV_choose_plotly(z,Choose_TV = input$Choose_TV)
})

# Apriori_all
# output$Apriori_all <- renderDataTable({
#   arules::apriori(tr_all, parameter = list(supp=0.05, conf=0.5,maxlen=4,minlen=1)) %>%
#     arules::inspect() %>% 
#     arrange(desc(support)) %>% 
#     select(lhs,rhs,support,count) %>% 
#     mutate(support = round(support,4)) %>% 
#     DT::datatable(extensions = 'Scroller',
#                   options = list(lengthMenu = c(5,10,30),
#                                  pageLength = 50 ,
#                                  deferRender = TRUE,
#                                  scrollY = 450 ,
#                                  scroller = TRUE,
#                                  scrollX = TRUE ,
#                                  fixedColumns = TRUE
#                   ))
# })
# Apriori_Remove_news
# output$Apriori_Remove_news <- renderDataTable({
#   arules::apriori(tr_Rnews, parameter = list(supp=0.01, conf=0.5,maxlen=4,minlen=1)) %>%
#     arules::inspect() %>% 
#     arrange(desc(support)) %>% 
#     dplyr::select(lhs,rhs,support,count) %>% 
#     DT::datatable(extensions = 'Scroller',
#                   options = list(lengthMenu = c(5,10,30),
#                                  pageLength = 50 ,
#                                  deferRender = TRUE,
#                                  scrollY = 450 ,
#                                  scroller = TRUE,
#                                  scrollX = TRUE ,
#                                  fixedColumns = TRUE
#                   ))
# })

# Apriori_Remove_news_movie
# output$Apriori_Remove_news_movie <- renderDataTable({
#   arules::apriori(tr_RnewsMovie, parameter = list(supp=0.01, conf=0.5,maxlen=4,minlen=1)) %>%
#     arules::inspect() %>% 
#     arrange(desc(support)) %>% 
#     select(lhs,rhs,support,count) %>% 
#     mutate(support = round(support,4)) %>% 
#     DT::datatable(extensions = 'Scroller',
#                   options = list(lengthMenu = c(5,10,30),
#                                  pageLength = 50 ,
#                                  deferRender = TRUE,
#                                  scrollY = 450 ,
#                                  scroller = TRUE,
#                                  scrollX = TRUE ,
#                                  fixedColumns = TRUE
#                   ))
# })