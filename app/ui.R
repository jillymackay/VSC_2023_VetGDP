# This defines the user interface



library(shiny)
library(DT)


shinyUI(
  navbarPage(title = "Vet GDP Outcomes",
             id = "navbar",
             tabPanel(title = "Start here - upload your data",
                      sidebarLayout(
                        sidebarPanel(tags$p("Upload your data"),
                                     tags$p("You need to upload your redacted excel files from RCVS. They should be named something like: ['School Name' ADVISER survey raw data 2022 REDACTED.xlsx]"),

                                     fileInput(inputId = "grad",
                                               label = "Upload your GRADUATE file here"),
                                     fileInput(inputId = "ad",
                                               label = "Upload your ADVISER file here")
                                     ),
                        
                        mainPanel(tags$h2("About this app"),
                                  tags$p("This application will process and analyse your Vet GDP outcomes raw data from RCVS. 
                                         Your output report will be comparable to any other school which uses the same app, and
                                         is based on the analysis that the R(D)SVS Data Officer conducted for reporting to accrediting bodies."),

                                  tags$p("The R(D)SVS will not have access to your data or to your output reports, although your data will be processed
                                  on a University of Edinburgh server, we will not have access to that data. 
                                  We have made this app available as part of our enhancement led approach to quality assurance."),
                                  tags$p("If you are curious about what goes on under the hood, all of the code for this project is available here:",
                                         tags$a(href="https://github.com/jillymackay/VSC_2023_VetGDP", "GitHub Repository for Code"),
                                         "We have made this code and app freely available under the 'unlicense', which you can find out more information about
                                         at the link. You are free to take and modify this code for your own purposes, but we cannot provide any warranty or liability
                                         for its use.")

                      ))),
             
             
             # ------------------------- Output Tab below -------------------
             
             tabPanel(title = "See your report",
                      fluidPage(
                        fluidRow(fluidRow(column(width = 6,
                                                 plotOutput(outputId = "testplotgrad")),
                                          column(width = 6, plotOutput(outputId = "testplotad"))),
                                 fluidRow(column(width = 12,
                                                 plotOutput(outputId = "testplotboth")))
                      )
                      ))
             
             # -------------------------  App close brackets
  )
)