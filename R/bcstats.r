#' Join two data frames together 
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
                   t1vars,
                   t2vars,
                   t3vars) {

    # Check if data.frames contain the variables specified
    stopifnot(id     %in% names(surveydata),
              id     %in% names(bcdata),
              t1vars %in% names(surveydata),
              t1vars %in% names(bcdata),
              t2vars %in% names(surveydata),
              t2vars %in% names(bcdata),
              t3vars %in% names(surveydata),
              t3vars %in% names(bcdata))

    merged.df <- merge(surveydata,
                       bcdata,
                       by  = id,
                       all = TRUE,
                       suffixes = c(".s",".b"))

}

# http://codereview.stackexchange.com/questions/94253/identify-changes-between-two-data-frames-explain-deltas-for-x-columns
