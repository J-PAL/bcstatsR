Example usage of bcstats
================

Let's apply `bcstats` in a few examples.

Toy example
-----------

First, consider the following minimal working example. `bcstats` comes with two example two data sets. Load the library to get started.

``` r
library(bcstatsR)
```

And then load the two datasets that come bundled with the library.

``` r
data(survey)
data(bc)
```

Let's take a look at the survey data.

``` r
library(knitr)
kable(survey)
```

|   id| date      | enum   |  enumteam| gender |  gameresult|  itemssold|
|----:|:----------|:-------|---------:|:-------|-----------:|----------:|
|    1| 15apr2011 | hana   |         3| female |          10|          2|
|    2| 15apr2011 | mark   |         1| female |           9|          7|
|    3| 16may2011 | lisa   |         2| female |          12|          1|
|    4| 13jun2011 | ife    |         2| female |          10|          5|
|    5| 10jun2011 | dean   |         1| female |          12|          3|
|    6| 17may2011 | annie  |         1|        |          10|          7|
|    7| 07jul2011 | dean   |         1| female |          14|          1|
|    8| 16jun2011 | annie  |         1| female |           7|          3|
|    9| 14jul2011 | brooke |         2| female |          10|          3|
|   10| 25jul2011 | brooke |         2| female |          14|          1|
|   11| 16jun2011 | lisa   |         2| female |          14|          1|
|   12| 13jun2011 | hana   |         3| female |           9|          3|
|   13| 21jul2011 | mateo  |         3| female |          14|          1|
|   14| 15aug2011 | rohit  |         3| female |          11|          1|
|   15| 30may2011 | annie  |         1| female |          10|          4|
|   16| 04may2011 | mark   |         1| female |          10|          4|
|   17| 19apr2011 | brooke |         2| female |          12|          5|
|   18| 01apr2011 | mateo  |         3| female |           9|          1|
|   19| 11may2011 | ife    |         2| female |          10|          5|
|   20| 28mar2011 | mateo  |         3| female |          10|          4|
|   21| 09may2011 | ife    |         2| female |          12|          7|
|   22| 06apr2011 | brooke |         2| female |          10|          3|
|   23| 07jun2011 | annie  |         1| female |           9|          2|
|   24| 01apr2011 | annie  |         1|        |           9|          5|
|   25| 18may2011 | hana   |         3| female |          10|          6|
|   26| 12may2011 | hana   |         3| female |           9|          4|
|   27| 31may2011 | mark   |         1| female |           9|          3|
|   28| 29apr2011 | mateo  |         3| female |          10|          1|
|   29| 11may2011 | annie  |         1| female |           6|          8|
|   30| 10may2011 | ife    |         2| female |           8|          4|
|   31| 20apr2011 | dean   |         1| female |           9|          6|
|   32| 30mar2011 | mateo  |         3| female |          10|          5|
|   33| 06may2011 | ife    |         2| female |           9|          5|

Now, take a look at the back check data (i.e., the follow up where highly trained surveyors interview the same households).

``` r
kable(bc)
```

|   id| date      | bcer    | gender |  gameresult|  itemssold|
|----:|:----------|:--------|:-------|-----------:|----------:|
|    1| 18apr2011 | wendy   | female |          NA|         NA|
|    2| 18apr2011 | wendy   |        |           9|         10|
|    3| 17may2011 | rebecca | female |          NA|         NA|
|    4| 14jun2011 | wendy   | female |          NA|         NA|
|    5| 13jun2011 | wendy   |        |          12|          5|
|    6| 18may2011 | wendy   | male   |          NA|         NA|
|    7| 08jul2011 | wendy   |        |          14|          1|
|    8| 17jun2011 | wendy   | female |          NA|         NA|
|    9| 15jul2011 | wendy   |        |          10|          3|
|   10| 26jul2011 | rebecca | female |          NA|         NA|
|   11| 17jun2011 | wendy   |        |          14|          1|
|   12| 14jun2011 | wendy   |        |           9|          6|
|   13| 22jul2011 | rebecca | female |          NA|         NA|
|   14| 16aug2011 | rebecca |        |          14|          1|

