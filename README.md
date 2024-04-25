# myfinalpkg documentation
  
The goal of **myfinalpkg** is to illustrate building a package during the IntroR4 workshop.

### Description

`myfinalpkg` stores a csv file with Covid19 data from a given country.

The data reports total "Confirmed" "Recovered" "Deceased" cases per day.

With `myfinalpkg` we can process data to compute daily figures, number of active cases and their weekly averages.

A plotting functionality is available.

### Naming conventions

- Always used "<-" for assignments.
- All words in function names are separated with "_".
- All function arguments are lower-case.
- All internal main variables have a "." in the name.
- All internal functions start with "." and end with "calc".
- All global variable names start with ".[A-Z]" i.e. "." and upper-case.

### Example

This is a basic example which shows you how run the functions in the package:

``` r
library(myfinalpkg)
df <- read_data("case_time_series.csv", "covid_data")
data <- process_data(df)
last_n_days_rep(data)
#bar_plot_data(data, "Daily.Deceased", title = "Daily Deaths", rollm = TRUE)
```
