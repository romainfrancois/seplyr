



#' mutate non-standard evaluation interface.
#'
#' Mutate a data frame by the mutate terms from \code{...}.
#'
#' Note: this method as the default setting \code{mutate_nse_split_terms = TRUE}, which is
#' safer (avoiding certain known \code{dplyr}/\code{dblyr} issues)
#' (please see the side-notes of \url{http://winvector.github.io/FluidData/partition_mutate.html} for some references).
#'
#' @seealso \code{\link{mutate_se}}, \code{\link[dplyr]{mutate}}, \code{\link[dplyr]{mutate_at}}, \code{\link[wrapr]{:=}}
#'
#' @param .data data.frame
#' @param ... expressions to mutate by.
#' @param mutate_nse_split_terms logical, if TRUE into separate mutates (if FALSE instead, pass all at once to dplyr).
#' @param mutate_nse_env environment to work in.
#' @param mutate_nse_warn logical, if TRUE warn about name re-use.
#' @param mutate_nse_printPlan logical, if TRUE print the expression plan
#' @return .data with altered columns.
#'
#' @examples
#'
#'
#' limit <- 3.5
#'
#' datasets::iris %.>%
#'   mutate_nse(., Sepal_Long := Sepal.Length >= 2 * Sepal.Width,
#'                 Petal_Short := Petal.Length <= limit) %.>%
#'   head(.)
#'
#' # generates a warning
#' data.frame(x = 1, y = 2) %.>%
#'    mutate_nse(., x = y, y = x)
#'
#' @export
#'
mutate_nse <- function(.data, ...,
                       mutate_nse_split_terms = TRUE,
                       mutate_nse_env = parent.frame(),
                       mutate_nse_warn = TRUE,
                       mutate_nse_printPlan = FALSE) {
  force(mutate_nse_env)
  mutateTerms <- wrapr::qae(...)
  if(!(is.data.frame(.data) || dplyr::is.tbl(.data))) {
    stop("seplyr::mutate_nse first argument must be a data.frame or tbl")
  }
  res <- .data
  if(length(mutateTerms)>0) {
    res <- mutate_se(res, mutateTerms,
                     splitTerms = mutate_nse_split_terms,
                     env = mutate_nse_env,
                     warn = mutate_nse_warn,
                     printPlan = mutate_nse_printPlan)
  }
  res
}

