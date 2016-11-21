#' Comparing "back checks" in R (a clone of Stata's bcstats)
#' 
#' @param surveydata The survey data
#' @param bcdata The back check data
#' @param id The unique ID
#' @param enumerator Display enumerators with high error rates and variables with high error rates for those enumerators
#' @param t1vars The list of "type 1" variables
#' @param t2vars The list of "type 2" variables
#' @param t3vars The list of "type 3" variables
#' @param ttest Run paired two-sample mean-comparison tests for varlist in the back check and survey data using ttest
#' @param level Set confidence level for ttest; default is 0.95
#' @param signrank Run Wilcoxon matched-pairs signed-ranks tests in the back check and survey data using signrank
#' @param lower convert all string variables to lower case before comparing
#' @param upper convert all string variables to upper case before comparing
#' @param nosymbol replace symbols with spaces in string variables before comparing
#' @param trim remove leading or trailing blanks and multiple, consecutive internal blanks in string variables before comparing
#' @return A list constaining the back check as a data.frame, error rates by groups, and tests for differences

#' @export
bcstats <- function(surveydata,
                    bcdata,
                    id,
                    enumerator = NA,
                    t1vars     = NA,
                    t2vars     = NA,
                    t3vars     = NA,
                    ttest      = NA,
                    level      = 0.95,
                    signrank   = NA,
                    lower      = FALSE,
                    upper      = FALSE,
                    nosymbol   = FALSE,
                    trim       = FALSE) {

    # Create list that will store all the results
    results  <- list(back_check = NA,
                     enum1      = vector("list"),
                     enum2      = vector("list"),
                     ttest      = vector("list"),
                     signrank   = vector("list"))

    # Pre-process data when needed
    surveydata <- .bcstats.pre(pp.data  = surveydata,
                               lower    = lower,
                               upper    = upper,
                               trim     = trim,
                               nosymbol = nosymbol)
    bcdata     <- .bcstats.pre(pp.data  = bcdata,
                               lower    = lower,
                               upper    = upper,
                               trim     = trim,
                               nosymbol = nosymbol)

    pairwise <- merge(melt(surveydata, id = id),
                      melt(bcdata,     id = id),
                      by       = c(id,        "variable"),
                      suffixes = c(".survey", ".back_check"))

    # Categorize error types
    pairwise$type                                <- ""
    pairwise$type[pairwise$variable %in% t1vars] <- "Type 1"
    pairwise$type[pairwise$variable %in% t2vars] <- "Type 2"
    pairwise$type[pairwise$variable %in% t3vars] <- "Type 3"
    pairwise                                     <- pairwise[which(pairwise$type != ""),]

    # Create a logical value for whether or not the entry contains an error
    pairwise$error <- pairwise$value.survey != pairwise$value.back_check
    pairwise$error <- !(pairwise$error %in% FALSE)

    # Type 3 variables do not have errors
    pairwise$error[pairwise$variable == "Type 3"] <- FALSE
    
    # Identifiers
    id_vars <- c(id, enumerator)
    id_vars <- id_vars[!is.na(id_vars)]

    # Merge back in identifiers
    pairwise <- merge(pairwise,
                      surveydata[, id_vars],
                      all = FALSE,
                      by  = id)

    # Restrict the data to cases where there is an error
    back_check           <- pairwise[which(pairwise$error == TRUE),
                                     c(id_vars,
                                       "type",
                                       "variable",
                                       "value.survey",
                                       "value.back_check",
                                       "error")]
    rownames(back_check) <- NULL
    # order_vars           <- c(id_vars, "type", "variable")
    # back_check           <- back_check %>% arrange_(.dots = order_vars)
    results$back_check   <- back_check[,
                                       c(id_vars,
                                         "type",
                                         "variable",
                                         "value.survey",
                                         "value.back_check")]

    if (is.na(enumerator) | is.na(t1vars)) {
      results$enum1 <- NULL
    } else {
      calc.error.by.group        <- .calc.error.by.group(pairwise   = pairwise,
                                                         id         = id,
                                                         group.id   = enumerator,
                                                         error.type = "Type 1")
      results$enum1[["summary"]] <- calc.error.by.group$summary
      results$enum1[["each"]]    <- calc.error.by.group$each
    }

    if (is.na(enumerator) | is.na(t2vars)) {
      results$enum2 <- NULL
    } else {
      calc.error.by.group        <- .calc.error.by.group(pairwise   = pairwise,
                                                         id         = id,
                                                         group.id   = enumerator,
                                                         error.type = "Type 2")
      results$enum2[["summary"]] <- calc.error.by.group$summary
      results$enum2[["each"]]    <- calc.error.by.group$each
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
.calc.error.by.group <- function(pairwise,
                                 id,
                                 group.id,
                                 error.type) {

      results.by.group <- list(summary = NA,
                               each    = NA)

      pairwise$error[pairwise$type == error.type] <- FALSE

      summary   <- aggregate(pairwise[ , c("error")],
                             by  = list(pairwise[[group.id]]),
                             FUN = mean)
      each      <- aggregate(pairwise[ , c("error")],
                             by  = list(pairwise[[group.id]],
                                        pairwise$variable),
                             FUN = mean)

      # Name the columns
      names(summary) <- c(group.id, "error.rate")
      names(each)    <- c(group.id, "variable", "error.rate")

      # Export results
      results.by.group$summary <- summary
      results.by.group$each    <- each
      return(results.by.group)
}

# Functions that pre-proccesses the data
.bcstats.pre <- function(pp.data, lower, upper, trim, nosymbol) {
    if (lower & upper) {
      stop("Cannot have both lower and upper case at the same time")
    } else if (lower) {
      pp.data <- data.frame(lapply(pp.data, .lower.ifchar), stringsAsFactors = FALSE)
    } else if (upper) {
      pp.data <- data.frame(lapply(pp.data, .upper.ifchar), stringsAsFactors = FALSE)
    }

    if (trim) {
      pp.data <- data.frame(lapply(pp.data, .trim.ifchar), stringsAsFactors = FALSE)
    }

    if (nosymbol) {
      pp.data <- data.frame(lapply(pp.data, .nosymbols.ifchar), stringsAsFactors = FALSE)
    }

    return(pp.data)
}

# Change to upper only if vector is character
.upper.ifchar <- function(x) {
  if (class(x) == "character") {
    toupper(x)
  } else {
    x
  }
}

# Change to lower only if vector is character
.lower.ifchar <- function(x) {
  if (class(x) == "character") {
    tolower(x)
  } else {
    x
  }
}

# Trim only if vector is character
.trim.ifchar <- function(x) {
  if (class(x) == "character") {
    trimws(x)
  } else {
    x
  }
}

# Remove symbols only if vector is character
.nosymbols.ifchar <- function(x) {
  if (class(x) == "character") {
    gsub("[[:punct:]]", "", x)
  } else {
    x
  }
}

