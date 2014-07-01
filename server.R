library(shiny)
library(ggplot2)
theme_set(theme_bw())


shinyServer(function(input, output) {
  newdata <- reactive({
    #transform the data in a reactive conductor which can be used for multiple outputs without re-evaluating
    #for each
    df <- data.frame(input$data) #must convert to df for ggplot
    x <- df[,1]
    y <- df[,2]    
    if(input$ytransform == "square") {
      y <- y^2
    }
    if(input$ytransform == "sqrt") {
      y <- sqrt(y)
    }
    if(input$ytransform == "reciprocal") {
      y <- ifelse(y ==0, 0, 1/y)
    }
    if(input$ytransform == "log") {
      y <- ifelse(y ==0, 0, log(y))
    }
    if(input$xtransform == "square") {
      x <- x^2
    }
    if(input$xtransform == "sqrt") {
      x <- sqrt(x)
    }
    if(input$xtransform == "reciprocal") {
      x <- ifelse(x ==0, 0, 1/x)
    }
    if(input$xtransform == "log") {
      x <- ifelse(x ==0, 0, log(x))
    }
    data.frame(x,y) #data frame containing transformed data
  })
  output$plot <- renderPlot({
    df <- data.frame(input$data) #must convert to df for ggplot
    p <- qplot(df[,1], df[,2]) #+ opts(legend.position="none")
    p <- p + opts(title = paste(input$title, "  ", input$student_name)) #add student name to main title
    p <- p + xlab(paste(input$var1_label, " (", input$var1_unit, ")")) +
      ylab(paste(input$var2_label, " (", input$var2_unit, ")"))
    print(p) #must use print wrapper for ggplot objects
    
    name <- paste0(input$filename, "_rawdata_", input$student_name,
                   ".png")
  })
  output$lm_plot <- renderPlot({
    df <- newdata() 
    x <- df[,1]
    y <- df[,2]   
    p <- qplot(x,y) + stat_smooth(method = "lm") #+ opts(legend.position="none")
    if(input$origin) {
      p <- qplot(x,y) + stat_smooth(method="lm", formula = y ~ x - 1) 
    }
    p <- p + opts(title = paste(input$title, "  ", input$student_name
    )) #add student name to main title
    p <- p + xlab(paste(input$var1_label, " (", input$var1_unit, ")")) +
      ylab(paste(input$var2_label, " (", input$var2_unit, ")"))
    print(p) #must use print wrapper for ggplot objects
    
    name <- paste0(input$title, "_model_", input$student_name,
                   ".png")
  })
  output$line_eqn <- renderPrint({
    df <- newdata() 
    x <- df[,1]
    y <- df[,2]   
    m1 <- lm(y ~ x)
    if(input$origin) {
      m1 <- lm(y ~ x - 1)
      m1$coef["(Intercept)"] <- 0
    }
    xunits <- input$var1_unit
    yunits <- input$var2_unit
    if(input$ytransform == "square") {
      yunits <- paste(yunits, "^2", sep="")
    }
    if(input$ytransform == "sqrt") {
      yunits <- paste("sqrt(", yunits, ")", sep="")
    }
    if(input$ytransform == "reciprocal") {
      yunits <- paste(yunits, "^-1", sep="")
    }
    if(input$ytransform == "log") {
      yunits <- paste("ln(", yunits, ")", sep="")
    }
    if(input$xtransform == "square") {
      xunits <- paste(xunits, "^2", sep="")
    }
    if(input$xtransform == "sqrt") {
      xunits <- paste("sqrt(", xunits, ")", sep="")
    }
    if(input$xtransform == "reciprocal") {
      xunits <- paste(xunits, "^-1", sep="")
    }
    if(input$xtransform == "log") {
      xunits <- paste("ln(", xunits, ")", sep="")
    }
    cat( paste("Model Equation: y Intercept = ", 
               round(as.numeric(m1$coef["(Intercept)"]), 4 ), " ",
               yunits,
               ", Slope = ", round(as.numeric(m1$coef["x"]),4), " ",
               yunits, "/", xunits,
               sep="")
    )
  })
  output$downloadRawPlot <- downloadHandler(
    filename = function() { paste0(input$title, "_raw_", input$student_name,
                                   ".png") },
    content = function(file) {
      df <- newdata() 
      p <- qplot(df[,1], df[,2]) #+ opts(legend.position="none")
      p <- p + opts(title = paste(input$title, "  ", input$student_name)) #add student name to main title
      p <- p + xlab(paste(input$var1_label, " (", input$var1_unit, ")")) +
        ylab(paste(input$var2_label, " (", input$var2_unit, ")"))
      png(file)
      print(p)
      dev.off()
    })
  output$downloadPlot <- downloadHandler(
    filename = function() { paste0(input$title, "_model_", input$student_name,
                                   ".png") },
    content = function(file) {
      df <- newdata() 
      x <- df[,1]
      y <- df[,2]   
      p <- qplot(x,y) + stat_smooth(method = "lm") #+ opts(legend.position="none")
      if(input$origin) {
        p <- qplot(x,y) + stat_smooth(method="lm", formula = y ~ x - 1) 
      }
      p <- p + opts(title = paste(input$title, "  ", input$student_name)) #add student name to main title
      p <- p + xlab(paste(input$var1_label, " (", input$var1_unit, ")")) +
        ylab(paste(input$var2_label, " (", input$var2_unit, ")"))
      png(file)
      print(p)
      dev.off()
    })
})
