TV_choose_plotly <- function(z,Choose_TV){
  p <- z %>% 
    mutate(useName = paste0(電視台名稱,'(',電視台,')')) %>% 
    filter(useName == Choose_TV) %>% 
    group_by(開始時間) %>% 
    summarise(
      Freq = n()
    ) %>% 
    plot_ly( x = ~開始時間,type = 'histogram') %>%
    layout(
      title =paste0(Choose_TV),
      xaxis = list(
        rangeslider = list(type = "date")
      ),
      margin = list(t = 50))
  return(p)
}
