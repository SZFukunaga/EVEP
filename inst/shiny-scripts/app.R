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
    infile <- input$infile
    EVEP::visualizeEvaluation(infile$datapath)
  })
  output$plot_mse <- renderPlot({
    infile <- input$infile
    EVEP::visualizeEvaluation(infile$datapath, stats = "mse",
                              label = "mean_squared_error",
                              fnc_stats = NA)
  })
}

shiny::shinyApp(ui = ui, server = server)

# [END]
