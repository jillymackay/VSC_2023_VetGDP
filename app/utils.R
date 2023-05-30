# This file contains the utils needed for your app
# e.g. if you define any functions you need to plot data with


# I think I need to call module in the server for this to work?

# Don't think I'll have time for that to do this for veted

# e.g. 

# https://stackoverflow.com/questions/43976128/create-a-reactive-function-outside-the-shiny-app






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



# Making Likert Plots

lik_hist <- function(){
  plot(likert(items = adgrad()[,1:9], grouping = adgrad()[,120]))
}
