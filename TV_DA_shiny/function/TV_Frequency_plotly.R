
TV_Frequency_plotly <- function(TimeZ){
  Seat <- which(TimeZ[,-1] > 300,arr.ind = T)
  Problem_names <- names(TimeZ)[-1][unique(Seat[,2])]
  # p <- PlotData_over0 %>%
  PlotData_over0 <- TimeZ %>% 
    as_tibble() %>% 
    filter(Date > as.POSIXct('2023-06-01 23:00:00',tz = 'UTC')) %>% 
    filter(Date < as.POSIXct('2023-06-08 00:00:00',tz = 'UTC')) %>% 
    tidyr::pivot_longer(!Date,names_to = 'mac', values_to = 'druation') %>% 
    filter(!(mac %in% Problem_names)) %>%
    filter(druation > 0)
  
  p <- PlotData_over0 %>%
    group_by(Date) %>% 
    summarise(
      Freq = n()
    ) %>% 
    plot_ly( x = ~Date) %>% 
    add_lines(y = ~Freq, name = "") %>% 
    layout(
      title = "TV Druation Freq",
      xaxis = list(
        rangeslider = list(type = "date")
      ))
  return(p)
}
