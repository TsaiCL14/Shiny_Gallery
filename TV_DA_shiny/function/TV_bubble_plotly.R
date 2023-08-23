# PD <- PlotData_Program[c(1:20),]
# PD <- PlotData_Program[!grepl('新聞|TVBS',PlotData_Program$電視台名稱),][1:20,]

TV_bubble_plotly <- function(z){
  z$Type <- ifelse(z$電視台 %in% c(49:58),'新聞台',
                   ifelse(z$電視台 %in% c(61:69),'電影','其他'))
  plotData_bubble <- z %>% 
    dplyr::mutate(
      useName = paste0(電視台名稱,'(',電視台,')')
    ) %>% 
    # dplyr::group_by(Type,電視台) %>% 
    dplyr::group_by(Type,useName) %>% 
    dplyr::summarise(
      Frequency = n(),
      Frequency_trans = n()^(1/5),
      Mean = round(mean(觀看時間)/60,2),
      total_time = round((sum(觀看時間)/60/60)^(1/2),2),
      .groups = 'drop'
    ) %>% 
    arrange(desc(Frequency)) %>%
    # mutate(電視台 = factor(電視台, 電視台)) %>% 
    mutate(useName = factor(useName, useName)) %>% 
    select(useName,Frequency,Frequency_trans,Mean,Type,total_time)
  colors <- c('#4AC6B7', '#1972A4', '#965F8A')
  p <- plotly::plot_ly(plotData_bubble, x = ~Frequency_trans, y = ~total_time, color = ~Type, size = ~Mean, colors = colors,
          type = 'scatter', mode = 'markers', sizes = c(min(plotData_bubble$Mean), max(plotData_bubble$Mean)),
          marker = list(symbol = 'circle', sizemode = 'diameter',
                        line = list(width = 1.0, color = '#FFFFFF')),
          text = ~paste('電視台:',useName,
                        # '<br>種類:', Type, 
                        '<br>觀看次數:', Frequency,
                        '<br>總觀看(小時):', total_time ,
                        '<br>平均觀看(分鐘):', Mean )) %>% 
    plotly::layout(title = list(text = '電視台差距', y = 0.98,
                        font = list(size = 20, weight = 'bold', color = 'black')),
           xaxis = list(title = '觀看次數',
                        range = c(0, max(plotData_bubble$Frequency_trans)*1.1), # 自定義刻度標籤
                        ticklen = 5,
                        gridwidth = 2,
                        gridcolor = 'rgb(255, 255, 255)',
                        tickvals = c(seq(2,12,2)),
                        ticktext = seq(2,12,2)^5,
                        titlefont  = list(size = 18)),
           yaxis = list(title = '總觀看時間(小時)',
                        range = c(-45,250), # 自定義刻度標籤
                        ticklen = 5,
                        gridwidth = 2,
                        gridcolor = 'rgb(255, 255, 255)',
                        titlefont  = list(size = 18)),
           paper_bgcolor = 'rgb(243, 243, 243)',
           plot_bgcolor = 'rgb(243, 243, 243)',
           showlegend = T) #%>% 
    # style(text = ~gsub("\\([^)]+\\)\\s*", "", .))
  
  return(p)
}
