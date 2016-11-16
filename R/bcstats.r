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
bcstats = function(surveydata,
                   bcdata,
                   id,
                   t1vars,
                   t2vars,
                   t3vars) {
    merge(surveydata, bcdata, by = id)
}
