###### 準備資料  ########
z <- readr::read_csv('TV_DA_shiny/data/Final_report_data.csv',show_col_types = F)
remove_z <- readr::read_csv(file = 'TV_DA_shiny/data/Final_report_remove.csv',show_col_types = F)
# unique(z$客戶編號) %>% length()

z <- z %>% 
  filter(!客戶編號 %in% unique(remove_z$mac)) %>% 
  filter(電視台 <= 412)

TimeZ <- readr::read_csv('TV_DA_shiny/data/TimeSeries_06_UTC_remove_under412.csv',show_col_types = F)
Seat <- which(TimeZ[,-1] > 300,arr.ind = T)
Problem_names <- names(TimeZ)[-1][unique(Seat[,2])]
