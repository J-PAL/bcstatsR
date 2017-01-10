# Test against Stata equivalent
data(survey, bc)
r.result  <- bcstats(surveydata  = survey,
                     bcdata      = bc,
                     id          = "id",
                     t1vars      = "gender",
                     t2vars      = "gameresult",
                     t3vars      = "itemssold",
                     enumerator  = "enum",
                     enumteam    = "enumteam",
                     backchecker = "bcer")

test_that("backcheck have equal values", {
  # Extract back check from bcstats
  r.bc_base <- r.result[["backcheck"]]

  # Load backcheck results from test_bcstats.do
  stata.bc_base <- read.csv("bc_base.csv",
                            stringsAsFactors = FALSE,
                            row.names        = NULL,
                            na.strings       = c('.', NA))
  # Rename Stata columns to match R
  dplyr::rename(stata.bc_base,
                value.survey    = survey,
                value.backcheck = back_check)
  # Reorder for comparison
  stata.bc_base <- stata.bc_base[with(stata.bc_base, order(id, enum, type)), ]
  r.bc_base     <- r.bc_base[with(r.bc_base, order(id, enum, type)), ]
  # Test for equivalence
  expect_equivalent(stata.bc_base, r.bc_base)
})

enumteam2_base <- read.csv("enumteam2_base.tsv",
                           sep = "\t",
                           stringsAsFactors = FALSE,
                           row.names = NULL)

test_that("enum1 have equal values", {
  enum1_base   <- read.csv("enum1_base.tsv",
                           sep = "\t",
                           stringsAsFactors = FALSE,
                           row.names = NULL)
  enum1_merged <- merge(r.result[["enum1"]]$summary,
                        enum1_base,
                        by = "enum")
  dplyr::rename(enum1_merged,
               r.error.rate = error.rate,
               stata.error.rate = error_rate)
  expect_equal(enum1_merged$error.rate, enum1_merged$error_rate)
})

test_that("enum2 have equal values", {
  enum2_base     <- read.csv("enum2_base.tsv",
                       sep = "\t",
                       stringsAsFactors = FALSE,
                       row.names = NULL)

  enum2_merged <- merge(r.result[["enum2"]]$summary,
                       enum2_base,
                       by = "enum")
  dplyr::rename(enum2_merged,
               r.error.rate = error.rate,
               stata.error.rate = error_rate)
  expect_equal(enum2_merged$error.rate, enum2_merged$error_rate)
})

test_that("enumteam1 have equal values", {
     enumteam1_base <- read.csv("enumteam1_base.tsv",
                           sep = "\t",
                           stringsAsFactors = FALSE,
                           row.names = NULL)
     enumteam1_merged <- merge(r.result[["enumteam1"]]$summary,
                           enumteam1_base,
                           by = "enumteam")
     dplyr::rename(enumteam1_merged,
                   r.error.rate = error.rate,
                   stata.error.rate = error_rate)
     expect_equal(enumteam1_merged$error.rate, enumteam1_merged$error_rate)
})

test_that("enumteam2 have equal values", {
     enumteam2_base <- read.csv("enumteam2_base.tsv",
                           sep = "\t",
                           stringsAsFactors = FALSE,
                           row.names = NULL)
     enumteam2_merged <- merge(r.result[["enumteam2"]]$summary,
                               enumteam2_base,
                                by = "enumteam")
     dplyr::rename(enumteam2_merged,
                   r.error.rate = error.rate,
                   stata.error.rate = error_rate)
     expect_equal(enumteam2_merged$error.rate, enumteam2_merged$error_rate)
})

