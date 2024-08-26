#' Convert Text Input to Vector
#'
#' The goal of this function is to take text input and convert it
#' to an R vector.
#'
#' @param text_input A string input to be converted to a vector.
#'
#' @return A vector parsed from the input string.
#'
#' @examples
#'
#' text_to_vector("1,2,3,4,5")
#'
#' text_to_vector("1:5")
#'
#' text_to_vector("rep(1:5, times = 2)")
#'
#' text_to_vector("seq(1,10,2)")
#'
#' @export
text_to_vector <- function(text_input) {
  # Check if the input is a simple comma-separated string
  if (!grepl("^[^,]+$", text_input) && !grepl("[()]", text_input)) {
    text_input <- paste0("c(", text_input, ")")
  }
  eval(parse(text = text_input))
}

#' Convert Text Input to List
#'
#' @param text_input A text representation of a list.
#'
#' @return A list parsed from the input string.
#'
#' @examples
#' # Create a named list
#' text_to_list("'one' = 1, 'two' = 2, 'three' = 3")
#'
#' # Create a list of vectors
#' text_to_list("c('x1', 'x2'), c('x3', 'x4')")
#'
#' @export
text_to_list <- function(text_input) {
  eval(parse(text = paste0("list(", text_input, ")")))
}