In this example, `gender`, `gameresult` and `itemssold` are the variables collected in both the survey and the back check. Note that `id` identifies the respondent in both the survey and the back check. In the survey, `enum` and `enumteam` tells us the surveyor and the team of the surveyor. We'll want to know whether or not these surveyors and teams collected the data correctly in the survey. Similarly, in the back check, we'll want to summarize the data by back checker to see if we notice unusual patterns.

Now, let's run the back check!

``` r
result <- bcstats(surveydata  = survey,
                  bcdata      = bc,
                  id          = "id",
                  t1vars      = "gender",
                  t2vars      = "gameresult",
                  t3vars      = "itemssold",
                  enumerator  = "enum",
                  enumteam    = "enumteam",
                  backchecker = "bcer")
```

And auto-magically, you've created a bunch of results stored in `result`. Let's take a look at back check, which has been stored in `back$check`.

``` r
kable(result$backcheck)
```

|   id| enum   |  enumteam| bcer    | type   | variable   | value.survey | value.backcheck |
|----:|:-------|---------:|:--------|:-------|:-----------|:-------------|:----------------|
|    1| hana   |         3| wendy   | Type 2 | gameresult | 10           | NA              |
|    2| mark   |         1| wendy   | Type 1 | gender     | female       |                 |
|    3| lisa   |         2| rebecca | Type 2 | gameresult | 12           | NA              |
|    4| ife    |         2| wendy   | Type 2 | gameresult | 10           | NA              |
|    5| dean   |         1| wendy   | Type 1 | gender     | female       |                 |
|    6| annie  |         1| wendy   | Type 2 | gameresult | 10           | NA              |
|    6| annie  |         1| wendy   | Type 1 | gender     |              | male            |
|    7| dean   |         1| wendy   | Type 1 | gender     | female       |                 |
|    8| annie  |         1| wendy   | Type 2 | gameresult | 7            | NA              |
|    9| brooke |         2| wendy   | Type 1 | gender     | female       |                 |
|   10| brooke |         2| rebecca | Type 2 | gameresult | 14           | NA              |
|   11| lisa   |         2| wendy   | Type 1 | gender     | female       |                 |
|   12| hana   |         3| wendy   | Type 1 | gender     | female       |                 |
|   13| mateo  |         3| rebecca | Type 2 | gameresult | 14           | NA              |
|   14| rohit  |         3| rebecca | Type 2 | gameresult | 11           | 14              |
|   14| rohit  |         3| rebecca | Type 1 | gender     | female       |                 |

Each row contains the difference between the survey and the back check by each household and variable. Cases where nothing changed have not been included in this data.frame. Now let's take a look at the error rates for Type 1 by each surveyor (enumerator).

``` r
kable(result[["enum1"]]$summary)
```

| enum   |  error.rate|  differences|  total|
|:-------|-----------:|------------:|------:|
| annie  |         0.5|            1|      2|
| brooke |         0.5|            1|      2|
| dean   |         1.0|            2|      2|
| hana   |         0.5|            1|      2|
| ife    |         0.0|            0|      1|
| lisa   |         0.5|            1|      2|
| mark   |         1.0|            1|      1|
| mateo  |         0.0|            0|      1|
| rohit  |         1.0|            1|      1|

We can also take at the error rate for each Type 1 variable by enumerator.

``` r
kable(result[["enum1"]]$each)
```

