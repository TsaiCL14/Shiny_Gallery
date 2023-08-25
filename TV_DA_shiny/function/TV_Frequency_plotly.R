
TV_Frequency_plotly <- function(TimeZ){
  # Seat <- which(TimeZ[,-1] > 300,arr.ind = T)
  # Problem_names <- names(TimeZ)[-1][unique(Seat[,2])]
  # PlotData_over0 <- TimeZ %>% 
  #   as_tibble() %>% 
  #   filter(Date > as.POSIXct('2023-06-01 23:00:00',tz = 'UTC')) %>% 
  #   filter(Date < as.POSIXct('2023-06-08 00:00:00',tz = 'UTC')) %>% 
  #   tidyr::pivot_longer(!Date,names_to = 'mac', values_to = 'druation') %>% 
  #   filter(!(mac %in% Problem_names)) %>%
  #   filter(druation > 0)
  
  p <- TimeZ %>%
    # dplyr::mutate(Date = Date - 8*60*60) %>% 
    dplyr::group_by(Date) %>% 
    dplyr::summarise(
      Freq = dplyr::n_distinct(mac)
    ) %>% 
    plotly::plot_ly( x = ~Date) %>% 
    plotly::add_lines(y = ~Freq, name = "") %>% 
    plotly::layout(
      title = list(text = '觀看次數時間數列圖', y = 0.98,
                   font = list(size = 20, weight = 'bold', color = 'black')),
      xaxis = list(
        title = '日期',
        ticklen = 0,
        gridwidth = 2,
        rangeslider = list(type = "date")
      ),
      yaxis = list(title = '次數',
                   ticklen = 0,
                   gridwidth = 2,
                   # gridcolor = 'rgb(255, 255, 255)',
                   titlefont  = list(size = 18)),
      paper_bgcolor = 'rgb(243, 243, 243)',
      plot_bgcolor = 'rgb(243, 243, 243)')
  return(p)
}
