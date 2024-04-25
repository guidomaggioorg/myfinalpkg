#' Function to compute the rolled mean of a vector over a certain window
#'
#' @param x \code{numeric}, vector of values.
#' @param k \code{integer}, size of window.
#'
#' @return numeric vector
#'
#' @importFrom zoo rollapplyr
#' @export
#'
#' @examples
#' roll_mean(1:10,2)
#' roll_mean(rnorm(10), k = 7)
#' # it will give an error
#' \dontrun{roll_mean(letters,4)}
roll_mean <- function(x, k = 7) {
  if (!is.numeric(x)) {
    stop("wrong class of x: ", class(x))
  }
  if (any(is.na(x))) {
    stop("x contains: ", sum(is.na(x)), " NAs")
  }
  if (k %% 1 != 0) {
    stop("k is not an integer: ", k)
  }
  align = "right"
  # set to NA if it starts with 0s so that the average does not get computed
  rollapplyr(x, k, mean, partial=TRUE, align = align)
}