| enum   | variable |  error.rate|  differences|  total|
|:-------|:---------|-----------:|------------:|------:|
| annie  | gender   |         0.5|            1|      2|
| brooke | gender   |         0.5|            1|      2|
| dean   | gender   |         1.0|            2|      2|
| hana   | gender   |         0.5|            1|      2|
| ife    | gender   |         0.0|            0|      1|
| lisa   | gender   |         0.5|            1|      2|
| mark   | gender   |         1.0|            1|      1|
| mateo  | gender   |         0.0|            0|      1|
| rohit  | gender   |         1.0|            1|      1|

And we can do the same thing for Type 2 variables.

``` r
kable(result[["enum2"]]$summary)
```

| enum   |  error.rate|  differences|  total|
|:-------|-----------:|------------:|------:|
| annie  |         1.0|            2|      2|
| brooke |         0.5|            1|      2|
| dean   |         0.0|            0|      2|
| hana   |         0.5|            1|      2|
| ife    |         1.0|            1|      1|
| lisa   |         0.5|            1|      2|
| mark   |         0.0|            0|      1|
| mateo  |         1.0|            1|      1|
| rohit  |         1.0|            1|      1|

``` r
kable(result[["enum2"]]$each)
```

| enum   | variable   |  error.rate|  differences|  total|
|:-------|:-----------|-----------:|------------:|------:|
| annie  | gameresult |         1.0|            2|      2|
| brooke | gameresult |         0.5|            1|      2|
| dean   | gameresult |         0.0|            0|      2|
| hana   | gameresult |         0.5|            1|      2|
| ife    | gameresult |         1.0|            1|      1|
| lisa   | gameresult |         0.5|            1|      2|
| mark   | gameresult |         0.0|            0|      1|
| mateo  | gameresult |         1.0|            1|      1|
| rohit  | gameresult |         1.0|            1|      1|

Now let's redo the back check where this time we do a t-test for the differences between the survey data and the back check.

``` r
result <- bcstats(surveydata  = survey,
                  bcdata      = bc,
                  id          = "id",
                  t1vars      = "gender",
                  t2vars      = "gameresult",
                  t3vars      = "itemssold",
                  enumerator  = "enum",
                  enumteam    = "enumteam",
                  backchecker = "bcer",
                  ttest       = "itemssold")
```

You can find the results for the t-test as an element of the results list.

``` r
print(result[["ttest"]]$itemssold)
```

    ## 
    ##  Paired t-test
    ## 
    ## data:  as.numeric(pairwise.var$value.survey) and as.numeric(pairwise.var$value.backcheck)
    ## t = -2.0656, df = 6, p-value = 0.0844
    ## alternative hypothesis: true difference in means is not equal to 0
    ## 95 percent confidence interval:
    ##  -2.4966927  0.2109784
    ## sample estimates:
    ## mean of the differences 
    ##               -1.142857

We could have choosen to not code some changes as errors as follows,

``` r
result <- bcstats(surveydata  = survey,
                  bcdata      = bc,
                  id          = "id",
                  t1vars      = "gender",
                  t2vars      = "gameresult",
                  t3vars      = "itemssold",
                  enumerator  = "enum",
                  enumteam    = "enumteam",
                  backchecker = "bcer",
                  nodiff      = list(itemssold = c(0)))
```

or specify an acceptable range,

``` r
result <- bcstats(surveydata  = survey,
                  bcdata      = bc,
                  id          = "id",
                  t1vars      = "gender",
                  t2vars      = "gameresult",
                  t3vars      = "itemssold",
                  enumerator  = "enum",
                  enumteam    = "enumteam",
                  backchecker = "bcer",
                  okrange     = list(itemssold = c(0, 5)))
```

or exclude them all together.

``` r
result <- bcstats(surveydata  = survey,
                  bcdata      = bc,
                  id          = "id",
                  t1vars      = "gender",
                  t2vars      = "gameresult",
                  t3vars      = "itemssold",
                  enumerator  = "enum",
                  enumteam    = "enumteam",
                  backchecker = "bcer",
                  exclude     = list(itemssold = c(0)))
```

Check out all the features of `bcstats` in the help page.

``` r
help(bcstats)
```
