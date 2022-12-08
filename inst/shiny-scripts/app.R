# Taken from
# Grolemund, G. (2015). Learn Shiny - Video Tutorials.
# URL:https://shiny.rstudio.com/tutorial/

library(shiny)

# Define UI for app that draws a plot.
ui <- fluidPage(

  # App title.
  titlePanel("EVEP: Evaluation of Variant Effect Prediction"),
  sidebarLayout(
    sidebarPanel(
      checkboxInput("useSampleData", "Use Sample Data", TRUE),
      p("For the csv file uploaded, there should be 4 columns:"),
      p("sizes of training data"),
      p("predicted values for non-augmented dataset"),
      p("predicted values for augmented dataset"),
      p("actual values to predict"),
      # Taken from https://shiny.rstudio.com/reference/shiny/latest/fileinput.
      fileInput("infile", "Upload CSV File: ", accept = ".csv")
    ),
    mainPanel(
      plotOutput(outputId = "plot_pearson"),
      plotOutput(outputId = "plot_mse")
    )
  )
)

server <- function(input, output) {
  output$plot_pearson <- renderPlot({
    if (input$useSampleData){
      vep <- EVEP::generateRandomData()
    }
    else{
      infile <- input$infile
      vep <- read.csv(infile$datapath)
    }
    EVEP::visualizeEvaluation(vep)
  })
  output$plot_mse <- renderPlot({
    if (input$useSampleData){
      vep <- EVEP::generateRandomData()
    }
    else{
      infile <- input$infile
      vep <- read.csv(infile$datapath)
    }
    EVEP::visualizeEvaluation(vep,
                              stats = "mse",
                              label = "mean_squared_error",
                              fnc_stats = NA)
  })
}

shiny::shinyApp(ui = ui, server = server)

# [END]
