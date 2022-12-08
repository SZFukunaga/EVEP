#' Evaluates VEP with Statistical Measure
#'
#' A function to calculate a given statistical measure with a training data for
#' variant effect prediction (VEP).
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
#' @return Returns a dataframe with three columns. The first one is the size of
#' training data, the second and the third columns are statistical measures for
#' non-augmented or augmented VEP respectively. Each row represents VEP trial.
#'
#' @examples
#' # Example 1:
#' # Evaluate VEP with pearson correlation. sample_random_data.csv is used as a
#' # training dataset.
#'
#' df_random_data <- generateRandomData()
#' pearsonVEP <- evaluateVEP(df_random_data)
#' pearsonVEP
#'
#' # Example 2:
#' # Evaluate VEP with mean squared error.sample_random_data.csv is used as a
#' # training dataset.
#'
#' df_random_data <- generateRandomData()
#' mseVEP <- evaluateVEP(df_random_data,
#'                       stats = "mse",
#'                       label = "mean_squared_error",
#'                       fnc_stats = NA)
#' mseVEP
#'
#' @references
#' Bonnet, D.G., Wright, T.A., (2000) Sample size requirements for estimating
#' pearson, kendall and spearman correlations. *Psychometrika* 65, 23–28.
#' <https://doi.org/10.1007/BF02294183>
#'
#'
#' @export
#' @import stats utils

evaluateVEP <- function(vep,
                        stats = "pearson",
                        label = "pearson_corr",
                        fnc_stats = NA){
  # Two helper functions for preprared statistical measures.
  calc_corr <- function(target_data, method, data_size, label){
    corr_non_aug <- cor(target_data$non_augmented_value,
                        target_data$actual_value,
                        method = method)
    corr_aug <- cor(target_data$augmented_value,
                    target_data$actual_value,
                    method = method)
    df_corr <- data.frame(data_size, corr_non_aug, corr_aug)
    colnames(df_corr) <- c("data_size",
                           sprintf("%s_non_aug", label),
                           sprintf("%s_aug", label))
    return(df_corr)
  }

  calc_mse <- function(target_data, method, data_size, label){
    mse_non_aug <- sum((target_data$non_augmented_value
                        - target_data$actual_value) ** 2) / length(target_data)
    mse_aug <- sum((target_data$augmented_value
                    - target_data$actual_value) ** 2) / length(target_data)
    df_mse <- data.frame(data_size, mse_non_aug, mse_aug)
    colnames(df_mse) <- c("data_size",
                          sprintf("%s_non_aug", label),
                          sprintf("%s_aug", label))
    return(df_mse)
  }

  # Read a given training data.
  df_vep <- vep

  df_evaluation <- data.frame(0, 0, 0)
  colnames(df_evaluation) <- c("data_size",
                               sprintf("%s_non_aug", label),
                               sprintf("%s_aug", label))
  if (is.na(fnc_stats)){
    if (stats %in% c("pearson", "kendall")){
      calc_stats <- calc_corr
    }
    else if (stats == "mse"){
      calc_stats <- calc_mse
    }
    else{
      stop(sprintf("%s is not a vaild option", stats))
    }
  }
  else{
    calc_stats <- fnc_stats
  }
  for (data_size in unique(df_vep$data_size)){
    target_data <- df_vep[df_vep == data_size,]
    df_evaluation <- rbind(df_evaluation, calc_stats(target_data,
                                                     stats,
                                                     data_size,
                                                     label))
  }
  df_evaluation <- df_evaluation[-1, ]
  return(df_evaluation)
}

# [END]
