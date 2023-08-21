# PD <- PlotData_Program[c(1:20),]
# PD <- PlotData_Program[!grepl('新聞|TVBS',PlotData_Program$電視台名稱),][1:20,]
 
TV_rank_plot <- function(z,Choose){
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
  ### choose
  if(Choose == '未分類'){
    PD <- PlotData_Program[c(1:20),]
  }else if(Choose == '去除新聞台'){
    PD <- PlotData_Program[!grepl('新聞|TVBS',PlotData_Program$電視台名稱),][1:20,]
  }
  # PD <- PlotData_Program[c(1:20),]
  # PD <- PlotData_Program[!grepl('新聞|TVBS',PlotData_Program$電視台名稱),][1:20,]
  p1 <- PD %>% 
    ggplot(aes(y = useName,x = Freq))+
    geom_bar(stat = "identity",alpha = 0.8,
             aes(fill = rep(c("darkblue", "darkgreen", "darkred", "darkorange"),each = 5)))+
    xlab('')+
    ylab('')+
    labs(title = '電視台觀看次數')+
    labs(fill='NEW LEGEND TITLE') +
    geom_text(
      data = PD,
      aes(0, y = useName, label = Freq),
      hjust = 0,
      nudge_x = 0.3,
      colour = "gray26",
      family = "Econ Sans Cnd",
      size = 6
    )+
    scale_x_continuous(
      expand = c(0, 2), # The horizontal axis does not extend to either side
      position = "top"  # Labels are located on the top
    )+
    theme(legend.position = 'none',
          axis.title.y = element_blank(),
          axis.text.y = element_text(size = 15),
          plot.margin = margin(t = 5, r = 20, b = 1, l = 5, unit = "pt"))
  
  # p2 <- PlotData_Program[c(1:20),] %>% 
  p2 <- PD %>% 
    ggplot(aes(y = useName,x = Avg))+
    geom_bar(stat = "identity",alpha = 0.8,
             aes(fill = rep(c("darkblue", "darkgreen", "darkred", "darkorange"),each = 5)))+
    xlab('')+
    ylab('')+
    labs(title = '平均觀看時間(分鐘)')+
    theme(legend.position = 'none') +
    geom_text(
      data = PD,
      aes(0, y = useName, label = round(Avg,1)),
      hjust = 0,
      nudge_x = 0.3,
      colour = "gray26",
      family = "Econ Sans Cnd",
      size = 6
    )+
    scale_x_continuous(
      expand = c(0, 0), # The horizontal axis does not extend to either side
      position = "top"  # Labels are located on the top
    )+
    theme(axis.title.y = element_blank(),
          axis.text.y = element_blank(),
          axis.ticks.y = element_blank(),
          plot.margin = margin(t = 5, r = 5, b = 1, l = 5, unit = "pt"))
  
  
  p_output <- ggarrange(p1, p2,
                        ncol = 2,
                        widths = c(2.5,1))
  return(p_output)
}
