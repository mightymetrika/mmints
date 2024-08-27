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

#' Handle Null Values for Text to Vector Conversion
#'
#' @param par_input A string input, default is "".
#' @param alt_na If alt_na is not set to NULL (the default), then it is an
#' alternative string used to represent NA. Usually, this is a string such as
#' "NA", "NaN", etc.
#'
#' @return NULL if input is NA, if input is empty, or if input is alt_na (and alt_na
#' is not NULL). Otherwise, return a vector.
#'
#' @examples
#' # Convert missing value to NULL
#' vec_null()
#' vec_null(NA)
#' vec_null("na", alt_na="na")
#'
#' # Convert string to vector when input is not missing
#' num_vec <- vec_null("2,8,3,7")
#'
#' # Convert string to NULL when a single element is missing
#' vec_null("2,3,NA,5", "NA")
#'
#' @export
vec_null <- function(par_input = "", alt_na = NULL) {
  if (is.na(par_input) || par_input == "") {
    return(NULL)
  } else if (!is.null(alt_na)){
    if(par_input == alt_na) return (NULL)
  } else {
    return(text_to_vector(par_input))
  }
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

#' Handle Null Values for Text to List Conversions
#'
#' @param par_input A string input, default is "".
#' @param alt_na If alt_na is not set to NULL (the default), then it is an
#' alternative string used to represent NA. Usually, this is a string such as
#' "NA", "NaN", etc
#'
#' @return NULL if input is NA, if input is empty, or if input is alt_na (and
#' alt_na is not NULL). Otherwise return a parsed list.
#'
#' @examples
#' # Convert missing value to null
#' list_null()
#' list_null(NA)
#' list_null("na", alt_na="na")
#'
#' # Convert non-missing value to list
#' list_null("'one' = 1, 'two' = 2, 'three' = 3")
#'
#' # Convert to null when a single vector is missing
#' list_null("'one' = 1, 'two' = NA, 'three' = 3", alt_na = "NA")
#' list_null("'one' = 1, NA, 'three' = 3", alt_na = "NA")
#'
#' @export
list_null <- function(par_input = "", alt_na = NULL) {
  if (is.na(par_input) || par_input == "") {
    return(NULL)
  } else if (!is.null(alt_na)) {
    if(par_input == alt_na) return (NULL)
  } else {
    return(text_to_list(par_input))
  }
}
