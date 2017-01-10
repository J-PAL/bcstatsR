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

# Load enum1 resuts from test_bcstats.do
enum1_base     <- read.csv("enum1_base.tsv", sep = "\t", stringsAsFactors = FALSE)
enum2_base     <- read.csv("enum2_base.tsv", sep = "\t", stringsAsFactors = FALSE)
enumteam1_base <- read.csv("enumteam1_base.tsv", sep = "\t", stringsAsFactors = FALSE)
enumteam2_base <- read.csv("enumteam2_base.tsv", sep = "\t", stringsAsFactors = FALSE)

test_that("enum1 have equal values", {
  enum1_merged <- merge(r.result[["enum1"]]$summary,
                        enum1_base,
                        by = "enum")
     dplyr::rename(enum1_merged,
                   r.error.rate = error.rate,
                   stata.error.rate = error_rate)
     expect_equal(enum1_merged$error.rate, enum1_merged$error_rate)
})

test_that("enum2 have equal values", {
     enum2_merged <- merge(r.result[["enum2"]]$summary,
                           enum2_base,
                           by = "enum")
     dplyr::rename(enum2_merged,
                   r.error.rate = error.rate,
                   stata.error.rate = error_rate)
     expect_equal(enum2_merged$error.rate, enum2_merged$error_rate)
})

