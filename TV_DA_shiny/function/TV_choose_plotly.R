TV_choose_plotly <- function(z,Choose_TV){
  p <- z %>% 
    dplyr::mutate(useName = paste0(電視台名稱,'(',電視台,')')) %>% 
    dplyr::mutate(開始時間 = 開始時間 - 8*60*60 ) %>% 
    dplyr::filter(useName == Choose_TV) %>% 
    dplyr::group_by(開始時間) %>% 
    dplyr::summarise(
      Freq = dplyr::n_distinct(開始時間)
    ) %>% 
    plotly::plot_ly( x = ~開始時間,type = 'histogram') %>%
    plotly::layout(
      # title =paste0(Choose_TV),
      title = list(text = paste0(Choose_TV), y = 0.98,
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
