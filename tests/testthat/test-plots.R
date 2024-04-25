# if (FALSE) {
#   devtools::load_all()
# }
df <- read_data("case_time_series.csv","covid_data")

data <- process_data(df)

test_that("plot works", {
  pp <- line_plot_data(data, "Daily.Active")

  expect_equal(class(pp), c("gg","ggplot"), 
               label = "wrong plot class")
  expect_equal(pp$data, data, label = 
                 "data are different from input")
  
  pp <- bar_plot_data(data, "Daily.Active")
  
  expect_equal(class(pp), c("gg","ggplot"), 
               label = "wrong plot class")
  expect_equal(pp$data, data, 
               label = "data are different from input") 
})
