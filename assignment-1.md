    library(tidyverse)
    library(datateachr)
    library(testthat)

# Function

We create a function that is able to plot a numerical variable across a
categorical variable. It has the added feature of ensuring a readable
plot will be obtained by filtering for 10 categories by median in either
ascending or descending order.

    #' boxplots for a dataframe
    #'
    #' This is a function to generate boxplots of a numerical variable across
    #' a categorical variable, subsetting the data for 10 levels by either ascending
    #' or descending order of the median. This ensures a visually interpretable
    #' plot, where the categorical variable is plotted in the specified order.
    #'
    #' @param df The dataframe (df) to be plotted.
    #'
    #' @param categorical The variable to be plotted on the x-axis. Must have
    #' categories that can be subsetted by.
    #'
    #' @param numerical The variable to be plotted on the y-axis. It should 
    #' not require any scaling prior to plotting.
    #'
    #' @param plot A numerical scalar. Number of levels of the categorical to be
    #' plotted.
    #'
    #' @param min_sample_size A numerical scalar. Minimum group size to include
    #' for plotting. Low sample size may produce highly skewed boxplots.
    #'
    #' @param na.rm A logical scalar. Whether NA's should be excluded in the
    #' calculation of medians.
    #'
    #' @param .desc To specify whether groupings are selected based on ascending
    #' or descending medians. Follows the notation of the forcats package.
    #'
    #' @return Output will be a plot provided a dataset and the corresponding
    #' categorical and numerical vaiables are specified. Otherwise, will return a
    #' error.
    boxplot_10 <- function(df, categorical, numerical, plot = 10, min_sample_size = 10, na.rm = TRUE, .desc = FALSE) {
      #check that a dataframe hsa been inputted
      if (is.vector(df)) {
        stop("df must be a dataframe. You inputted an object of the type: ", class(df))
      }
        
      # calculate medians and filter by minimum sample size
      top <- df %>%
        group_by({{ categorical }}) %>%
        summarize(median = median({{ numerical }}, na.rm = na.rm), count = n()) %>%
        filter(count > min_sample_size)

      # order categorical in ascending or descending order
      if (.desc == T) {
        top <- top %>%
          arrange(desc(median)) %>%
          head({{plot}}) %>%
          pull({{ categorical }})
      } else {
        top <- top %>%
          arrange(median) %>%
          head({{plot}}) %>%
          pull({{ categorical }})
      }

      # filter for variables to be plotted and set levels
      df_top <- df %>%
        filter({{ categorical }} %in% top & !is.na({{ numerical }})) %>%
        mutate(categorical = fct_reorder({{ categorical }}, {{ numerical }}, na.rm = na.rm, .desc = .desc))
      # ggplot automatically removes NA but will return a warning
      
      # ggplot visualization
      ggplot(df_top, aes(
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

# Examples

**Example 1.** A clinical cancer dataset is used to plot overall
survival for different cancer types. We choose a minimum sample size of
5, and order the types in descending order of median overall survival.

    #load and preview the dataset
    msk <- read_tsv("https://raw.githubusercontent.com/stat545ubc-2021/mini-data-analysis-EL/main/data/msk_impact_2017_clinical_data.tsv")

    ## Rows: 10945 Columns: 26

    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: "\t"
    ## chr (19): Study ID, Patient ID, Sample ID, Cancer Type, Cancer Type Detailed...
    ## dbl  (7): DNA Input, Fraction Genome Altered, Mutation Count, Overall Surviv...

    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

    head(msk)

    ## # A tibble: 6 × 26
    ##   `Study ID` `Patient ID` `Sample ID` `Cancer Type` `Cancer Type De… `DNA Input`
    ##   <chr>      <chr>        <chr>       <chr>         <chr>                  <dbl>
    ## 1 msk_impac… P-0000004    P-0000004-… Breast Cancer Breast Invasive…         250
    ## 2 msk_impac… P-0000015    P-0000015-… Breast Cancer Breast Invasive…         198
    ## 3 msk_impac… P-0000023    P-0000023-… Mesothelioma  Peritoneal Meso…         250
    ## 4 msk_impac… P-0000024    P-0000024-… Endometrial … Uterine Endomet…         250
    ## 5 msk_impac… P-0000025    P-0000025-… Endometrial … Uterine Serous …         250
    ## 6 msk_impac… P-0000025    P-0000025-… Endometrial … Uterine Serous …         250
    ## # … with 20 more variables: Fraction Genome Altered <dbl>,
    ## #   Matched Status <chr>, Metastatic Site <chr>, Mutation Count <dbl>,
    ## #   Oncotree Code <chr>, Overall Survival (Months) <dbl>,
    ## #   Overall Survival Status <chr>, Primary Tumor Site <chr>,
    ## #   Sample Class <chr>, Sample Collection Source <chr>,
    ## #   Number of Samples Per Patient <dbl>, Sample coverage <dbl>,
    ## #   Sample Type <chr>, Sex <chr>, Smoking History <chr>, …

    boxplot_10(msk, `Cancer Type`, `Overall Survival (Months)`, plot = 5, min_sample_size = 5, na.rm = T, .desc = T)

![](assignment-1_files/figure-markdown_strict/e1-1.png) **Example 2.** A
dataset on vancouver trees from the datateachr package is used to create
a plot of the tree genera with the greatest median latitude, as a
indicator of which trees tend to be located more north with a minimum
sample size of 100.

    boxplot_10(vancouver_trees, genus_name, latitude, .desc = T, min_sample_size =  100)

![](assignment-1_files/figure-markdown_strict/e2-1.png)

&lt;&lt;&lt;&lt;&lt;&lt;&lt; HEAD **Example 3.** We use another dataset
from datateachr, this time for steam games, to visualize the discount
price for games of different genres. ======= **Example 3.** We use
another dataset from datateachr, this time for steam games, to visualize
the discount price for games of different genres.
&gt;&gt;&gt;&gt;&gt;&gt;&gt; ee60eaf3b8ed44c645ae21f92a940d52cdd8232c

    boxplot_10(steam_games, genre, discount_price, min_sample_size =  20, .desc = T)

![](assignment-1_files/figure-markdown_strict/e3-1.png) \# Testing the
function

    # check the output type of our function
    test_that("Function outputs a boxplot", {
      p <- boxplot_10(msk, `Cancer Type`, `Overall Survival (Months)`, min_sample_size = 5, na.rm = T, .desc = T) 
      # class of the output should be a ggplot object
      expect_s3_class(p ,"ggplot") 
      # check that geom layer is a boxplot
      expect_identical(class(p$layers[[1]]$geom)[1], "GeomBoxplot")
    })

    ## Test passed 😀

    # create a test inputting arguments that cannot be plotted
    test_that("Function requires correct argument input types", {
      # numeric scalar as only argument
      expect_error(boxplot_10(1))
       # logical scalar as only argument
      expect_error(boxplot_10(T))
      # list as only argument
      expect_error(boxplot_10(list(c(1,2,3), c("A","B","C"))))
    })

    ## Test passed 🌈
