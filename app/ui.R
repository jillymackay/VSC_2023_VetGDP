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

                                     fileInput(inputId = "ad",
                                               label = "Upload your ADVISER file here"),
                                     fileInput(inputId = "grad",
                                               label = "Upload your GRADUATE file here")
                                     
                                     ),
                        
                        mainPanel(tags$h2("About this app"),
                                  tags$p("This application will process and analyse your Vet GDP outcomes raw data from RCVS. 
                                         Your output report will be comparable to any other school which uses the same app, and
                                         is based on the analysis that the R(D)SVS Data Officer conducted for reporting to accrediting bodies."),
                                  
                                  tags$p("Your data has the following numbers of Graduates and Advisers:"),
                                  tags$em("Note: the table will show after you have uploaded your data."),
                                  tableOutput(outputId = "t1_nadgrad"),
                                  tags$em("If this doesn't seem right, check you have uploaded the correct files on the left hand side."),

                                  tags$p("The R(D)SVS will not have access to your data or to your output reports, although your data will be processed
                                  on a University of Edinburgh server, we will not have access to that data. 
                                  We have made this app available as part of our enhancement led approach to quality assurance."),
                                  tags$p("If you are curious about what goes on under the hood, all of the code for this project is available here:",
                                         tags$a(href="https://github.com/jillymackay/VSC_2023_VetGDP", "GitHub Repository for Code"),
                                         "We have made this code and app freely available under the 'unlicense', which you can find out more information about
                                         at the link. You are free to take and modify this code for your own purposes, but we cannot provide any warranty or liability
                                         for its use.")

                      ))),
             
             
             # ------------------------- See your report Tab below -------------------
             
             tabPanel(title = "See your report",
                      
                      fluidPage(fluidRow(tags$p("You can download a word document version of this page by clicking below."),
                                         downloadButton(outputId = "report",
                                                        label = "Generate Downloadable Report")),
                                fluidRow(tags$hr(),
                                         tags$h1("2022 Graduate and VetGDP Adviser Surveys"),
                                         tags$h2("About this report"),
                                         tags$p("This report was generated based on the Royal College of Veterinary Surgeons (RCVS) Education Outcomes Data from 
                                                Graduates and Advisers received in 2023. It was generated from the full redacted data provided by the RCVS for the 
                                                purposes of additional analyses for quality improvement and processed via the R(D)SVS app.", 
                                                tags$a(href="https://github.com/jillymackay/VSC_2023_VetGDP", "More information about the app can be found here")),
                                         tags$p("This data was collected by the RCVS, and the R(D)SVS app has no input into question formation or data collection."),
                                         tags$p("Graduates respond to the RCVS survey prior to setting up their personal e-portfolio. Advisers were matched with 
                                                graduates to act as a mentor and asked to complete the survey  approximately 6 weeks after the graduate had started their 
                                                programme to allow time for skills to be assessed. Advisers worked only with 2022 graduates."),
                                         tags$p("The majority of questions within the survey are presented in the following format:"),
                                         tags$em("How well prepared was the graduate to [conduct skill] at the point of graduation?",
                                                tags$li("1. (Not at all prepared)"),
                                                tags$li("2."),
                                                tags$li("3."),
                                                tags$li("4."),
                                                tags$li("5. (Completely prepared)")),
                                         tags$br(),
                                         tags$p("There are 105 clinical skill related questions and 14 professional skill related questions. Graduates were also asked to rate 
                                                their overall confidence to work independently when starting their first role on a scale from 1 (Not at all confident) to 5 
                                                (Extremely confident).")),
                                
                                fluidRow(tags$h2("Adviser and Graduate Role"),
                                         tags$p("While it is possible for advisers and graduates to work in a range of areas, 
                                                the graduates first roles and the adviser areas in your data are presented below."),
                                         
                                         fluidRow(column(width = 5,
                                                         tags$h4("Frequency and proportion of adviser area"),
                                                         tableOutput(outputId = "t2_adarea")),
                                                  column(width = 2),
                                                  column(width = 5,
                                                         tags$h4("Frequency and proportion of graduate first role"),
                                                         tableOutput(outputId = "t3_gradarea")))),
                                
                                fluidRow(column(width = 6,
                                                plotOutput(outputId = "testplotgrad")),
                                         column(width = 6, 
                                                plotOutput(outputId = "testplotad"))),
                                fluidRow(column(width = 12,
                                                plotOutput(outputId = "l_hist")))
                                )

                        
                      )
                      

             
             # -------------------------  ShinyUI and NavBar close brackets
  )
)