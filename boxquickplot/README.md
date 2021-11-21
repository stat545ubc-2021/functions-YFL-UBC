
<!-- README.md is generated from README.Rmd. Please edit that file -->

# boxquickplot

<!-- badges: start -->
<!-- badges: end -->

The goal of boxquickplot is to provide users with a function to generate
a boxplot figure in a single line. The figure has the added features of
being organized in either ascending or descending order of the median of
the plotted numerical variable for any desired number of categories to
be included.

## Installation

You can install the development version of boxquickplot from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("stat545ubc-2021/functions-YFL-UBC/boxquickplot/")
#> Downloading GitHub repo stat545ubc-2021/functions-YFL-UBC@HEAD
#> 
#>      checking for file ‘/private/var/folders/hc/slhgtcd10v73zw8503mls20c0000gn/T/Rtmpz0ASYp/remotes1180651a55a/stat545ubc-2021-functions-YFL-UBC-61c86be/boxquickplot/DESCRIPTION’ ...  ✓  checking for file ‘/private/var/folders/hc/slhgtcd10v73zw8503mls20c0000gn/T/Rtmpz0ASYp/remotes1180651a55a/stat545ubc-2021-functions-YFL-UBC-61c86be/boxquickplot/DESCRIPTION’ (352ms)
#>   ─  preparing ‘boxquickplot’:
#>      checking DESCRIPTION meta-information ...  ✓  checking DESCRIPTION meta-information
#>   ─  checking for LF line-endings in source and make files and shell scripts
#>   ─  checking for empty or unneeded directories
#>    Omitted ‘LazyData’ from DESCRIPTION
#>   ─  building ‘boxquickplot_1.0.0.tar.gz’
#>      
#> 
```

## Example

This is a basic example which shows you a plot of a cancer dataset,
obtained from [cBioPortal](https://www.cbioportal.org), to show the 15
deadliest cancer types by overall survival.

``` r
library(boxquickplot)
library(readr)
## basic example code
msk <- read_tsv("https://raw.githubusercontent.com/stat545ubc-2021/mini-data-analysis-EL/main/data/msk_impact_2017_clinical_data.tsv")
#> Rows: 10945 Columns: 26
#> ── Column specification ────────────────────────────────────────────────────────
#> Delimiter: "\t"
#> chr (19): Study ID, Patient ID, Sample ID, Cancer Type, Cancer Type Detailed...
#> dbl  (7): DNA Input, Fraction Genome Altered, Mutation Count, Overall Surviv...
#> 
#> ℹ Use `spec()` to retrieve the full column specification for this data.
#> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
boxplot_10(msk, `Cancer Type`, `Overall Survival (Months)`, plot = 15, min_sample_size = 5, na.rm = T, .desc = F)
```

<img src="man/figures/README-example-1.png" width="100%" />
