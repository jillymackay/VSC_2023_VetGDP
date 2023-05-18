# This file contains the utils needed for your app
# e.g. if you define any functions you need to plot data with







factor_sum <- function(factor_name, perc_round = 2) {
  
  x <-table(factor_name) %>% 
    as.data.frame()
  
  xx <- prop.table(table(factor_name)) %>% 
    as.data.frame() %>% 
    mutate(Perc = round((Freq*100), perc_round)) %>% 
    select(-Freq)
  
  xxx <- full_join(x,xx)
  
  
  return(xxx)
  
  
}
