#' @title theme plot
#' defined plot style
#'
#' @import ggplot2
#'
#' @examples
#' library(ggplot2)
#' p1 <- ggplot(mtcars, aes(wt, mpg)) +
#'   geom_point() +
#'   labs(title = "Fuel economy declines as weight increases") +
#'   myfinalpkg:::theme_plot()
theme_plot <- function() {
  size.text <- 8
  size.line <- 0.5
  color.default <- "grey45"
  theme(
    plot.title = element_text(
      color = color.default,
      size = size.text * 1.5,
      face = "bold.italic",
      hjust = 0.5
    ),
    text = element_text(size = size.text),
    panel.background = element_blank(),
    panel.grid.major = element_line(colour = "white", linewidth = 0.1),
    line = element_line(linewidth = 2.2),
    axis.line.x = element_line(color = color.default, linewidth = size.line),
    axis.line.y = element_line(color = color.default, linewidth = size.line),
    axis.text.x = element_text(
      size = size.text,
      hjust = 1,
      angle = 45
    ),
    axis.text.y = element_text(size = size.text, vjust = 1),
    axis.title.x = element_blank(),
    axis.title.y = element_text(size = size.text, hjust = 0.5),
    legend.title =  element_blank(),
    legend.key = element_rect(fill = alpha("white", 0.0))
  )
}

#' Color for bar plot
.ColorBars <- "grey"
#' Color for lines in line plot
.ColorLines <- "black"

#' @title Scale plot axes
#' defined plot style for axes
#'
#' @param pp \code{ggplot} object
#' @param datebreaks \code{character} x axis date breaks, default = "1 week"
#'
#' @import ggplot2
#' @importFrom scales label_number cut_si
#'
#' @seealso [scale_x_date()] [scale_y_continuous()]
scale_axes <- function(pp, datebreaks = "1 week") {
  y.n.breaks <- 10
  date.format <- "%b %d"
  pp +
    scale_x_date(date_breaks = datebreaks, date_labels = date.format) +
    scale_y_continuous(n.breaks = y.n.breaks, labels =  scales::label_number(scale_cut = cut_si("")))
}

#' @title determine dates break
#' if the dates range is less than threshold then result is 1 week, otherwise 1 month
#'
#' @param dates \code{Date} vector
#' @param threshold \code{numeric} threshold for week month choice
#'
get_date_breaks <- function(dates, threshold = 160) {
  ifelse(diff(range(dates)) < threshold, "1 week", "1 month")
}

#' Lineplot function
#'
#' @param data \code{data.frame}, covid19 data.
#' @param value \code{character}, Column name variable of data.
#' @param startdate \code{character} or \code{Date}, format: "%Y-%m-%d", default start
#' @param title \code{character}, Title text, if missing no title
#'
#' @details it plots value over Date
#'
#' @return data.frame
#'
#' @import dplyr
#' @import ggplot2
#' @importFrom dplyr filter
#' @export
#'
#' @examples
#' library(ggplot2)
#' df <- read_data("case_time_series.csv","covid_data")
#' data <- process_data(df)
#' line_plot_data(data, "Daily.Confirmed")
#' line_plot_data(data, "Daily.Active", title = "Active cases")
line_plot_data <- function(data, value, startdate = data$Date[1], title) {
  if (!(value %in% names(data)))
    stop(value, " is not a valid column name of data")
  
  if (!missing(startdate)) {
    # conflicts with "stats" package, ::: could be required
    data <- data %>%
      filter(Date >= startdate)
  }
  date.break <- get_date_breaks(data$Date)
  
  p <- ggplot(data, aes(
    x = Date,
    y = !!sym(value),
    group = 1
  )) +
    geom_line(colour = .ColorLines) # add a line
  # add theme
  p <- p +
    theme_plot()
  # add scales
  p <- scale_axes(p, date.break)
  #add title if present
  if (!missing(title))
    p <- p + labs(title = title)
  p
}

#' Barplot function
#'
#' @param data \code{data.frame}, covid19 data.
#' @param value \code{character}, Column name variable of data.
#' @param startdate \code{character} or \code{Date}, format: "%Y-%m-%d", default start
#' @param rollm \code{logical}, if TRUE then a line with rolled weekly mean will be added
#' @param title \code{character}, Title text, if missing no title
#'
#' @details it plots value over Date
#'
#' @return data.frame
#'
#' @import dplyr
#' @import ggplot2
#' @importFrom dplyr filter
#' @export
#'
#' @examples
#' library(ggplot2)
#' df <- read_data("case_time_series.csv","covid_data")
#' data <- process_data(df)
#' bar_plot_data(data, "Daily.Confirmed", rollm = TRUE)
#' bar_plot_data(data, "Daily.Active")
bar_plot_data <- function(data, value, startdate = data$Date[1], rollm = FALSE, title) {
  if (!(value %in% names(data)))
    stop(value, " is not a valid column name of data")
  
  if (!missing(startdate)) {
    # conflicts with "stats" package, ::: could be required
    data <- data %>%
      filter(Date >= startdate)
  }
  date.break <- get_date_breaks(data$Date)
  
  p <- ggplot(data, aes(
    x = Date,
    y = !!sym(value),
    group = 1
  )) +
    geom_bar(stat = "identity", colour = .ColorBars)
  
  if (rollm) {
    # use !sym() to parse rolled.value
    message("Add rolled mean for ", value)
    rolled.value <- paste("rollmean", value, sep = "_")
    p <-
      p + geom_line(aes(x = Date, y = !!sym(rolled.value)), color = "red", size = 1.25)
  }
  # add theme
  p <- p +
    theme_plot()
  # add scales
  p <- scale_axes(p, date.break)
  
  #add title if present
  if (!missing(title))
    p <- p + labs(title = title)
  p
}

