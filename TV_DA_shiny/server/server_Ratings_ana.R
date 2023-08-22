##### make server 

##### use function ####
source('function/TV_rank_plot.R')
source('function/TV_Frequency_plotly.R')
source('function/TV_choose_plotly.R')


###### 準備資料  ########

z <- readr::read_csv('data/Final_report_data.csv',show_col_types = F)
remove_z <- readr::read_csv(file = 'data/Final_report_remove.csv',show_col_types = F)
z <- z %>% 
  filter(!客戶編號 %in% unique(remove_z$mac)) %>% 
  filter(電視台 <= 412)

TimeZ <- readr::read_csv('data/TimeSeries_06_UTC_remove_under412.csv',show_col_types = F)
Seat <- which(TimeZ[,-1] > 300,arr.ind = T)
Problem_names <- names(TimeZ)[-1][unique(Seat[,2])]

tr_all <- read.transactions('data/market_basket_transactions.csv', format = 'basket', sep=',')
tr_Rnews <- read.transactions('data/market_basket_transactions_remove_news.csv', format = 'basket', sep=',')
tr_RnewsMovie <- read.transactions('data/market_basket_transactions_remove_news_movie.csv', format = 'basket', sep=',')

####### server output ##########

# Program_Frequency 電視台排名及平均觀看時間
output$Program_Frequency <- renderPlot({
  TV_rank_plot(z,Choose = input$Choose_type)
})

# TimeSeries_Frequency
output$TimeSeries_Frequency <- renderPlotly({
  TV_Frequency_plotly(TimeZ)
})

# upload select input
# 製作要挑選的電視台
get_TV <- eventReactive(input$Choose_type,{
  PlotData_Program <- z %>% 
    group_by(電視台名稱,電視台) %>% 
    summarise(
      Freq = n(),
      Avg = mean(觀看時間)/60,
      .groups = 'drop'
    ) %>% 
    arrange(desc(Freq))
  PlotData_Program$useName <- paste0(PlotData_Program$電視台名稱,'(',PlotData_Program$電視台,')')
  PlotData_Program$useName <- reorder(PlotData_Program$useName,PlotData_Program$Freq)
  if(input$Choose_type == '未分類'){
    PD <- PlotData_Program$useName[c(1:20)]
  }else if(input$Choose_type == '去除新聞台'){
    PD <- PlotData_Program$useName[!grepl('新聞|TVBS',PlotData_Program$電視台名稱)][1:20]
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
output$TimeSeries_TV_Choose <- renderPlotly({
  TV_choose_plotly(z,Choose_TV = input$Choose_TV)
})

# Apriori_all
output$Apriori_all <- renderDataTable({
  apriori(tr_all, parameter = list(supp=0.01, conf=0.5,maxlen=10,minlen=1)) %>%
    inspect() %>% 
    arrange(desc(support)) %>% 
    DT::datatable(extensions = 'Scroller',
                  # filter = 'top',
                  options = list(lengthMenu = c(5,10,30),
                                 pageLength = 50 ,
                                 deferRender = TRUE,
                                 scrollY = 450 ,
                                 scroller = TRUE,
                                 scrollX = TRUE ,
                                 fixedColumns = TRUE
                  ))
})