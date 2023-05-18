# This is where the data processing happens


library(shiny)
library(tidyverse)
library(ggstatsplot)
library(likert)
library(grid)





shinyServer(function(input, output, session) {
  

  
  
  # ---------- Read and clean grad and ad data
  
  
  
  grad <- reactive ({
    
    req(input$grad)
    
    infile <- input$grad
    
    req(input$grad,
        file.exists(input$grad$datapath))
    
    readxl::read_excel(infile$datapath) %>% 
      mutate_at(.vars = vars(`Companion Animal - Pruritus...18`:`In many cases, there needs to be a significant *economic consideration* to the *level of treatment* that can be provided to a patient that reflects the *financial circumstances of the client.* How well did your veterinary programme prepare you to consider and offer treatments that *take into account the financial constraints of the client*?`),
                .funs = function(x) case_when (NA ~ "Not Applicable",
                                               TRUE ~ as.character(x)))  %>% 
      mutate_at(.vars = vars(`Companion Animal - Pruritus...18`:`In many cases, there needs to be a significant *economic consideration* to the *level of treatment* that can be provided to a patient that reflects the *financial circumstances of the client.* How well did your veterinary programme prepare you to consider and offer treatments that *take into account the financial constraints of the client*?`),
                .funs = funs(factor(., levels = c("1",
                                                  "2",
                                                  "3",
                                                  "4",
                                                  "5",
                                                  NA)))) %>% 
      rename(
        "Grad Gender" = 	"What is your gender?",
        "Grad Age" = 	"What is your age?",
        "Grad Ethnicity" = 	"Please select from the following list your  ethnic group",
        "Grad Disability" = 	"*Disability*:  The Equality Act 2010 defines a person as disabled if they have a physical or mental impairment, which has a substantial and long term effect (i.e. has lasted or is expected to last at least 12 months) on the persons ability to carry out normal day-to-day activities",
        "Grad Year" = 	"In what year did you graduate?",
        "Grad Pre Clinical EMS" = 	"How many weeks of pre-clinical (animal handling) EMS placements did you complete during your course?",
        "Grad Clinical EMS" = 	"How many weeks of clinical EMS did you complete ?",
        "Grad IMR First Opinion" = 	"How many weeks of Intra-Mural Rotations (IMR) did you complete during the programme (to include core and elective rotations) in a 1st opinion practice setting?",
        "Grad IMR Referral" = 	"How many weeks of IMR did you complete during the programme (to include core and elective rotations) in a referral practice setting?",
        "Grad First Role" = 	"Please select which of the following best describes your first role",
        "Grad Current Role" = 	"Please select what best describes your current role",
        "Grad Adviser Allocation" = 	"Have you been allocated a VetGDP Adviser within your workplace?",
        "Grad Confidence First Start" = 	"When starting your first role, how confident did you feel in your ability to work independently?",
        "Hx CA pruritis" = 	"Companion Animal - Pruritus...18",
        "Hx CA diarrhoea" = 	"Companion Animal - Diarrhoea...19",
        "Hx CA coughing" = 	"Companion Animal - Coughing...20",
        "Hx Eq Colic" = 	"Equine - Colic...21",
        "Hx Eq Pruritus" = 	"Equine - Pruritus...22",
        "Hx Eq Lameness" = 	"Equine - Lameness...23",
        "Hx PA Mastitis" = 	"Production Animal - Mastitis...24",
        "Hx PA Diarrhoea" = 	"Production Animal - Diarrhoea...25",
        "Hx PA Respiratory Disease" = 	"Production Animal - Respiratory Disease...26",
        "Exam CA Pruritus" = 	"Companion Animal - Pruritus...27",
        "Exam CA Diarrhoea" = 	"Companion Animal - Diarrhoea...28",
        "Exam CA Coughing" = 	"Companion Animal - Coughing...29",
        "Exam Eq Colic" = 	"Equine - Colic...30",
        "Exam Eq Pruritus" = 	"Equine - Pruritus...31",
        "Exam Eq Lameness" = 	"Equine - Lameness...32",
        "Exam PA Mastitis" = 	"Production Animal - Mastitis...33",
        "Exam PA Diarrhoea" = 	"Production Animal - Diarrhoea...34",
        "Exam PA Respiratory Disease" = 	"Production Animal - Respiratory Disease...35",
        "Prioritise DDx CA Pruritus" = 	"Companion Animal - Pruritus...36",
        "Prioritise DDx CA Diarrhoea" = 	"Companion Animal - Diarrhoea...37",
        "Prioritise DDx CA Coughing" = 	"Companion Animal - Coughing...38",
        "Prioritise DDx Eq Colic" = 	"Equine - Colic...39",
        "Prioritise DDx Eq Pruritus" = 	"Equine - Pruritus...40",
        "Prioritise DDx Eq Lameness" = 	"Equine - Lameness...41",
        "Prioritise DDx PA  Mastitis" = 	"Production Animal - Mastitis...42",
        "Prioritise DDx PA Diarrhoea" = 	"Production Animal - Diarrhoea...43",
        "Prioritise DDx PA Respiratory Disease" = 	"Production Animal - Respiratory Disease...44",
        "Tx CA Pruritus" = 	"Companion Animal - Pruritus...45",
        "Tx CA Diarrhoea" = 	"Companion Animal - Diarrhoea...46",
        "Tx CA Coughing" = 	"Companion Animal - Coughing...47",
        "Tx Eq Colic" = 	"Equine - Colic...48",
        "Tx Eq Pruritus" = 	"Equine - Pruritus...49",
        "Tx Eq Lameness" = 	"Equine - Lameness...50",
        "Tx PA Mastitis" = 	"Production Animal - Mastitis...51",
        "Tx PA Diarrhoea" = 	"Production Animal - Diarrhoea...52",
        "Tx PA Respiratory" = 	"Production Animal - Respiratory Disease...53",
        "Emergency CA Recognise an emergency" = 	"Recognise an emergency in Companion Animals",
        "Emergency CA Evaluate First Aid" = 	"Evaluate first aid management of an emergency in Companion Animals",
        "Emergency EQ Recognise an emergency" = 	"Recognise an emergency in Equines",
        "Emergency EQ Evaluate First Aid" = 	"Evaluate first aid management of an emergency in Equines",
        "Emergency PA Recognise an emergency" = 	"Recognise an emergency in Production Animals",
        "Emergency PA Evaluate First Aid" = 	"Evaluate first aid management of an emergency in Production Animals",
        "Surg CA Dog Castration Pre Op Prep" = 	"Dog castration - Companion Animal...60",
        "Surg CA Cat Spay Pre Op Prep" = 	"Cat Spay - Companion Animal...61",
        "Surg CA Lump Removal Pre Op Prep" = 	"Lump removal - Companion Animal...62",
        "Surg Eq Castration Pre Op Prep" = 	"Castration - Equine...63",
        "Surg Eq Wound Suturing Pre Op Prep" = 	"Wound suturing - Equine...64",
        "Surg Eq Lump Removal Pre Op Prep" = 	"Lump removal - Equine...65",
        "Surg PA Displaced Abomasum Pre Op Prep" = 	"Displaced Abomasum - Production Animal...66",
        "Surg PA Caesarean Pre Op Prep" = 	"Caesarean - Production Animal...67",
        "Surg PA Castration Pre Op Prep" = 	"Castration - Production Animal...68",
        "Surg CA Dog Castration Surgery" = 	"Dog castration - Companion Animal...69",
        "Surg CA Cat Spay Surgery" = 	"Cat Spay - Companion Animal...70",
        "Surg CA Lump Removal Surgery" = 	"Lump removal - Companion Animal...71",
        "Surg Eq Castration Surgery" = 	"Castration - Equine...72",
        "Surg Eq Wound Suturing Surgery" = 	"Wound suturing - Equine...73",
        "Surg Eq Lump Removal Surgery" = 	"Lump removal - Equine...74",
        "Surg PA Displaced Abomasum Surgery" = 	"Displaced Abomasum - Production Animal...75",
        "Surg PA Caesarean Surgery" = 	"Caesarean - Production Animal...76",
        "Surg PA Castration Surgery" = 	"Castration - Production Animal...77",
        "Surg CA Dog Castration Post Op Care" = 	"Dog castration - Companion Animal...78",
        "Surg CA Cat Spay Post Op Care" = 	"Cat Spay - Companion Animal...79",
        "Surg CA Lump Removal Post Op Care" = 	"Lump removal - Companion Animal...80",
        "Surg Eq Castration Post Op Care" = 	"Castration - Equine...81",
        "Surg Eq Wound Suturing Post Op Care" = 	"Wound suturing - Equine...82",
        "Surg Eq Lump Removal Post Op Care" = 	"Lump removal - Equine...83",
        "Surg PA Displaced Abomasum Post Op Care" = 	"Displaced Abomasum - Production Animal...84",
        "Surg PA Caesarean Post Op Care" = 	"Caesarean - Production Animal...85",
        "Surg PA Castration Post Op Care" = 	"Castration - Production Animal...86",
        "Anaesthesia CA Induce, maintain and recover" = 	"Induce, maintain and recover anaesthetic patients - Companion Animal",
        "Anaesthesia CA Perform sedation" = 	"Perform sedation - Companion Animal",
        "Anaesthesia CA Perform local and regional" = 	"Perform local / regional anaesthesia - Companion Animal",
        "Anaesthesia Eq Induce, maintain and recover" = 	"Induce, maintain and recover anaesthetic patients - Equine",
        "Anaesthesia Eq Perform sedation" = 	"Perform sedation - Equine",
        "Anaesthesia Eq Perform local and regional" = 	"Perform local / regional anaesthesia - Equine",
        "Anaesthesia PA Induce, maintain and recover" = 	"Induce, maintain and recover anaesthetic patients - Production Animal",
        "Anaesthesia PA Perform sedation" = 	"Perform sedation - Production Animal",
        "Anaesthesia PA Perform local and regional" = 	"Perform local / regional anaesthesia - Production Animal",
        "Post Mortem CA" = 	"Companion Animal...96",
        "Post Mortem Eq" = 	"Equine...97",
        "Post Morten PA" = 	"Production Animal...98",
        "Preventative Healthcare CA Ectoparasite" = 	"Ectoparasite control - Companion Animal",
        "Preventative Healthcare CA Worms" = 	"Worms - Companion Animal",
        "Preventative Healthcare CA Weight Control" = 	"Weight control - Companion Animal",
        "Preventative Healthcare CA Dental Care" = 	"Dental care - Companion Animal",
        "Preventative Healthcare Eq Fly Control" = 	"Fly control - Equine",
        "Preventative Healthcare Eq Worms" = 	"Worms - Equine",
        "Preventative Healthcare Eq Weight Control" = 	"Weight control - Equine",
        "Preventative Healthcare Eq Dental Care" = 	"Dental care - Equine",
        "Preventative Healthcare PA Parasite Control" = 	"Parasite control - Production Animal",
        "Preventative Healthcare PA Vacc Protocol" = 	"Vaccination protocol - Production Animal",
        "Preventative Healthcare PA Foot Care" = 	"Foot care - Production Animal",
        "Preventative Healthcare PA Nutrition" = 	"Nutrition - Production Animal",
        "Epi CA Kennel Cough" = 	"Kennel cough - Companion Animal",
        "Epi CA Dermatophytosis" = 	"Dermatophytosis - Companion Animal",
        "Epi CA Canine Parvo" = 	"Canine Parvovirus - Companion Animal",
        "Epi Eq Streptococcus (Strangles)" = 	"Streptococcus Equi (Strangles) - Equine",
        "Epi Eq Influenza" = 	"Equine Influenza - Equine",
        "Epi Eq Lice" = 	"Lice - Equine",
        "Epi PA Mastitis" = 	"Mastitis - Production Animal",
        "Epi PA BVD" = 	"Bovine Viral Diarrhoea - Production Animal",
        "Epi PA Abortion" = 	"Abortion - Production Animal",
        "Animal Handling CA" = 	"Companion Animal...120",
        "Animal Handling Eq" = 	"Equine...121",
        "Animal Handling PA" = 	"Production Animal...122",
        "Evaluating Evidence" = 	"Please tell us how well you feel your veterinary programme prepared you to *independently critique the quality of evidence presented in veterinary resources and assess their applicability to the clinical situation*? (at the point of graduation)",
        "Prof Skills Independent Practice Communicate effectively" = 	"Communicate effectively with clients, the public, professional colleagues and responsible authorities, using language appropriate to the audience concerned.",
        "Prof Skills Independent Practice Demonstrate self awareness of personal and professional limits" = 	"Demonstrate self-awareness of personal and professional limits, and know when to seek professional advice, assistance and support.",
        "Prof Skills Independent Practice Ask for advice and support" = 	"Ask for advice and support from your colleagues.",
        "Prof Skills Independent Practice Manage where information is incomplete" = 	"Demonstrate ability to manage situations where information is incomplete, deal with contingencies, and adapt to change.",
        "Prof Skills Independent Practice Discuss euthanasia sensitively" = 	"Discuss euthanasia with clients whilst showing sensitivity and empathy.",
        "Prof Skills Independent Practice Work Effectively interprofessionally" = 	"Work effectively as a member of a professional/ inter-professional team, fully recognising the contribution of each professional, and demonstrate an understanding of cognitive diversity.",
        "Prof Skills Undertaking unfamiliar procedures" = 	"To undertake unfamiliar procedures.",
        "Prof Skills Time management" = 	"To manage your time.",
        "Prof Skills Ask for help and support" = 	"To ask for help and support from your peers and colleagues.",
        "Prof Skills Dealing with unknowns" = 	"To make decisions in cases when there is a degree of unknown information.",
        "Prof Skills Manage stressful situations" = 	"To manage stressful situations.",
        "Prof Skills Appropriately manage their emotions" = 	"To appropriately manage your emotions during client interactions.",
        "Prof Skills Consider economic factors" = 	"In many cases, there needs to be a significant *economic consideration* to the *level of treatment* that can be provided to a patient that reflects the *financial circumstances of the client.* How well did your veterinary programme prepare you to consider and offer treatments that *take into account the financial constraints of the client*?"
      ) %>% 
      select(-c(    "If you consider yourself to have a disability according to the terms given in the *Equality Act 2010*, how would you describe your disability?",
                    "Was your course delivered in the UK?",
                    "From which Vet School did you graduate?...7",
                    "From which Vet School did you graduate?...8", 
                    "*Strengths*",
                    "*Areas for improvement*" )) %>% 
      mutate(grp = "Grad")
  })
  

  
  
  
  ad <- reactive ({
    
    req(input$ad)
    
    infile <- input$ad
    
    req(input$ad,
        file.exists(input$ad$datapath))
    
    readxl::read_excel(infile$datapath) %>% 
      mutate_at(.vars = vars(`Companion Animal -Pruritus...9`:`In many cases, there needs to be a significant economic consideration to the level of treatment that can be provided to a patient that reflects the financial circumstances of the client`),
                .funs = function(x) case_when (NA ~ "Not Applicable",
                                               TRUE ~ as.character(x)))  %>% 
      mutate_at(.vars = vars(`Companion Animal -Pruritus...9`:`In many cases, there needs to be a significant economic consideration to the level of treatment that can be provided to a patient that reflects the financial circumstances of the client`),
                .funs = funs(factor(., levels = c("1",
                                                  "2",
                                                  "3",
                                                  "4",
                                                  "5",
                                                  NA)))) %>% 
      janitor::clean_names() %>% 
      rename("Adviser Gender" = "what_is_your_gender",
             "Adviser Age" =  "what_is_your_age",
             "Adviser Area" = "please_select_which_of_the_following_best_describes_the_area_of_the_profession_in_which_you_currently_work",
             "Adviser Position" = "please_select_the_position_you_currently_hold",
             "Hx CA pruritis" = "companion_animal_pruritus_9",
             "Hx CA diarrhoea" = "companion_animal_diarrhoea_10",
             "Hx CA coughing" = "companion_animal_coughing_11",
             "Hx Eq Colic" =  "equine_colic_12",
             "Hx Eq Pruritus" =  "equine_pruritus_13",
             "Hx Eq Lameness" = "equine_lameness_14",
             "Hx PA Mastitis" = "production_animal_mastitis_15",
             "Hx PA Diarrhoea" = "production_animal_diarrhoea_16",
             "Hx PA Respiratory Disease" = "production_animal_respiratory_disease_17",
             "Exam CA Pruritus" = "companion_animal_pruritus_18",
             "Exam CA Diarrhoea" = "companion_animal_diarrhoea_19",
             "Exam CA Coughing" = "companion_animal_coughing_20",
             "Exam Eq Colic" = "equine_colic_21",
             "Exam Eq Pruritus" = "equine_pruritus_22",
             "Exam Eq Lameness" = "equine_lameness_23",
             "Exam PA Mastitis" = "production_animal_mastitis_24",
             "Exam PA Diarrhoea" = "production_animal_diarrhoea_25",
             "Exam PA Respiratory Disease" = "production_animal_respiratory_disease_26",
             "Prioritise DDx CA Pruritus" = "companion_animal_pruritus_27",                                                                                                                                                                                       
             "Prioritise DDx CA Diarrhoea" = "companion_animal_diarrhoea_28",                                                                                                                                                                                      
             "Prioritise DDx CA Coughing" = "companion_animal_coughing_29",                                                                                                                                                                                       
             "Prioritise DDx Eq Colic"= "equine_colic_30",                                                                                                                                                                                                    
             "Prioritise DDx Eq Pruritus"= "equine_pruritus_31",                                                                                                                                                                                                
             "Prioritise DDx Eq Lameness" ="equine_lameness_32" ,                                                                                                                                                                                                
             "Prioritise DDx PA  Mastitis" ="production_animal_mastitis_33",                                                                                                                                                                                      
             "Prioritise DDx PA Diarrhoea" ="production_animal_diarrhoea_34",                                                                                                                                                                                     
             "Prioritise DDx PA Respiratory Disease"= "production_animal_respiratory_disease_35",
             "Tx CA Pruritus" = "companion_animal_pruritus_36",                                                                                                                                                                                       
             "Tx CA Diarrhoea"= "companion_animal_diarrhoea_37",                                                                                                                                                                                      
             "Tx CA Coughing" ="companion_animal_coughing_38",                                                                                                                                                                                       
             "Tx Eq Colic"= "equine_colic_39",                                                                                                                                                                                                    
             "Tx Eq Pruritus" ="equine_pruritus_40",                                                                                                                                                                                                 
             "Tx Eq Lameness" = "equine_lameness_41" ,                                                                                                                                                                                                
             "Tx PA Mastitis"= "production_animal_mastitis_42" ,                                                                                                                                                                                     
             "Tx PA Diarrhoea" ="production_animal_diarrhoea_43" ,                                                                                                                                                                                    
             "Tx PA Respiratory"= "production_animal_respiratory_disease_44",
             "Emergency CA Recognise an emergency" = "recognise_an_emergency_in_companion_animals",                                                                                                                                                                        
             "Emergency CA Evaluate First Aid" = "evaluate_first_aid_management_of_an_emergency_in_companion_animals",                                                                                                                                                 
             "Emergency EQ Recognise an emergency" = "recognise_an_emergency_in_equines",                                                                                                                                                                                  
             "Emergency EQ Evaluate First Aid"=  "evaluate_first_aid_management_of_an_emergency_in_equines",                                                                                                                                                           
             "Emergency PA Recognise an emergency" = "recognise_an_emergency_in_production_animals",                                                                                                                                                                       
             "Emergency PA Evaluate First Aid" = "evaluate_first_aid_management_of_an_emergency_in_production_animals" ,
             "Surg CA Dog Castration Pre Op Prep" = "dog_castration_companion_animal_51",
             "Surg CA Cat Spay Pre Op Prep" = "cat_spay_companion_animal_52",
             "Surg CA Lump Removal Pre Op Prep" = "lump_removal_companion_animal_53",
             "Surg Eq Castration Pre Op Prep" = "castration_equine_54",
             "Surg Eq Wound Suturing Pre Op Prep" = "wound_suturing_equine_55",
             "Surg Eq Lump Removal Pre Op Prep" = "lump_removal_equine_56",
             "Surg PA Displaced Abomasum Pre Op Prep" =  "displaced_abomasum_production_animal_57",
             "Surg PA Caesarean Pre Op Prep" = "caesarean_production_animal_58",
             "Surg PA Castration Pre Op Prep" = "castration_production_animal_59",
             "Surg CA Dog Castration Surgery" = "dog_castration_companion_animal_60",
             "Surg CA Cat Spay Surgery" = "cat_spay_companion_animal_61",
             "Surg CA Lump Removal Surgery" = "lump_removal_companion_animal_62",
             "Surg Eq Castration Surgery" = "castration_equine_63",
             "Surg Eq Wound Suturing Surgery" = "wound_suturing_equine_64",
             "Surg Eq Lump Removal Surgery" = "lump_removal_equine_65",
             "Surg PA Displaced Abomasum Surgery" = "displaced_abomasum_production_animal_66",
             "Surg PA Caesarean Surgery" = "caesarean_production_animal_67",
             "Surg PA Castration Surgery" = "castration_production_animal_68",
             "Surg CA Dog Castration Post Op Care" = "dog_castration_companion_animal_69",
             "Surg CA Cat Spay Post Op Care" = "cat_spay_companion_animal_70",
             "Surg CA Lump Removal Post Op Care" = "lump_removal_companion_animal_71",
             "Surg Eq Castration Post Op Care" =  "castration_equine_72",
             "Surg Eq Wound Suturing Post Op Care" = "wound_suturing_equine_73",
             "Surg Eq Lump Removal Post Op Care" = "lump_removal_equine_74",
             "Surg PA Displaced Abomasum Post Op Care" = "displaced_abomasum_production_animal_75",
             "Surg PA Caesarean Post Op Care" = "caesarean_production_animal_76",
             "Surg PA Castration Post Op Care" = "castration_production_animal_77",
             "Anaesthesia CA Induce, maintain and recover" = "induce_maintain_and_recover_anaesthetic_patients_companion_animal",
             "Anaesthesia CA Perform sedation" = "perform_sedation_companion_animal",
             "Anaesthesia CA Perform local and regional" = "perform_local_regional_anaesthesia_companion_animal",
             "Anaesthesia Eq Induce, maintain and recover" = "induce_maintain_and_recover_anaesthetic_patients_equine",
             "Anaesthesia Eq Perform sedation" = "perform_sedation_equine",
             "Anaesthesia Eq Perform local and regional" = "perform_local_regional_anaesthesia_equine",
             "Anaesthesia PA Induce, maintain and recover" = "induce_maintain_and_recover_anaesthetic_patients_production_animal",
             "Anaesthesia PA Perform sedation" = "perform_sedation_production_animal",
             "Anaesthesia PA Perform local and regional" = "perform_local_regional_anaesthesia_production_animal",
             "Post Mortem CA" = "companion_animal_87",
             "Post Mortem Eq" = "equine_88",
             "Post Morten PA" = "production_animal_89" ,
             "Preventative Healthcare CA Ectoparasite" = "ectoparasite_control_companion_animal",
             "Preventative Healthcare CA Worms" = "worms_companion_animal",
             "Preventative Healthcare CA Weight Control" = "weight_control_companion_animal",
             "Preventative Healthcare CA Dental Care" = "dental_care_companion_animal",
             "Preventative Healthcare Eq Fly Control" = "fly_control_equine",
             "Preventative Healthcare Eq Worms" = "worms_equine",
             "Preventative Healthcare Eq Weight Control" = "weight_control_equine",
             "Preventative Healthcare Eq Dental Care" = "dental_care_equine",
             "Preventative Healthcare PA Parasite Control" = "parasite_control_production_animal",
             "Preventative Healthcare PA Vacc Protocol" = "vaccination_protocol_production_animal",
             "Preventative Healthcare PA Foot Care" = "foot_care_production_animal",
             "Preventative Healthcare PA Nutrition"  = "nutrition_production_animal",
             "Epi CA Kennel Cough" = "kennel_cough_companion_animal",
             "Epi CA Dermatophytosis" = "dermatophytosis_companion_animal",
             "Epi CA Canine Parvo" = "canine_parvovirus_companion_animal",
             "Epi Eq Streptococcus (Strangles)" = "streptococcus_equi_strangles_equine",
             "Epi Eq Influenza" = "equine_influenza_equine",
             "Epi Eq Lice" = "lice_equine",
             "Epi PA Mastitis" = "mastitis_production_animal",
             "Epi PA BVD" = "bovine_viral_diarrhoea_production_animal",
             "Epi PA Abortion" = "abortion_production_animal",
             "Animal Handling CA" = "companion_animal_111",
             "Animal Handling Eq" = "equine_112",
             "Animal Handling PA" = "production_animal_113",
             "Evaluating Evidence" = "how_well_prepared_was_the_graduate_to_independently_critique_the_quality_of_evidence_presented_in_veterinary_resources_and_assess_their_applicability_to_the_clinical_situation_when_they_began_their_role_with_you",
             "Prof Skills Independent Practice Communicate effectively" = "communicate_effectively_with_clients_the_public_professional_colleagues_and_responsible_authorities_using_language_appropriate_to_the_audience_concerned",
             "Prof Skills Independent Practice Demonstrate self awareness of personal and professional limits" = "demonstrate_self_awareness_of_personal_and_professional_limits_and_know_when_to_seek_professional_advice_assistance_and_support",
             "Prof Skills Independent Practice Ask for advice and support" = "ask_for_advice_and_support_from_their_colleagues",
             "Prof Skills Independent Practice Manage where information is incomplete" = "demonstrate_ability_to_manage_in_situations_where_information_is_incomplete_deal_with_contingencies_and_adapt_to_change",
             "Prof Skills Independent Practice Discuss euthanasia sensitively" = "discuss_euthanasia_with_clients_whilst_showing_sensitivity_and_empathy",
             "Prof Skills Independent Practice Work Effectively interprofessionally" = "work_effectively_as_a_member_of_a_professional_inter_professional_team_fully_recognising_the_contribution_of_each_professional_and_demonstrate_an_understanding_of_cognitive_diversity",
             "Prof Skills Undertaking unfamiliar procedures" = "to_undertake_unfamiliar_procedures",
             "Prof Skills Time management" = "to_manage_their_time",
             "Prof Skills Ask for help and support" = "to_ask_for_help_and_support_from_peers_and_colleagues",
             "Prof Skills Dealing with unknowns" = "a_number_of_the_cases_they_come_across_will_only_have_limited_information_available_how_prepared_were_they_to_make_decisions_when_there_is_a_degree_of_unknown_information",
             "Prof Skills Manage stressful situations" = "to_manage_stressful_situations",
             "Prof Skills Appropriately manage their emotions" = "to_appropriately_manage_their_emotions_during_client_interactions",
             "Prof Skills Consider economic factors" = "in_many_cases_there_needs_to_be_a_significant_economic_consideration_to_the_level_of_treatment_that_can_be_provided_to_a_patient_that_reflects_the_financial_circumstances_of_the_client"
      ) %>% 
      select(-c("please_select_the_vet_school_from_which_they_graduated",
                "other_2",
                "other_6",
                "other_8",
                "strengths",
                "areas_for_improvement"  )) %>% 
      mutate(grp = "Adviser")
    
  })
  
  
  
  

  # -------------------- Produce combined data
  
  

  
  
   adgrad <- reactive ({
     

    ad() %>% 
      select(-c("Adviser Gender":"Adviser Position")) %>% 
      rbind(grad() %>% 
              select(-c("Grad Gender":"Grad Confidence First Start"))) %>% 
      as.data.frame()
    
    

   })
   
  
  
   
   
   # ---------------- Likert time
   
   
   output$l_hist <- renderPlot({
     
     l_hist <- likert(items = adgrad()[,1:9], grouping = adgrad()[,120])
     plot(l_hist)
     
   })
   
   
    
    output$l_exams <- renderPlot({
      l_exams <- likert(items = adgrad()[,10:18], grouping = adgrad()[,120])
      plot(l_exams)
    })
    
    output$l_prioritise_ddx <- renderPlot({
      l_prioritise_ddx <- likert(items = adgrad()[,19:27], grouping = adgrad()[,120])
      plot(l_prioritise_ddx)
      
    })
    
    
    output$l_tx_planning <- renderPlot({
      l_tx_planning <- likert(items = adgrad()[,28:36], grouping = adgrad()[,120])
      plot(l_tx_planning)
    })
    
    
    output$l_emergencies <- renderPlot({
      l_emergencies <- likert(items = adgrad()[,37:42], grouping = adgrad()[,120])
      plot(l_emergencies)
    })
    
    output$l_surg_preop <- renderPlot({
      l_surg_preop <- likert(items = adgrad()[,43:51], grouping = adgrad()[,120])
      plot(l_surg_preop)
    })
    
    output$l_surg_surg <- renderPlot({
      l_surg_surg <- likert(items = adgrad()[,52:60], grouping = adgrad()[,120])
      plot(l_surg_surg)
    })
    
    output$l_surg_postop <- renderPlot({
      l_surg_postop <- likert(items = adgrad()[,61:69], grouping = adgrad()[,120])
      plot(l_surg_postop)
    })
    
    output$l_anaesthesia <- renderPlot({
      l_anaesthesia <- likert(items = adgrad()[,70:78], grouping = adgrad()[,120])
      plot(l_anaesthesia)
    })
    
    output$l_pm <- renderPlot({
      l_pm <- likert(items =adgrad()[,79:81], grouping = adgrad()[,120])
      plot(l_pm)
    })
    
    output$l_healthcareplans <- renderPlot({
      l_healthcareplans <- likert(items = adgrad()[,82:93], grouping = adgrad()[,120])
      plot(l_healthcareplans)
    })
    
    output$l_epi <- renderPlot({
      l_epi <- likert(items = adgrad()[,94:102], grouping = adgrad()[,120])
      plot(l_epi)
    })
    
    output$l_handling <- renderPlot({
      l_handling <-likert(items = adgrad()[,103:105], grouping = adgrad()[,120])
      plot(l_handling)
    })
    
    output$l_evidence <- renderPlot({
      
      l_evidence <- likert(items = adgrad()[,106, drop = FALSE], grouping = adgrad()[,120])
      plot(l_evidence)
 })
    
    output$l_profskills <- renderPlot({
      
      l_profskills <- likert(items = adgrad()[,107:112], grouping = adgrad()[,120])
      plot(l_profskills)
    })
    
    output$l_preparation <- renderPlot({
      l_preparation <- likert(items = adgrad()[,113:119], grouping = adgrad()[,120])
      plot(l_preparation)
      
    })
  
   
   # ------------------ Tables
   
   output$t1_nadgrad <- renderTable({
     
     adgrad() %>%
       group_by(grp) %>% 
       tally() %>% 
       rename("Group" = grp,
              "Number" = n)

   })
   
   
   output$t2_adarea <- renderTable({
     
     factor_sum(ad()$`Adviser Area`) %>% 
       rename("Adviser Area" = factor_name,
              "Frequency" = Freq,
              "Percentage" = Perc) %>% 
       arrange(Percentage)
     
   })
   
   
   output$t3_gradarea <- renderTable({
     
     factor_sum(grad()$`Grad First Role`) %>% 
       rename("Adviser Area" = factor_name,
              "Frequency" = Freq,
              "Percentage" = Perc) %>% 
       arrange(Percentage)
     
   })
   
   output$t4_adgradna <- renderTable({
     adgrad() %>% 
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
   
   
   output$t5_gradgend <- renderTable({
     
     factor_sum(grad()$`Grad Gender`)  %>% 
       rename("Graduate Gender" = factor_name,
              "Frequency" = Freq,
              "Percentage" = Perc) 
     
   })
   
   
   output$t6_gradage <- renderTable({
     
     factor_sum(grad()$`Grad Age`) %>% 
       rename("Graduate Age" = factor_name,
              "Frequency" = Freq,
              "Percentage" = Perc)
     
   })
   
   output$t7_gradeth <- renderTable({
     
     factor_sum(grad()$`Grad Ethnicity`) %>% 
       rename("Graduate Ethnicity" = factor_name,
              "Frequency" = Freq,
              "Percentage" = Perc)
   })
   
   
   output$t8_graddis <- renderTable({
     
     factor_sum(grad()$`Grad Disability`) %>% 
       rename("Graduate disability status" = factor_name,
              "Frequency" = Freq,
              "Percentage" = Perc)
   })
   
   
   output$t9_adage <- renderTable({
     
     factor_sum(ad()$`Adviser Age`) %>% 
       rename("Adviser Age" = factor_name,
              "Frequency" = Freq,
              "Percentage" = Perc)
   })
   
   
   output$t10_adgend <- renderTable({
     
     factor_sum(ad()$`Adviser Gender`) %>% 
       rename("Adviser Gender" = factor_name,
              "Frequency" = Freq,
              "Percentage" = Perc)
   })
   
   output$t11_adpos <- renderTable({
     
     factor_sum(ad()$`Adviser Position`) %>% 
       rename("Adviser Position" = factor_name,
              "Frequency" = Freq,
              "Percentage" = Perc)
     
   })
  
  # ---------- Plots
  
  output$p1_gradconf <- renderPlot({
    
    grad() %>%
      ggplot(aes(x = `Grad Confidence First Start`, fill = `Grad First Role`)) +
      geom_bar() +
      theme_classic() +
      scale_x_continuous(breaks = seq(1, 5, 1), limits = c(0,5.5)) +
      labs(y = "Count of Graduates")
    
    
  })

  #----------------- Report Download
  
  output$report <- downloadHandler(
    filename =  "vetGDPreport.docx",
    content = function(file) {
      tempReport <- file.path(tempdir(), "OutputReport.RMD")
      file.copy("OutputReport.RMD", tempReport, overwrite = TRUE)
      params <- list(ad = ad(),
                     grad = grad(),
                     adgrad = adgrad())
      rmarkdown::render(tempReport, output_file = file,
                        params = params,
                        envir = new.env(parent = globalenv())
      )
    }
  )
  
  
  
  
  
  
  # ===== Close app brackets beneath this line
  
})