bcstatsR
======

This package attempts to replicate the features of the Stata command [`bcstats`](https://github.com/PovertyAction/bcstats) in R.

### Installation
Using the R package [`devtools`](https://www.rstudio.com/products/rpackages/devtools/), you can easily install `bcstatsR`.
```{r}
devtools::install_github('vikjam/bcstatsR')
```

### Use
```{r}
# Load bcstatsR
library(bcstatsR)

# Load a toy example bundled with bcstatsR
data(survey, bc)

# Compare the differences with bcstats
compute.bc <- bcstats(surveydata = survey,
                      bcdata     = bc,
                      id         = "id",
                      t1vars     = "gender",
                      t2vars     = "gameresult",
                      t3vars     = "itemssold",
                      enumerator = "enum",
                      ttest      = "itemssold")

print(compute.bc$backcheck)
```
You should see a list of all the differences 
```{r}
   id   enum   type   variable value.survey value.backcheck
1   1   hana type 2 gameresult           10            <NA>
2   1   hana type 3  itemssold            2            <NA>
3   2   mark type 1     gender       female            <NA>
4   2   mark type 3  itemssold            7              10
5   3   lisa type 2 gameresult           12            <NA>
6   3   lisa type 3  itemssold            1            <NA>
7   4    ife type 2 gameresult           10            <NA>
8   4    ife type 3  itemssold            5            <NA>
9   5   dean type 1     gender       female            <NA>
10  5   dean type 3  itemssold            3               5
11  6  annie type 2 gameresult           10            <NA>
12  6  annie type 1     gender         <NA>            male
13  6  annie type 3  itemssold            7            <NA>
14  7   dean type 1     gender       female            <NA>
15  8  annie type 2 gameresult            7            <NA>
16  8  annie type 3  itemssold            3            <NA>
17  9 brooke type 1     gender       female            <NA>
18 10 brooke type 2 gameresult           14            <NA>
19 10 brooke type 3  itemssold            1            <NA>
20 11   lisa type 1     gender       female            <NA>
21 12   hana type 1     gender       female            <NA>
22 12   hana type 3  itemssold            3               6
23 13  mateo type 2 gameresult           14            <NA>
24 13  mateo type 3  itemssold            1            <NA>
25 14  rohit type 2 gameresult           11              14
26 14  rohit type 1     gender       female            <NA>
```

For more information on the features available with `bcstats` check out the [examples page](examples/examples.md).
