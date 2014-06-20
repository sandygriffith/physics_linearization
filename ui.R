###########################
#### TO DO ################
# start with 10 blank rows (difficult)
# finalize name
# populate first row with NULL rather than 0 (difficult)
# saving 
# print out line equation on graph
# figure out how to save locally or email when hosted on server 
#(probably use http://rstudio.github.io/shiny/tutorial/#sending-images)
# make points bigger (changing line width in current state, probably not important)
# for no transformation, constrain x and y limits to same as raw data for comparison (?)
# produce error when no units/name provided
# must select no transformation before model graph is created
# print out very small numbers for slopes into scientific rather than rounded


library(shiny)
library(shinyIncubator)

# initialize data with 2 cols and generic colnames
df1 <- data.frame(matrix(c("0","0"), 1, 2))
colnames(df1) <- c("x", "y")

shinyUI(pageWithSidebar(
  headerPanel('Physics Linearization Web App'),
  #   sidebarPanel(
  #     matrixInput('data', label = 'Add/Remove Rows', data = df1),
  #     textInput('filename', "Filename"),
  #     checkboxInput('savePlot', "Check to save"),
  #     textInput('student_name', "Student Name")
  #     
  #   ),
  sidebarPanel(
    
    # customize display settings    
    tags$head(
      tags$style(type='text/css'
                 , "table.data { width: 300px; }"
                 , ".well {width: 80%; background-color: NULL; border: 0px solid rgb(255, 255, 255); box-shadow: 0px 0px 0px rgb(255, 255, 255) inset;}"
                 , ".tableinput .hide {display: table-header-group; color: black; align-items: center; text-align: center; align-self: center;}"
                 , ".tableinput-container {width: 100%; text-align: center;}"
                 , ".tableinput-buttons {margin: 10px;}"
                 , ".data {background-color: rgb(255,255,255);}"
                 , ".table th, .table td {text-align: center;}"
                 
      )
    )
    ,
    wellPanel(
      h4("Data Table")
      ,      
      matrixInput(inputId = 'data', label = 'Add/Remove Rows', data = df1)
      , 
      textInput('title', "Title*"),
      textInput('student_name', "Student Name*"),
      textInput('var1_label', "x label*"),
      textInput('var1_unit', "x units*"),
      textInput('var2_label', "y label*"),
      textInput('var2_unit', "y units*"),  
      checkboxInput('origin', "Force through origin"),
      selectInput("xtransform", "Choose a transformation for x:", 
                  choices = c("--", "none", "log", "sqrt", 
                              "reciprocal", "square")),
      selectInput("ytransform", "Choose a transformation for y:", 
                  choices = c("--", "none", "log", "sqrt", 
                              "reciprocal", "square")),
      helpText("Fields marked with * are required.")
    )
  ),
  mainPanel(
    #plotOutput(outputId='plot')
    tabsetPanel(
      tabPanel("Raw Data", plotOutput(outputId='plot'),
               downloadButton('downloadRawPlot', 'Download Plot')), 
      tabPanel("Model", plotOutput(outputId='lm_plot'),
               verbatimTextOutput(outputId = "line_eqn"),
               downloadButton('downloadPlot', 'Download Plot'))
    )
  )
))


# library(shiny)
# 
# # Define UI for miles per gallon application
# shinyUI(pageWithSidebar(
#   
#   # Application title
#   headerPanel("Miles Per Gallon"),
#   
#   # Sidebar with controls to select the variable to plot against mpg
#   # and to specify whether outliers should be included
#   sidebarPanel(
#     selectInput("variable", "Variable:",
#                 list("Cylinders" = "cyl", 
#                      "Transmission" = "am", 
#                      "Gears" = "gear")),
#     
#     checkboxInput("outliers", "Show outliers", FALSE)
#   ),
#   
#   # Show the caption and plot of the requested variable against mpg
#   mainPanel(
#     h3(textOutput("caption")),
#     
#     plotOutput("mpgPlot")
#   )
# ))
# 
# 
# # # ui.R
# # 
# # library("shiny")
# # #library('devtools')
# # #install_github('shiny-incubator', 'rstudio')
# # library("shinyIncubator")
# # 
# # # initialize data with colnames
# # df <- data.frame(matrix(c("0","0"), 1, 2))
# # colnames(df) <- c("Input1", "Input2")
# # 
# # shinyUI(
# #   pageWithSidebar(
# #     
# #     headerPanel('Simple matrixInput example')
# #     ,
# #     sidebarPanel(
# #       
# #       # customize display settings    
# #       tags$head(
# #         tags$style(type='text/css'
# #                    , "table.data { width: 300px; }"
# #                    , ".well {width: 80%; background-color: NULL; border: 0px solid rgb(255, 255, 255); box-shadow: 0px 0px 0px rgb(255, 255, 255) inset;}"
# #                    , ".tableinput .hide {display: table-header-group; color: black; align-items: center; text-align: center; align-self: center;}"
# #                    , ".tableinput-container {width: 100%; text-align: center;}"
# #                    , ".tableinput-buttons {margin: 10px;}"
# #                    , ".data {background-color: rgb(255,255,255);}"
# #                    , ".table th, .table td {text-align: center;}"
# #                    
# #         )
# #       )
# #       ,
# #       wellPanel(
# #         h4("Input Table")
# #         ,      
# #         matrixInput(inputId = 'data', label = 'Add/Remove Rows', data = df)
# #         , 
# #         helpText("This table accepts user input into each cell. The number of rows may be controlled by pressing the +/- buttons.")
# #       )
# #     )
# #     ,
# #     mainPanel(
# #     #  wellPanel(
# #     #    wellPanel(
# #           #h4("Output Table")
# #           ,
# #           #tableOutput(outputId = 'table.output')
# #           ,
# #           #helpText("This table displays the input matrix together with the product of the rows of the input matrix")
# # #          plotOutput("xyPlot")
# #      #   )
# #     #  )
# #     )
# #   )
# # )