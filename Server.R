library(shiny)
library(readxl)
library(dplyr)

data=read_excel('imp.xlsx')
shinyServer(
  function(input,output,session){
    
    observeEvent(input$carmod,{
      sub=select(filter(data,OLD_CAR_MODEL==input$carmod),OLD_CAR_SUB_MODEL)
      updateSelectInput(session,'sub',choices =unique(sub))
    })
    
    observeEvent(input$sub,{
      ft=select(filter(data,OLD_CAR_SUB_MODEL==input$sub),Fuel_Type)
      updateSelectInput(session,'ftype',choices = ft)
    })
    
    observeEvent(input$sub,{
      em=select(filter(data,OLD_CAR_SUB_MODEL==input$sub),EMISSION)
      updateSelectInput(session,'etype',choices = em)
    })
    
    values<-reactiveValues()
    
    observeEvent(input$go,{
      
      validate(
        need(input$carmod,message = FALSE))
      
      validate(
        need(input$sub,message = FALSE)
      )
      
      validate(
        need(input$ftype,message = FALSE))
      
      validate(
        need(input$etype,message = FALSE))
      
      validate(
        need(input$kl,message = FALSE))
      
      validate(
        need(input$now,message = FALSE))
      
      validate(
        need(input$ym,message = FALSE))
      
      req(input$kl)
      
      feedbackDanger("kl",
                     condition=(input$kl<=0|input$kl>=500000),"INVALID INPUT")
      
      req(!is.na(input$kl),input$kl>0&&input$kl<500000)
      values$nkl<-input$kl
      
      req(input$now)
      
      feedbackDanger("now",
                     condition=(input$now<=0|input$now>=10),"INVALID INPUT")
      
      req(!is.na(input$now),input$now>0&&input$now<10)
      values$nnow<-input$now
      
      req(input$ym)
      
      d<-as.integer(format(Sys.Date(),"%Y"))
      
      feedbackDanger("ym",
                     condition=(input$ym<=0|input$ym>=d|input$ym<1990),"INVALID INPUT")
      
      req(!is.na(input$ym),input$ym<=d&&input$ym>0&&input$ym>=1990)
      values$nym<-input$ym
      
      reset("form")
      
      carmodel<-as.factor(input$carmod)
      submodel<-as.factor(input$sub)
      fuel<-as.factor(input$ftype)
      emtype<-as.factor(input$etype)
      tk<-as.integer(values$nkl)
      now<-as.integer(values$nnow)
      yom<-as.integer(values$nym)
      
      view<-data.frame("CAR_MODEL"=carmodel,
                       "SUB_MODEL"=submodel,
                       "FUEL_TYPE"=fuel,
                       "EMMISSION"=emtype,
                       "MILEAGE"=tk,
                       "NO_OF_OWNERS"=now,
                       "YOW"=yom)
      
      
      Ttk<-sqrt(tk)
      Tnow<-(now)
      Tyom<-(yom)
      
      testd<-data.frame("OLD_CAR_MODEL"=carmodel,OLD_CAR_SUB_MODEL=submodel,"Fuel_Type"=fuel,
                        "EMISSION"=emtype,"MILEAGE"=Ttk,
                        "NO_OF_OWNERS"=Tnow,"YOM"=Tyom)
      
      output$all<-renderTable(view) 
      
      getmodel<-readRDS("./model.rds")
      PRICE<-predict(getmodel,testd)
      PRICE<-as.integer(round(PRICE^2))
      output$mo<-renderText({paste("CAR MODEL:",submodel)})
      output$pr<-renderText({paste("PREDICTED PRICE:",PRICE)})
      view$PRICE<-PRICE
      
    })
    
    
  }
)

