# test arguments that should not be plotted
test_that("Function requires correct argument input types", {
  # numeric scalar as only argument
  expect_error(boxplot_10(1))
  # logical scalar as only argument
  expect_error(boxplot_10(T))
  # list as only argument
  expect_error(boxplot_10(list(c(1,2,3), c("A","B","C"))))
})

# check the output type of our function
test_that("Function outputs a boxplot", {
  msk <- readr::read_tsv("https://raw.githubusercontent.com/stat545ubc-2021/mini-data-analysis-EL/main/data/msk_impact_2017_clinical_data.tsv")
  p <- boxplot_10(msk, `Cancer Type`, `Overall Survival (Months)`, min_sample_size = 5, na.rm = T, .desc = T)
  # class of the output should be a ggplot object
  expect_s3_class(p ,"ggplot")
  # check that geom layer is a boxplot
  expect_identical(class(p$layers[[1]]$geom)[1], "GeomBoxplot")
})
