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
    #     if(input$savePlot) {
    #       ggsave(name, p, type="cairo-png")
    #     }
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
    #     if(input$savePlot) {
    #       ggsave(name, p, type="cairo-png")
    #     }
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





# # We tweak the "am" field to have nicer factor labels. Since this doesn't
# # rely on any user inputs we can do this once at startup and then use the
# # value throughout the lifetime of the application
# mpgData <- mtcars
# mpgData$am <- factor(mpgData$am, labels = c("Automatic", "Manual"))
# 
# # Define server logic required to plot various variables against mpg
# shinyServer(function(input, output) {
#   
#   # Compute the forumla text in a reactive expression since it is 
#   # shared by the output$caption and output$mpgPlot expressions
#   formulaText <- reactive({
#     paste("mpg ~", input$variable)
#   })
#   
#   # Return the formula text for printing as a caption
#   output$caption <- renderText({
#     formulaText()
#   })
#   
#   # Generate a plot of the requested variable against mpg and only 
#   # include outliers if requested
#   output$mpgPlot <- renderPlot({
#    # boxplot(as.formula(formulaText()), 
#     #        data = mpgData,
#     #        outline = input$outliers)
#     qplot(input$variable, mpgData$mpg)
#   })
# })


# # server.R
# 
# shinyServer(
#   function(input, output) {
#     # table of outputs
#     output$table.output <- renderTable(
# { res <- matrix(apply(input$data,1,prod))
#   res <- do.call(cbind, list(input$data, res))
#   colnames(res) <- c("Input 1","Input 2","Product")
#   res
# }
# , include.rownames = FALSE
# , include.colnames = TRUE
# , align = "cccc"
# , digits = 2
# , sanitize.text.function = function(x) x      
#     )  
#     
#     ### Output xy-scatterplot
# #    output$xyPlot <- renderPlot({
# #       plot(seq(1, maxYears, 1), rep(0, maxYears), type = "n",
# #            lwd = 2, xlim = c(0, maxYears), ylim = c(0, maxHits),
# #            xlab = "Year", ylab = "Hits")
# #       segments(x0 = -100, x1 = 1000, y0 = 3000, y1 = 3000, lty = 2, lwd = 2,
# #                col = "black")
# #       for(i in 1:length(mHitsCumSum)){
# #         lines(seq(1, length(mHitsCumSum[[i]]), 1), mHitsCumSum[[i]], lwd = 2,
# #               col = "grey70")
# #       }
# #       lines(seq(1, length(currentMemberHits()), 1), currentMemberHits(), lwd = 2, 
# #             col = "magenta")
# #       lines(seq(1, length(currentPlayerHits()), 1), currentPlayerHits(), lwd = 2, 
# #             col = "blue")
# #      plot(res[,1], res[,2])
# #      })    
#     
#   }
# )