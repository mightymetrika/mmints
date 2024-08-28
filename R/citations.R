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
