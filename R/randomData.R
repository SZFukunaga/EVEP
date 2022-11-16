#' Generate Random Sample Dataset
#'
#' A function to generate random sample training data.
#'
#' @param smallest A integer that shows the smallest training data size. Default
#' is set 100.
#'
#' @param largest A integer that shoes the largest training data size. Default
#' is set 1000.
#'
#' @param num_data A size of the generated sample data. Default is set 1000.
#'
#' @param step A step of training data size between the parameters smallest and
#' largest. Default is set 50.
#'
#' @return Returns a dataframe with four columns. The first column is the
#' training data size, second and third are predicted values for non-augmented
#' and augmented model. The last column is an actual value.
#'
#' @examples
#' # Example 1:
#' # Produce a sample random dataset and save as csv file.
#'
#' df_random_data <- generateRandomData()
#' write.csv(df_random_data, "/Users/shuzo/shuzo/UofT/BCB410/EVEP/data/sample_random_data.csv", row.names = FALSE)
#'
#' @export
#' @import stats

generateRandomData <- function(smallest=100,
                               largest=1000,
                               num_data=1000,
                               step=50){

  # Set seed.
  set.seed(1004805945)

  # A helper function to produce random value.
  defaultRandomValue <- function(x, max, min, actual_value){
    # Generate a random noise. Minimum is -1 * actual_value and maximum is 1 *
    # actual_value. The more training data size it has, the less noise it has.
    non_augmented_noise <-
      runif(1, min = -1, max = 1) * actual_value * ((max - x) / (max - min))
    # Generate a random noise for augmented data. Expected value is a half of
    # the one for non-augmented data, as it is expected that augmentation
    # generally contributes to the improvement of VEP accuracy.
    augmented_noise <-
      runif(1, min = -1, max = 1) * actual_value * (((max - x) / (max - min)) / 2)
    # Apply noises.
    non_augmented_value <- actual_value + non_augmented_noise
    augmented_value <- actual_value + augmented_noise
    return(c(non_augmented_value, augmented_value))
  }

  # Initialize data frame.
  df_random_data = data.frame(data_size = 0,
                              non_augmented_value = 0,
                              augmented_value = 0,
                              actual_value = 0)
  for (i in 1 : num_data){
    data_size <- sample(seq(from = smallest, to = largest, by = step), size = 1)
    actual_value <- runif(1, min = 1, max = 5)
    values <- defaultRandomValue(data_size, largest, smallest, actual_value)
    df_random_data <- rbind(df_random_data,
          data.frame(data_size = data_size,
                     non_augmented_value = values[1],
                     augmented_value = values[2],
                     actual_value = actual_value)
          )
  }
  # Remove the first row which is produced in initialization.
  df_random_data <- df_random_data[-1, ]
  return(df_random_data)
}

# [END]
