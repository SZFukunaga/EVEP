#' Launch Shiny App for EVEP
#'
#' A function that launches the Shiny app for EVEP
#' The code has been placed in \code{./inst/shiny-scripts}.
#'
#' @return No return value but open up a Shiny page.
#'
#' @examples
#' \dontrun{
#'
#' EVEP::runEVEP()
#' }
#'
#' @references
#' Grolemund, G. (2015). Learn Shiny - Video Tutorials. \href{https://shiny.rstudio.com/tutorial/}{Link}
#'
#' @export
#' @importFrom shiny runApp

runEVEP <- function() {
  appDir <- system.file("shiny-scripts",
                        package = "EVEP")
  shiny::runApp(appDir, display.mode = "normal")
  return()
}
# [END]
