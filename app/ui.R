# This defines the user interface



library(shiny)
library(DT)


shinyUI(
  navbarPage(title = "A basic Shiny App to build off of",
             id = "navbar",
             tabPanel(title = "Panel 1: About",
                      sidebarLayout(
                        sidebarPanel(tags$p("This is a sidebar panel within Panel 1"),
                                     tags$p("You can ask for stuff here. Suggest a name which will be processed in the server to an output!"),
                                     textInput(inputId = "rand_name_in",
                                               label = "Input any old name here!",
                                               placeholder = "Jane")),
                        
                        mainPanel(tags$h2("Displaying data"),
                                  tags$p("Once you have inputted a name, it should appear here!"),
                                  verbatimTextOutput("rand_name"))
                      )),
             
             tabPanel(title = "Panel 2: Charts with fluid chunks!",
                      fluidPage(
                        fluidRow(column(width = 6,
                                        plotOutput(outputId = "plot1")),
                                 column(width = 6, 
                                        plotOutput(outputId = "plot2")),
                                 fluidRow(column(width = 12, 
                                                 plotOutput(outputId = "plot3"))))
                      ))
             
             
  )
)