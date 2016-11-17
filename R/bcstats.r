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
                    t1vars = NA,
                    t2vars = NA,
                    t3vars = NA) {

    merged.df <- merge(melt(surveydata, id = "id"),
                       melt(bcdata,     id = "id"),
                       by       = c("id",      "variable"),
                       suffixes = c(".survey", ".back_check"))

    merged.df$type                                 <- ""
    merged.df$type[merged.df$variable %in% t1vars] <- "Type 1"
    merged.df$type[merged.df$variable %in% t2vars] <- "Type 2"
    merged.df$type[merged.df$variable %in% t3vars] <- "Type 3"
    return(merged.df[which(merged.df$value.survey != merged.df$value.back_check),
                     c("id", "type", "variable", "value.survey", "value.back_check")])
}
