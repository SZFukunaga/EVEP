infile <- "./data/sample_random_data.csv"


load_data <- function(infile){
  df_vep <- read.csv(infile)
  return(df_vep)
}

calc_corr <- function(target_data, method){
  corr_non_aug <- cor(target_data$non_augmented_value,
                                target_data$actual_value,
                                method = method)
  corr_aug <- cor(target_data$augmented_value,
                            target_data$actual_value,
                            method = method)
  df_corr <- data.frame(corr_non_aug, corr_aug)
  colnames(df_corr) <- c(sprintf("%s_corr_non_aug", method),
                         sprintf("%s_corr_aug", method))
  return(df_corr)
}

calc_mse <- function(target_data, stats = NA){
  mse_non_aug <- sum((target_data$non_augmented_value
                      - target_data$actual_value) ** 2) / length(target_data)
  mse_aug <- sum((target_data$augmented_value
                      - target_data$actual_value) ** 2) / length(target_data)
  df_mse <- data.frame(mse_non_aug = mse_non_aug, mse_aug = mse_aug)
  return(df_mse)
}

evaluateVEP <- function(vep,
                        stats = "pearson",
                        label = "pearson_corr",
                        fnc_stats = corr_pearson){
  for (data_size in unique(df_vep$data_size)){
    target_data <- df_vep[df_vep == data_size,]
    df_evaluation <- data.frame(0, 0)
    if (is.na(fnc_stats)){
      if (stats %in% c("pearson", "kendall")){
        df_stats_value <- calc_corr(target_data, stats)
      }
      else if (stats == "mse"){
        stats_value <- calc_mse(target_data, NA)
      }
      else{
        stop(sprintf("%s is not a vaild option", stats))
      }
    }
    else{

    }
  }
}
