#' Generate a Unique Run Code
#'
#' This function generates a unique run code for use in Shiny applications,
#' particularly those running simulations. The code combines a timestamp
#' with a random string to ensure uniqueness for each row or run.
#'
#' @param time_format A string specifying the format for the timestamp.
#'   Default is "%Y%m%d%H%M%S" (year, month, day, hour, minute, second).
#' @param string_length An integer specifying the length of the random string.
#'   Default is 5.
#'
#' @return A character string containing the unique run code, composed of
#'   a timestamp and a random alphanumeric string, separated by an underscore.
#'
#' @note This function uses the current system time and a random string
#'   to generate the run code. While collisions are extremely unlikely,
#'   they are theoretically possible, especially if the function is called
#'   multiple times within the same second and with a short string_length.
#'
#' @examples
#' generateRunCode()
#' generateRunCode(time_format = "%Y%m%d", string_length = 8)
#'
#' @export
generateRunCode <- function(time_format = "%Y%m%d%H%M%S", string_length = 5) {

  # generate time stamp
  timestamp <- format(Sys.time(), time_format)

  # generate random string of letters
  random_string <- paste(sample(c(letters, LETTERS, 0:9),
                                string_length, replace = TRUE), collapse = "")

  # paste pieces
  paste0(timestamp, "_", random_string)
}
