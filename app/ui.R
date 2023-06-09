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
                                         
                                         fluidRow(column(width = 6,
                                                         tags$h4("Frequency and proportion of adviser area"),
                                                         tableOutput(outputId = "t2_adarea")),
                                                  column(width = 6,
                                                         tags$h4("Frequency and proportion of graduate first role"),
                                                         tableOutput(outputId = "t3_gradarea"))),
                                         tags$h3("Non applicable responses"),
                                         tags$p("Within the adviser data there is a large number of 'Not Applicable' responses to the 105 questions asking about the graduate's 
                                                preparedness to practice a given clinical skill. It is expected that the Not Applicable adviser responses come from advisers who 
                                                were not able to assess the graduate on a skill, either because they worked wholly within Small Animal practice, or perhaps because 
                                                they did not feel able to assess the graduate on this skill for another reason. For some questions, the majority of advisers were 
                                                not able to rate their graduates"),
                                         tags$h4("Frequency of NA responses across advisers and graduates.\nNote, graduates unlikely to record an 'NA' response for any question"),
                                         tableOutput("t4_adgradna")),
                                
                                
                                fluidRow(tags$h2("Graduate Data"),
                                         tags$p("Graduate gender, age, ethnicity and disability states were self-reported and as below."),
                                         fluidRow(column(width = 3,
                                                         tags$h4("Graduate gender"),
                                                         tableOutput(outputId = "t5_gradgend")),
                                                  column(width = 3,
                                                         tags$h4("Graduate age category"),
                                                         tableOutput(outputId = "t6_gradage")),
                                                  column(width = 3,
                                                        tags$h4("Graduate ethnicity"),
                                                        tableOutput(outputId = "t7_gradeth"),
                                                  column(width = 3,
                                                         tags$h4("Graduate disability recording"),
                                                         tableOutput(outputId = "t8_graddis")))),
                                         fluidRow(tags$p("Graduates were asked to rate their confidence from 1 (Not at all confident) to 5 (Extremely confident) to work independently
                                         when they started their first role:"),
                                                  tags$h4("Graduate's rating of their own confidence at start of employment"),
                                                  plotOutput(outputId = "p1_gradconf"))),
                                
                                
                                fluidRow(tags$h2("Adviser Data"),
                                         tags$p("Adviser age, gender, and their position were provided."),
                                         fluidRow(column(width = 4,
                                                         tags$h4("Adviser age category"),
                                                         tableOutput(outputId = "t9_adage")),
                                                  column(width = 4,
                                                         tags$h4("Adviser gender"),
                                                         tableOutput(outputId = "t10_adgend")),
                                                  column(width = 4,
                                                         tags$h4("Adviser position"),
                                                         tableOutput(outputId = "t11_adpos")))),
                                
                                fluidRow(tags$h2("Comparisons of Grad vs Adviser Perspectives"),
                                         tags$p("It may be useful to explore where there were differences between the adviser and graduate ratings of preparedness. Note, as previously mentioned, we cannot determine whether these differences are a consistent disagreement between advisers and graduates, or whether it is a large disagreement in a select number of cases."),
                                         tags$p("Additionally, please note that there are a number of 'NA' responses for advisers. These are not pictured here, please refer to the table above for a note of how many NA responses are contained within each category."),
                                         tags$h4("History taking (1 (Not at all prepared), 5 (Completely prepared))"),
                                         plotOutput(outputId = "l_hist",
                                                    height = 800),
                                         tags$h4("Examinations (1 (Not at all prepared), 5 (Completely prepared))"),
                                         plotOutput(outputId = "l_exams",
                                                    height = 800),
                                         tags$h4("Prioritise a differential diagnosis (1 (Not at all prepared), 5 (Completely prepared))"),
                                         plotOutput(outputId = "l_prioritise_ddx",
                                                    height = 800),
                                         tags$h4("Treatment planning (1 (Not at all prepared), 5 (Completely prepared))"),
                                         plotOutput(outputId = "l_tx_planning",
                                                    height = 800),
                                         tags$h4("Emergencies (1 (Not at all prepared), 5 (Completely prepared))"),
                                         plotOutput(outputId = "l_emergencies",
                                                    height = 800),
                                         tags$h4("Surgery (pre-op prep) (1 (Not at all prepared), 5 (Completely prepared))"),
                                         plotOutput(outputId = "l_surg_preop",
                                                    height = 800),
                                         tags$h4("Surgery (1 (Not at all prepared), 5 (Completely prepared))"),
                                         plotOutput(outputId = "l_surg_surg",
                                                    height = 800),
                                         tags$h4("Surgery (post op care) (1 (Not at all prepared), 5 (Completely prepared))"),
                                         plotOutput(outputId = "l_surg_postop",
                                                    height = 800),
                                         tags$h4("Anaesthesia (1 (Not at all prepared), 5 (Completely prepared))"),
                                         plotOutput(outputId = "l_anaesthesia",
                                                    height = 800),
                                         tags$h4("Post-mortem (1 (Not at all prepared), 5 (Completely prepared))"),
                                         plotOutput(outputId = "l_pm",
                                                    height = 800),
                                         tags$h4("Preventative healthcare plans (1 (Not at all prepared), 5 (Completely prepared))"),
                                         plotOutput(outputId = "l_healthcareplans",
                                                    height = 800),
                                         tags$h4("Basic epidemiological investigations (1 (Not at all prepared), 5 (Completely prepared))"),
                                         plotOutput(outputId = "l_epi",
                                                    height = 800),
                                         tags$h4("Animal handling (1 (Not at all prepared), 5 (Completely prepared))"),
                                         plotOutput(outputId = "l_handling",
                                                    height = 800),
                                         tags$h4("Evaluating evidence (1 (Not at all prepared), 5 (Completely prepared))"),
                                         plotOutput(outputId = "l_evidence"),
                                         tags$h4("Professional skills and attributes required for independent practice (1 (Not at all prepared), 5 (Completely prepared))"),
                                         plotOutput(outputId = "l_profskills",
                                                    height = 800),
                                         tags$h4("Professional skills and attributes at the point of graduation (1 (Not at all prepared), 5 (Completely prepared))"),
                                         plotOutput(outputId = "l_preparation",
                                                    height = 800))
                                
                                

                                )

                      
                      )
                      

             
             # -------------------------  ShinyUI and NavBar close brackets
  )
)