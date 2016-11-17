bcstatsR
======

This package contains the R clone of the the Stata command bcstats.

### Installation
devtools::install_github('vikjam/bcstatsR')

### Use
```
# Create an example of datasets to compare
data(iris)

first_survey  <- iris
first_survey$id <- seq(1, nrow(first_survey))
second_survey <- first_survey
second_survey[second_survey$id %in% c(1, 6, 7, 9), "Sepal.Width"] <- 100

back_check <- bcstats(surveydata = first_survey, bcdata = second_survey, id = "id", t1vars = c("Sepal.Width"))
print(back_check)
```
You should see a list of all the differences

```
    id   type    variable value.survey value.back_check
4    1 Type 1 Sepal.Width          3.5              100
534  6 Type 1 Sepal.Width          3.9              100
589  7 Type 1 Sepal.Width          3.4              100
699  9 Type 1 Sepal.Width          2.9              100
```

