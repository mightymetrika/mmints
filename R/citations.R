#' Format Citation
#'
#' This function formats a citation object into a format ready for use in 'shiny'
#' applications
#'
#' @param cit A citation object obtained from \code{utils::citation()}.
#'
#' @return A character string containing the formatted citation.
#'
#' @examples
#' format_citation(utils::citation("base"))
#'
#' @export
format_citation <- function(cit) {
  title <- cit$title
  author <- if (is.null(cit$author)) {
    cit$organization
  } else {
    paste(sapply(cit$author, function(a) paste(a$given, a$family)), collapse = ", ")
  }
  year <- cit$year
  address <- cit$address
  url <- cit$url
  note <- cit$note

  formatted_cit <- paste0(
    author, " (", year, "). ",
    title, ". ",
    note, ", ",
    "Retrieved from ", url, ". ",
    address
  )

  formatted_cit
}
