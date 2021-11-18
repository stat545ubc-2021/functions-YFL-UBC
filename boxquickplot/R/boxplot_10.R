#' boxplots for a dataframe
#'
#' This is a function to generate boxplots of a numerical variable across
#' a categorical variable, subsetting the data for 10 levels by either ascending
#' or descending order of the median. This ensures a visually interpretable
#' plot, where the categorical variable is plotted in the specified order.
#'
#' @param df The dataframe (df) to be plotted.
#' @param categorical The variable to be plotted on the x-axis. Must have
#' categories that can be subsetted by.
#' @param numerical The variable to be plotted on the y-axis. It should
#' not require any scaling prior to plotting.
#' @param min_sample_size A numerical scalar. Minimum group size to include
#' for plotting. Low sample size may produce highly skewed boxplots.
#' @param na.rm A logical scalar. Whether NA's should be excluded in the
#' calculation of medians.
#' @param .desc To specify whether groupings are selected based on ascending
#' or descending medians. Follows the notation of the forcats package.
#' #' @return Output will be a plot provided a dataset and the corresponding
#' categorical and numerical vaiables are specified. Otherwise, will return a
#' error.
#'@export
#'@examples
#' msk <- read_tsv("https://raw.githubusercontent.com/stat545ubc-2021/mini-data-analysis-EL/main/data/msk_impact_2017_clinical_data.tsv")
#' boxplot_10(msk, `Cancer Type`, `Overall Survival (Months)`, min_sample_size = 5, na.rm = T, .desc = T)
#' 
#' boxplot_10(datateachr::vancouver_trees, genus_name, latitude, min_sample_size = 100, .desc = T,)
boxplot_10 <- function(df, categorical, numerical, min_sample_size = 10, na.rm = TRUE, .desc = FALSE) {
  #check that a dataframe hsa been inputted
  if (is.vector(df)) {
    stop("df must be a dataframe. You inputted an object of the type: ", class(df))
  }

  # calculate medians and filter by minimum sample size
  top_10 <- df %>%
    group_by({{ categorical }}) %>%
    summarize(median = median({{ numerical }}, na.rm = na.rm), count = n()) %>%
    filter(count > min_sample_size)

  # order categorical in ascending or descending order
  if (.desc == T) {
    top_10 <- top_10 %>%
      arrange(desc(median)) %>%
      head(10) %>%
      pull({{ categorical }})
  } else {
    top_10 <- top_10 %>%
      arrange(median) %>%
      head(10) %>%
      pull({{ categorical }})
  }

  # filter for variables to be plotted and set levels
  df_10 <- df %>%
    filter({{ categorical }} %in% top_10 & !is.na({{ numerical }})) %>%
    mutate(categorical = fct_reorder({{ categorical }}, {{ numerical }}, na.rm = na.rm, .desc = .desc))
  # ggplot automatically removes NA but will return a warning

  # ggplot visualization
  ggplot(df_10, aes(
    x = categorical,
    y = {{ numerical }},
    color = categorical
  )) +
    geom_boxplot(outlier.color = "black", outlier.size = 0.5) +
    theme(
      axis.text.x = element_text(size = 6, angle = 45, vjust = 1, hjust = 1),
      legend.position = "none"
    ) +
    xlab(element_blank())
}
