#' @title read covid data
#' Function to read covid data from case_time_series.csv
#'
#' @param filename \code{character}, file name.
#' @param path \code{character}, folder name.
#' @param sep \code{character}, separator for \code{read.csv}, default = ','
#'
#' @return data.frame
#'
#' @import dplyr
#' @importFrom utils read.csv
#' @export
#'
#' @examples
#' read_data("case_time_series.csv","covid_data")
#'
#' @seealso [utils::read.csv()]
read_data <- function(filename, path, sep = ",") {
  filepath <- file.path(path, filename)
  data.out <- read.csv(system.file(filepath, package = "myfinalpkg"), sep = sep)
  # DQ check on column names
  if (!(all(
    c(
      "Date_YMD",
      "Total.Confirmed",
      "Total.Recovered",
      "Total.Deceased"
    ) %in% names(data.out)
  )))
    stop("Missing column in input ", filepath)
  # update date column
  data.out %>% select(-1) %>%
    mutate(Date = as.Date(Date_YMD)) %>%
    select(-Date_YMD) %>%
    select(Date, starts_with("Total"))
}

#' @title process covid data
#' Compute additional variables
#'
#' @param data \code{data.frame}, covid19 data.
#' @param k \code{integer}, window size for \code{roll_mean}
#'
#' @details it computes actives and daily figures
#'
#' @return data.frame
#'
#' @import dplyr
#' @export
#'
#' @examples
#' df <- read_data("case_time_series.csv","covid_data")
#' process_data(df)
#' @seealso [roll_mean()]
process_data <- function(data, k = 7) {
  if (k %% 1 != 0) {
    stop("k is not an integer: ", k)
  }
  if (any(data$Current.Active < 0))
    warning(sum(data$Current.Active < 0), " Active values are negative")
  
  # small utility to compute new cases
  .new_calc <- function(x) {
    as.integer(c(0, diff(x)))
  }
  
  out.data <- data %>%
    mutate(Total.Active = Total.Confirmed - Total.Recovered- Total.Deceased) %>%
    mutate(across(where(is.numeric), .new_calc, .names = "Daily.{.col}"))
  
  names(out.data) <-  gsub("^Daily.Total","Daily", names(out.data))
  
  out.data <- out.data %>%
    mutate(across(where(is.numeric), ~ roll_mean(.x, k = k), .names = "rollmean_{.col}"))
  
  out.data
}

#' Returns the last week absolute numbers
#'
#' @param data \code{data.frame} of covid19 data
#' @param n \code{integer}, number of days to consider, default 7
#'
#' @import dplyr
#' @export
#'
#' @return \code{data.frame}
#' @examples
#' df <- read_data("case_time_series.csv","covid_data")
#' dat <- process_data(df)
#' last_n_days_rep(dat)
#' @seealso [formatC()]
last_n_days_rep <- function(data, n = 7) {
  
  # select last n days
  dataW <- data %>%
    select(Date, starts_with("Total")) %>%
    slice_max(Date, n = n)
  
  dataW %>%
    summarise(across(starts_with("Total"), function(y) y[1]-y[length(y)])) %>%
    setNames(gsub(pattern = "Total.", replacement = "", names(dataW)[-1])) %>%
    summarise(across(where(is.numeric), ~ formatC(.x, big.mark = "'", format = "d")))
}
