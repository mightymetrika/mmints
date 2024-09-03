#' UI Function for Citation Module
#'
#' This function creates the UI elements for the citation module.
#'
#' @param id A character string that defines the namespace for the module.
#'
#' @return A list containing two elements:
#'   \itemize{
#'     \item \code{button}: An action button to show citations.
#'     \item \code{output}: A tag list containing the citation header and output.
#'   }
#'
#' @examples
#' citationUI("my_citations")
#'
#' @export
citationUI <- function(id) {

  # create namespaced IDs
  ns <- shiny::NS(id)

  # create ui elements
  list(
    button = shiny::actionButton(ns("show_citations"), "Show Citations"),
    output = shiny::tagList(
      shiny::uiOutput(ns("citation_header")),
      shiny::verbatimTextOutput(ns("citations_output"))
    )
  )

}

#' Server Function for Citation Module
#'
#' This function defines the server logic for the citation module.
#'
#' @param id A character string that matches the ID used in \code{citationUI}.
#' @param citations A named list of citations. Each element can be:
#'   \itemize{
#'     \item A character string containing a formatted citation.
#'     \item A function that returns a formatted citation string.
#'     \item A citation object that can be passed to \code{format_citation}.
#'   }
#'
#' @return A Shiny module server function.
#'
#' @examples
#' citations <- list(
#'   "Example Citation" = "Author, A. (Year). Title. Journal, Vol(Issue), pages.",
#'   "R Citation" = function() format_citation(utils::citation())
#' )
#' server <- function(input, output, session) {
#'   citationServer("my_citations", citations)
#' }
#'
#' @export
citationServer <- function(id, citations) {
  shiny::moduleServer(id, function(input, output, session) {

    # setup reactive values
    citations_text <- shiny::reactiveVal("")

    shiny::observeEvent(input$show_citations, {

      # build citation output
      formatted_citations <- vapply(names(citations), function(title) {
        citation <- citations[[title]]
        if (is.character(citation)) {
          formatted <- citation
        } else if (is.function(citation)) {
          formatted <- citation()
        } else {
          formatted <- format_citation(citation)
        }
        paste(title, formatted, sep = "\n")
      }, character(1))

      citations_text(paste(formatted_citations, collapse = "\n\n"))
    })

    # get citation title
    output$citation_header <- shiny::renderUI({
      shiny::req(citations_text())
      shiny::tags$h2("Citations")
    })

    # get citation content
    output$citations_output <- shiny::renderText({
      citations_text()
    })
  })
}
