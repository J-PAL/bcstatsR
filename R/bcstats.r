#' Comparing "back checks" in R (a clone of Stata's bcstats)
#' 
#' @param surveydata The survey data
#' @param bcdata The back check data
#' @param id the unique ID
#' @param t1vars The list of "type 1" variables
#' @param t2vars The list of "type 2" variables
#' @param t3vars The list of "type 3" variables
#' @return A data.frame with the error rates

#' @export
bcstats <- function(surveydata,
                    bcdata,
                    id,
                    t1vars   = NA,
                    t2vars   = NA,
                    t3vars   = NA,
                    ttest    = NA,
                    signrank = NA) {

    results  <- list(back_check = NA,
                     ttest      = vector("list"),
                     signrank   = vector("list"))
    pairwise <- merge(melt(surveydata, id = id),
                      melt(bcdata,     id = id),
                      by       = c(id,        "variable"),
                      suffixes = c(".survey", ".back_check"))

    pairwise$type                                <- ""
    pairwise$type[pairwise$variable %in% t1vars] <- "Type 1"
    pairwise$type[pairwise$variable %in% t2vars] <- "Type 2"
    pairwise$type[pairwise$variable %in% t3vars] <- "Type 3"

    # Create a logical value for whether or not the entry contains an error
    pairwise$equal <- pairwise$value.survey == pairwise$value.back_check
    
    # Restrict the data to cases where there is an error
    back_check <- pairwise[which(pairwise$equal != TRUE),
                           c(id,
                           "type",
                           "variable",
                           "value.survey",
                           "value.back_check")]
    results$back_check <- back_check

    # Run the t-tests
    if (!is.na(ttest)) {
        for (var in ttest) {
            pairwise.var         <- pairwise[which(pairwise$variable == var),  ]
            results$ttest[[var]] <- t.test(pairwise.var$value.survey,
                                           pairwise.var$value.back_check,
                                           paired = TRUE)    
        }
    }

    # Run the Wilcoxon signed rank test
    if (!is.na(signrank)) {
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
