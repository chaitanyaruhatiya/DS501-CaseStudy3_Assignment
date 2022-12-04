################
###Chaitanya Ruhatiya
###DS-501 Fall 2022 Case Study-3
###############

library(shiny)
library(dplyr)
library(ggplot2)
library(tidyverse)
library(DT)
library(corrplot)
library(caret)
library(DataExplorer)
library(Metrics)

shinyServer(function(input, output, session) {
  
  ##Getting the main dataset 
  inputdata_feed <- reactive({
    GTdata 
  })
  
  ##Getting the names of variables and printing as variable names for target selection
  observe({
    colvar_names <- names(inputdata_feed())
    updateSelectInput(session = session, inputId = "TargetVar", choices = colvar_names)})
  
  ##spliting dataset into training and testing data
  splitdata <- reactive({input$Slider})
  
  ##Data stats and correlations
  output$data_stat <- renderPrint(summary(inputdata_feed()))
  
  correlation_table <- reactive({
    round(cor(inputdata_feed()), 1)
  })
  output$Corr_matx <-renderPlot(corrplot(correlation_table(), method = 'circle', type = 'lower', insig='blank',
                                    addCoef.col ='black', number.cex = 0.8, order = 'AOE', diag=FALSE))
  
  ##Multivariate Regression Model
  set.seed(2500) 
  
  train_id <-
    reactive({sample(1:nrow(inputdata_feed()), (splitdata()/100) * nrow(inputdata_feed()))
    })
  train_data <- reactive({
    tmp_trd <- inputdata_feed()
    tmp_trd[train_id(), ]
  })
  test_data <- reactive({
    tmp_ted <- inputdata_feed()
    tmp_ted[-train_id(),]
  })
  
  regression_var <- reactive({
    as.formula(paste(input$TargetVar, "~."))
  })
  
  MV_Model <- reactive({
    lm(regression_var(), data = train_data())
  })
  
  imp_comp <- reactive({
    var <- as.data.frame(varImp(MV_Model(), scale = TRUE))
    var <- data.frame(overall = var$Overall,
                    names   = rownames(var))
    var[order(var$overall, decreasing = T),]
  })
  
  output$details <- renderPrint(summary(MV_Model()))
  output$coeff <- renderPrint(MV_Model())
  output$imp_comp <- renderPrint(imp_comp())
  
  target_predict_value <- reactive({
    predict(MV_Model(), test_data())
  })
  
  tmpactualtest <- reactive({
    tmptest <- test_data()
    tmptest[, c(input$TargetVar)]
  })
  
  apframe <-reactive({data.frame(cbind(AV = tmpactualtest(), PV = target_predict_value()))})
  
  AP_plot <- reactive({ggplot(apframe(), aes_string(x = apframe()$AV, y = apframe()$PV)) + 
                    geom_point()+ xlab("Actual Data")+ylab("Predicted Data")+ggtitle("Testing Model Prediction")+
                    geom_smooth(method = lm, formula = y ~ x)+
                    theme(
                      plot.title = element_text(size=16, face= "bold", color="#993333"),
                      axis.title.x = element_text(size = 14, color="#993333", face = "bold"),
                      axis.title.y = element_text(size = 14, color="#993333", face = "bold"),
                      axis.line = element_line(colour = "darkblue", 
                                               size = 1, linetype = "solid"),
                      axis.text.x = element_text(face="bold", color="#993333", 
                                                 size=12),
                      axis.text.y = element_text(face="bold", color="#993333", 
                                                 size=12)
                      )
    })
  
  output$multivariate <- renderPlot(AP_plot())

  output$rmse <-
    renderText(paste("RMSE value:", round(rmse(apframe()$AV,apframe()$PV), 3))
               )
  output$sse <-
    renderText(paste("SSE value:", round(sse(apframe()$AV,apframe()$PV), 3))
    )
  output$rse <-
    renderText(paste("RSE value:", round(rse(apframe()$AV,apframe()$PV), 3))
    )
  output$f1 <-
    renderText(paste("F1 score:", round(f1(apframe()$AV,apframe()$PV), 3))
    )
  output$bias <-
    renderText(paste("Bias value:", round(bias(apframe()$AV,apframe()$PV), 3))
    )
  output$num_traindata <-
    renderText(paste("Train data:", NROW(train_data()), "instances")
    )
  output$num_testdata <-
    renderText(paste("Test data:", NROW(test_data()), "instances")
    )
  
  output$evaluation <- renderPlot({
    par(mfrow = c(2, 2))
    plot(MV_Model())
  })
  
  ##Simple Linear Regression
  selected_vars <- reactive({
    GTdata[, c(input$x_var, input$y_var)]
  })
  
  output$slr <- renderPlot({
    ggplot(GTdata, aes_string(x = input$x_var, y = input$y_var, color=GTdata$TEY)) + 
      geom_point()+
      geom_smooth(method = lm, formula = y ~ x)+ labs(color = "TEY (MWh)")+
      theme(
        plot.title = element_text(size=16, face= "bold", colour= "black"), 
        axis.title.x = element_text(size = 14, face = "bold", color="#993333"),
        axis.title.y = element_text(size = 14, face = "bold", color="#993333"),
        legend.title=element_text(size=10, face = "bold"),
        axis.line = element_line(colour = "darkblue", 
                                 size = 1, linetype = "solid"),
        axis.text.x = element_text(face="bold", color="#993333", 
                                   size=12),
        axis.text.y = element_text(face="bold", color="#993333", 
                                   size=12)
        )
  })
  
  output$reg_values <- renderUI({
    fit <- lm(get(input$x_var) ~ get(input$y_var), data = selected_vars())
    withMathJax(
      paste0(
        "Adjusted \\( R^2 = \\) ", round(summary(fit)$adj.r.squared, 3),
        ", \\( \\beta_0 = \\) ", round(fit$coef[[1]], 3),
        ", and \\( \\beta_1 = \\) ", round(fit$coef[[2]], 3)
      )
    )
  })
  
})