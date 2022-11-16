infile <- "./data/sample_random_data.csv"


load_data <- function(infile){
  df_vep <- read.csv(infile)
  return(df_vep)
}

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

evaluateVEP <- function(vep,
                        stats = "pearson",
                        label = "pearson_corr",
                        fnc_stats = NA){
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

visualizeEvaluation <- function(vep,
                                 stats = "pearson",
                                 label = "pearson correlation",
                                 fnc_stats = NA){
  df_evaluation <- evaluateVEP(vep, stats, label, fnc_stats)
  plot(df_evaluation$data_size,
       df_evaluation[, 2],
       xlab = "training data size",
       ylab = label,
       pch = 19)
  points(df_evaluation$data_size, df_evaluation[, 3], col="red", pch = 19)
  legend("bottomright",
         legend = c("Not Augmented", "Augmented"),
         col = c("black", "red"),
         pch = 19)
  title("Evaluation of Agumentation on VEP")
}

df_vep <- load_data(infile)
visualizeEvaluation(df_vep)
