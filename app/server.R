# This is where the data processing happens


library(shiny)
library(tidyverse)




shinyServer(function(input, output, session) {
  
  
  
  
  # ---------- Read and clean grad and ad data
  
  
  grad <- reactive ({
    
    infile <- input$grads
    if (is.null(infile)) {
      return(NULL)
    }
    
    readxl::read_excel(infile$datapath) %>% 
      gradclean()
    
  })
  
  
  ads <- reactive ({
    
    infile <- input$ads
    if (is.null(infile)) {
      return(NULL)
    }
    
    readxl::read_excel(infile$datapath) %>% 
      adclean()
    
  })
  

  # -------------------- Produce combined data
  
  
  adgrad <- reactive ({
    
    
    d1 <- addat %>% 
      select(-c("Adviser Gender":"Adviser Position"))
    d2 <- graddat %>% 
      select(-c("Grad Gender":"Grad Confidence First Start"))
    
   rbind (d1, d2) %>% 
      as.data.frame()
  
     rm(d1, d2)
    
  })
  
  
  
  # ---------- Plots
  
  
  output$table1 <- renderTable({
    
    AdGrad %>% 
      pivot_longer(cols= c(-grp), names_to = "response", values_to = "score" ) %>% 
      filter(is.na(score)) %>% 
      group_by(grp, response, score) %>% 
      tally() %>%
      mutate("Percentage" = round(n/78*100, 2)) %>% 
      rename("Group" = grp,
             Question = "response") %>% 
      select(Group, Question, n, Percentage) %>% 
      arrange(Percentage) 
    
  })
  
  
  
  
  output$plot1 <- renderPlot({
    
    mpg %>% 
      ggplot(aes(x = as.factor(cyl), y = hwy)) +
      geom_boxplot()
  }
  )
  
  output$plot2 <- renderPlot({
    mpg %>% 
      ggplot(aes(x = as.factor(trans), y = hwy)) +
      geom_boxplot()
  })
  
  output$plot3 <- renderPlot({
    mpg %>% 
      ggplot(aes(x = cty, y = hwy)) +
      geom_point()
  })
})