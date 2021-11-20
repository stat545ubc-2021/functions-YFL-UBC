#' boxplots for a dataframe
#'
#' This is a function to generate boxplots of a numerical variable across
#' a categorical variable, subsetting the data for the desired number of levels
#' by either ascending or descending order of the median. This ensures a
#' visually interpretableplot, where the categorical variable is plotted in the
#'specified order.
#'
#' @param df The dataframe to be plotted.
#' @param categorical The variable to be plotted on the x-axis. Must have
#' categories that can be subsetted by.
#' @param numerical The variable to be plotted on the y-axis. It should
#' not require any scaling prior to plotting.
#' @param plot A numerical scalar. Number of levels of the categorical to be
#' plotted.
#' @param min_sample_size A numerical scalar. Minimum group size to include
#' for plotting. Low sample size may produce highly skewed boxplots.
#' @param na.rm A logical scalar. Whether NA's should be excluded in the
#' calculation of medians.
#' @param .desc To specify whether groupings are selected based on ascending
#' or descending medians. Follows the notation of the forcats package.
#' @return Output will be a boxplot of the class 'ggplot' from the `ggplot2` package.
#'@export
#'@importFrom magrittr "%>%"
#'@examples
#' msk <- readr::read_tsv("https://raw.githubusercontent.com/stat545ubc-2021/mini-data-analysis-EL/main/data/msk_impact_2017_clinical_data.tsv")
#' boxplot_10(msk, `Cancer Type`, `Overall Survival (Months)`, min_sample_size = 5, na.rm = TRUE, .desc = TRUE)
#'
#' boxplot_10(datateachr::vancouver_trees, genus_name, latitude, min_sample_size = 100, .desc = TRUE)
boxplot_10 <- function(df, categorical, numerical, plot = 10, min_sample_size = 10, na.rm = TRUE, .desc = FALSE) {
  #define variables locally in the function, as otherwise check() will have a note for undefined global variables
  Median <- NULL
  Count <- NULL
  #check that a dataframe hsa been inputted
  if (is.vector(df)) {
    stop("df must be a dataframe. You inputted an object of the type: ", class(df))
  }

  # calculate medians and filter by minimum sample size
  top <- df %>%
    dplyr::group_by({{ categorical }}) %>%
    dplyr::summarize(Median = stats::median({{ numerical }}, na.rm = na.rm), Count = dplyr::n()) %>%
    dplyr::filter(Count > min_sample_size)

  # order categorical in ascending or descending order
  if (.desc == T) {
    top <- top %>%
      dplyr::arrange(dplyr::desc(Median)) %>%
      utils::head({{plot}}) %>%
      dplyr::pull({{ categorical }})
  } else {
    top <- top %>%
      dplyr::arrange(Median) %>%
      utils::head({{plot}}) %>%
      dplyr::pull({{ categorical }})
  }

  # filter for variables to be plotted and set levels
  df_top <- df %>%
    dplyr::filter({{ categorical }} %in% top & !is.na({{ numerical }})) %>%
    dplyr::mutate(categorical = forcats::fct_reorder({{ categorical }}, {{ numerical }}, na.rm = na.rm, .desc = .desc))
  # ggplot automatically removes NA but will return a warning

  # ggplot visualization
  ggplot2::ggplot(df_top, ggplot2::aes(
    x = categorical,
    y = {{ numerical }},
    color = categorical
  )) +
    ggplot2::geom_boxplot(outlier.color = "black", outlier.size = 0.5) +
    ggplot2::theme(
      axis.text.x = ggplot2::element_text(size = 6, angle = 45, vjust = 1, hjust = 1),
      legend.position = "none"
    ) +
    ggplot2::xlab(ggplot2::element_blank())
}
