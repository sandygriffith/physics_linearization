###########################
#### TO DO ################
# populate first row with NULL rather than 0 
# for no transformation, constrain x and y limits to same as raw data for comparison
# produce error when no units/name provided
# must select no transformation before model graph is created
# print out very small numbers for slopes into scientific notation rather than rounded

library(shiny)
library(shinyIncubator)

# initialize data with 2 cols and generic colnames
df1 <- data.frame(matrix(c("0","0"), 1, 2))
colnames(df1) <- c("x", "y")

shinyUI(pageWithSidebar(
  headerPanel('Physics Linearization Web App'),
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
      h4("Data Table"),      
      matrixInput(inputId = 'data', label = 'Add/Remove Rows', data = df1), 
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
    tabsetPanel(
      tabPanel("Raw Data", plotOutput(outputId='plot'),
               downloadButton('downloadRawPlot', 'Download Plot')), 
      tabPanel("Model", plotOutput(outputId='lm_plot'),
               verbatimTextOutput(outputId = "line_eqn"),
               downloadButton('downloadPlot', 'Download Plot'))
    )
  )
))
