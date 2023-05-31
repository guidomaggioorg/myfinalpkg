# create vector of test data outside test_that()
vect_dates <- as.Date(seq(1, 100, by = 5), origin = as.Date("2022/01/01"))

test_that("get_date_breaks works", {
  # example 1, 1 months expected
  expect_equal(get_date_breaks(vect_dates, 10), "1 month")
  # dummy with all equal values
  expect_equal(get_date_breaks(vect_dates, 100), "1 week")
})
test_that("character input dates gives error to get_date_breaks", {
  # example 3
  expect_error(get_date_breaks(as.character(vect_dates), 100))
  # this test gives an error,
  # get_date_breaks must be updated with a stop message in order to make this test pass
})
