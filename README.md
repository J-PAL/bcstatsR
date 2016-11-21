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

# Load a toy example that comes with bcstatsR
data(survey)
data(bc)

# Compare the differences with bcstats
compute.bc <- bcstats(surveydata = survey,
                      bcdata     = bc,
                      id         = "id",
                      t1vars     = "gender",
                      t2vars     = "gameresult",
                      t3vars     = "itemssold",
                      enumerator = "enum",
                      ttest      = "itemssold")

print(compute.bc$back_check, row.names = FALSE)
```
You should see a list of all the differences 
```
   id   enum   type   variable value.survey value.back_check
1   1   hana Type 2 gameresult           10             <NA>
2   1   hana Type 3  itemssold            2             <NA>
3   2   mark Type 1     gender       female                 
4   2   mark Type 3  itemssold            7               10
5   3   lisa Type 2 gameresult           12             <NA>
6   3   lisa Type 3  itemssold            1             <NA>
7   4    ife Type 2 gameresult           10             <NA>
8   4    ife Type 3  itemssold            5             <NA>
9   5   dean Type 1     gender       female                 
10  5   dean Type 3  itemssold            3                5
11  6  annie Type 2 gameresult           10             <NA>
12  6  annie Type 1     gender                          male
13  6  annie Type 3  itemssold            7             <NA>
14  7   dean Type 1     gender       female                 
15  8  annie Type 2 gameresult            7             <NA>
16  8  annie Type 3  itemssold            3             <NA>
17  9 brooke Type 1     gender       female                 
18 10 brooke Type 2 gameresult           14             <NA>
19 10 brooke Type 3  itemssold            1             <NA>
20 11   lisa Type 1     gender       female                 
21 12   hana Type 1     gender       female                 
22 12   hana Type 3  itemssold            3                6
23 13  mateo Type 2 gameresult           14             <NA>
24 13  mateo Type 3  itemssold            1             <NA>
25 14  rohit Type 2 gameresult           11               14
26 14  rohit Type 1     gender       female                 
```

