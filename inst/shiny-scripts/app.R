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
      plotOutput(outputId = "plot")
    )
  )
)

server <- function(input, output) {
  output$plot <- renderPlot({
    infile <- input$infile
    EVEP::visualizeEvaluation(infile$datapath)
  })
}

shiny::shinyApp(ui = ui, server = server)

# [END]
