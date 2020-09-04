library(shiny)
library(shinythemes)
library(shinyFeedback)
library(shinyjs)
library(readxl)

data=read_excel('imp.xlsx')
sub_model=unique(data$OLD_CAR_SUB_MODEL)
car_mod=unique(data$OLD_CAR_MODEL)
fuel<-unique(data$Fuel_Type)
em<-unique(data$EMISSION)

shinyUI(fluidPage (theme=shinytheme("slate"),
                   
                   shinyFeedback::useShinyFeedback(),
                   #titlePanel(title=(h2("PRICE PREDICTOR",align="center",style="bold")),windowTitle = "PRICE PREDICTOR"),
                   hr(),
                   
                   sidebarLayout(
                     sidebarPanel(
                       
                       (h3("DETAILS ABOUT THE CAR")),
                       hr(),
                       useShinyjs(),
                       div(id="form",
                           selectInput("carmod",label = "CAR MODEL",choices = car_mod,selected = " ",selectize = TRUE),
                           
                           selectInput('sub','SUB MODEL',choices = sub_model),
                           
                           selectInput("ftype","FUEL TYPE",choices = fuel),
                           
                           
                           selectInput("etype","EMISSION TYPE",choices =em),
                           
                           
                           numericInput("kl","TOTAL KILOMETER",min = 0,max=200000,value = NA),
                           
                           sliderInput("now","NUMBER OF OWNERS",min = 1,max=9,value = NA),
                           
                           #numericInput("now","NUMBER OF OWNERS",min = 1,max = 5,value = NA),
                    
                           
                           numericInput("ym","YEAR OF MANUFACTURE",min = 1990,max =2020 ,value = NA),
                           
                           
                           
                       ),
                       actionButton("go","PREDICT",class='btn-success',width = "100%")
                       #actionBttn("go","PREDICT",style = "gradient",color = "success",size = "lg")
                     ),
                     
                     mainPanel(
                       br(),
                       textOutput("valid"),
                       
                       fluidRow(
                         column(width=10,img(src="md.jpg",width="auto",height=300))
                       ),
                       
                       br(),
                       
                       fluidRow(
                         column(width=10,tableOutput("all")),
                         column(width=6,verbatimTextOutput("mo",placeholder = FALSE)),
                         column(width=5,verbatimTextOutput("pr",placeholder = FALSE))
                       )
                       
                       
                     )
                   )
)

)
