% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rollMean.R
\name{roll_mean}
\alias{roll_mean}
\title{Function to compute the rolled mean of a vector over a certain window}
\usage{
roll_mean(x, k = 7)
}
\arguments{
\item{x}{\code{numeric}, vector of values.}

\item{k}{\code{integer}, size of window.}
}
\value{
numeric vector
}
\description{
Function to compute the rolled mean of a vector over a certain window
}
\examples{
roll_mean(1:10,2)
roll_mean(rnorm(10), k = 7)
# it will give an error
\dontrun{roll_mean(letters,4)}
}
