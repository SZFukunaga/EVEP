#' Visualize VEP Evaluation
#'
#' A function to visualize the relationships between accuracy of VEP and
#' training data size, or and data augmentation.
#'
#' @param vep A dataframe with training data to be evaluated.The first column
#' should be data sizes, the second and third are predicted values for
#' non-augmented and augmented training data. The last one should be actual
#' values the model is predicting.
#'
#' @param stats A statistical measure to calculate. This has to be either
#' "pearson", "kenall" or "mse". "pearson" is set as a default.
#'
#' @param label A label for the statistical measure. Used as a column name of
#' returned dataframe.
#'
#' @param fnc_stats A function to conduct user-defined statistical analysis. The
#' first argument should be a dataframe to analyse, with their data size the
#' same. The second one is method, which does not have to be involved, just for
#' consistency. The thrid argument should be the data size given in the first
#' argument, and the last argument is label, which is the same as the parameter
#' above. If the parameter stats is given, fnc_stats should be NA.
#'
#' @return Returns NA, as the graph is shown by this function.
#'
#' @examples
#' # Example 1:
#' # Visualize the evaluation of VEP with pearson correlation.
#' # sample_random_data.csv is used as a training dataset.
#'
#' df_random_data <- generateRandomData()
#' visualizeEvaluation(df_random_data)
#'
#' # Example 2:
#' # Visualize the evaluation of VEP with mean squared error.
#' # sample_random_data.csv is used as a training dataset.
#'
#' df_random_data <- generateRandomData()
#' visualizeEvaluation(df_random_data,
#'                       stats = "mse",
#'                       label = "mean_squared_error",
#'                       fnc_stats = NA)
#'
#' @references
#' Bonnet, D.G., Wright, T.A., (2000) Sample size requirements for estimating
#' pearson, kendall and spearman correlations. *Psychometrika* 65, 23–28.
#' <https://doi.org/10.1007/BF02294183>
#'
#' @export
#' @import stats graphics utils

visualizeEvaluation <- function(vep,
                                stats = "pearson",
                                label = "pearson correlation",
                                fnc_stats = NA){

  # Obtain statistical measures with evaluateVEP().
  df_evaluation <- evaluateVEP(vep, stats, label, fnc_stats)
  # Plot non-augmented VEP.
  plot(df_evaluation$data_size,
       df_evaluation[, 2],
       xlab = "training data size",
       ylab = label,
       pch = 19)
  # Plot augmented VEP.
  points(df_evaluation$data_size, df_evaluation[, 3], col="red", pch = 19)
  # Add legend and title.
  if (stats == "mse"){
    loc_legend <- "topright"
  }
  else{
    loc_legend <- "bottomright"
  }
  legend(loc_legend,
         legend = c("Not Augmented", "Augmented"),
         col = c("black", "red"),
         pch = 19)
  title("Evaluation of Agumentation on VEP")
  return(NA)
}

# [END]
