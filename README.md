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
1   1   hana Type 2 gameresult           10            <NA>
2   2   mark Type 1     gender       female                
3   3   lisa Type 2 gameresult           12            <NA>
4   4    ife Type 2 gameresult           10            <NA>
5   5   dean Type 1     gender       female                
6   6  annie Type 2 gameresult           10            <NA>
7   6  annie Type 1     gender                         male
8   7   dean Type 1     gender       female                
9   8  annie Type 2 gameresult            7            <NA>
10  9 brooke Type 1     gender       female                
11 10 brooke Type 2 gameresult           14            <NA>
12 11   lisa Type 1     gender       female                
13 12   hana Type 1     gender       female                
14 13  mateo Type 2 gameresult           14            <NA>
15 14  rohit Type 2 gameresult           11              14
16 14  rohit Type 1     gender       female                        
```

For more information on the features available with `bcstats` check out the [examples page](examples/examples.md).
