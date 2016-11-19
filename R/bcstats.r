#' Comparing "back checks" in R (a clone of Stata's bcstats)
#' 
#' @param surveydata The survey data
#' @param bcdata The back check data
#' @param id the unique ID
#' @param t1vars The list of "type 1" variables
#' @param t2vars The list of "type 2" variables
#' @param t3vars The list of "type 3" variables
#' @param ttest Run paired two-sample mean-comparison tests for varlist in the back check and survey data using ttest
#' @param level Set confidence level for ttest; default is 0.95
#' @param signrank Run Wilcoxon matched-pairs signed-ranks tests in the back check and survey data using signrank
#' @return A list constaining the back check as a data.frame, error rates by groups, and tests for differences

#' @export
bcstats <- function(surveydata,
                    bcdata,
                    id,
                    t1vars   = NA,
                    t2vars   = NA,
                    t3vars   = NA,
                    ttest    = NA,
                    level    = 0.99,
                    signrank = NA) {

    results  <- list(back_check = NA,
                     enum1      = vector("list"),
                     enum2      = vector("list"),
                     ttest      = vector("list"),
                     signrank   = vector("list"))
    pairwise <- merge(melt(surveydata, id = id),
                      melt(bcdata,     id = id),
                      by       = c(id,        "variable"),
                      suffixes = c(".survey", ".back_check"))

    # Categorize error types
    pairwise$type                                <- ""
    pairwise$type[pairwise$variable %in% t1vars] <- "Type 1"
    pairwise$type[pairwise$variable %in% t2vars] <- "Type 2"
    pairwise$type[pairwise$variable %in% t3vars] <- "Type 3"

    # Create a logical value for whether or not the entry contains an error
    pairwise$error <- pairwise$value.survey == pairwise$value.back_check

    # Type 3 variables do not have errors
    pairwise$error[pairwise$variable == "Type 3"] <- FALSE
    
    # Restrict the data to cases where there is an error
    back_check         <- pairwise[which(pairwise$error != FALSE),
                                   c(id,
                                     "type",
                                     "variable",
                                     "value.survey",
                                     "value.back_check",
                                     "error")]
    results$back_check <- back_check[,
                                     c(id,
                                       "type",
                                       "variable",
                                       "value.survey",
                                       "value.back_check")]

    if (is.na(enumerator) | is.na(t1vars)) {
      results$enum1 <- NULL
    } else {
      calc.error.by.group        <- .calc.error.by.group(id         = id,
                                                         group.id   = enumerator,
                                                         surveydata = surveydata,
                                                         back_check = back_check,
                                                         error.type = "Type 1")
      results$enum1[["summary"]] <- calc.error.by.group$summary
      results$enum1[["each"]]    <- calc.error.by.group$each
    }

    if (is.na(enumerator) | is.na(t2vars)) {
      results$enum2 <- NULL
    } else {
      calc.error.by.group        <- .calc.error.by.group(id         = id,
                                                         group.id   = enumerator,
                                                         surveydata = surveydata,
                                                         back_check = back_check,
                                                         error.type = "Type 2")
      results$enum1[["summary"]] <- calc.error.by.group$summary
      results$enum1[["each"]]    <- calc.error.by.group$each
    }

    if (is.na(enumerator) | is.na(t1vars)) {
      results$enum1 <- NULL
    } else {
      calc.error.by.group        <- .calc.error.by.group(id         = id,
                                                         group.id   = enumerator,
                                                         surveydata = surveydata,
                                                         back_check = back_check,
                                                         error.type = "Type 1")
      results$enum1[["summary"]] <- calc.error.by.group$summary
      results$enum1[["each"]]    <- calc.error.by.group$each
    }

    if (is.na(enumerator) | is.na(t2vars)) {
      results$enum2 <- NULL
    } else {
      calc.error.by.group        <- .calc.error.by.group(id         = id,
                                                         group.id   = enumerator,
                                                         surveydata = surveydata,
                                                         back_check = back_check,
                                                         error.type = "Type 2")
      results$enum1[["summary"]] <- calc.error.by.group$summary
      results$enum1[["each"]]    <- calc.error.by.group$each
    }

    # Run the t-tests (if none specified remove from results)
    if (is.na(ttest)) {
      results[["ttest"]] <- NULL
    } else {
        for (var in ttest) {
            pairwise.var         <- pairwise[which(pairwise$variable == var),  ]
            results$ttest[[var]] <- t.test(pairwise.var$value.survey,
                                           pairwise.var$value.back_check,
                                           paired     = TRUE,
                                           conf.level = level)    
        }
    }

    # Run the Wilcoxon signed rank test (if none specified remove from results)
    if (is.na(signrank)) {
      results[["signrank"]] <- NULL
    } else {
        for (var in signrank) {
            pairwise.var            <- pairwise[which(pairwise$variable == var),  ]
            results$signrank[[var]] <- wilcox.test(pairwise.var$value.survey,
                                                   pairwise.var$value.back_check,
                                                   paired = TRUE)    
        }
    }

    # Return the results
    return(results)
}

# Helper function that calculates error rates by group id (e.g., enumerator, team)
.calc.error.by.group <- function(id,
                                 group.id,
                                 surveydata,
                                 back_check,
                                 error.type) {

      results.by.group <- list(summary = NA,
                               each    = NA)

      merge.gid <- merge(back_check[which(back_check$type == error.type), ],
                         surveydata[, c(id, group.id)],
                         all = FALSE,
                         by  = id)
      summary   <- aggregate(merge.gid$error,
                             by  = list(merge.gid[[group.id]]),
                             FUN = mean)
      each      <- aggregate(merge.gid$error,
                             by  = list(merge.gid[[group.id]],
                                         merge.gid$variable),
                             FUN = mean)

      # Name the columns
      names(summary) <- c(group.id, "error.rate")
      names(each)    <- c(group.id, "variable", "error.rate")

      # Export results
      results.by.group$summary <- summary
      results.by.group$each    <- each
      return(results.by.group)
}
