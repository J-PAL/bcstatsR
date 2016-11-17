bcstatsR
======

This package attempts to replicate the features of the Stata command [`bcstats`](https://github.com/PovertyAction/bcstats) in R.

### Installation
Using the R package [`devtools`](https://www.rstudio.com/products/rpackages/devtools/), you can easily install `bcstatsR`.
```
devtools::install_github('vikjam/bcstatsR')
```

### Use
```
# Load bcstatsR
library(bcstatsR)

# Create a toy example of datasets to compare
data(iris)
first_survey <- iris
first_survey$id <- seq(1, nrow(first_survey))
second_survey <- first_survey
second_survey[second_survey$id %in% c(1, 6, 7, 9), "Sepal.Width"] <- 100

# Compare the differences with bcstats
back_check <- bcstats(surveydata = first_survey, bcdata = second_survey, id = "id", t1vars = c("Sepal.Width"))
print(back_check, row.names = FALSE)
```
You should see a list of all the differences
```
id   type    variable value.survey value.back_check
 1 Type 1 Sepal.Width          3.5              100
 6 Type 1 Sepal.Width          3.9              100
 7 Type 1 Sepal.Width          3.4              100
 9 Type 1 Sepal.Width          2.9              100
```

