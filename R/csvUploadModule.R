#' UI Function for CSV Upload Module
#'
#' This function creates the UI elements for the CSV upload module.
#'
#' @param id A character string that defines the namespace for the module.
#'
#' @return A list containing two elements:
#'   \itemize{
#'     \item \code{input}: The file input UI for uploading a CSV file.
#'     \item \code{output}: The UI for displaying the variables table.
#'   }
#'
#' @examples
#' csvUploadUI("my_data")
#'
#' @export
csvUploadUI <- function(id) {

  # create namespaced IDs
  ns <- shiny::NS(id)

  # create ui elements
  list(
    input = shiny::tagList(
      shiny::tags$div(
        title = "Upload a CSV file with your data. The file should have headers corresponding to variable names.",
        shiny::fileInput(ns("datafile"), "Choose CSV File",
                         multiple = FALSE,
                         accept = c("text/csv",
                                    "text/comma-separated-values,text/plain",
                                    ".csv"))
      )
    ),
    output = shiny::tagList(
      shiny::uiOutput(ns("variables_title")),
      DT::DTOutput(ns("variables_table"))
    )
  )
}

#' Server Function for CSV Upload Module
#'
#' This function defines the server logic for the CSV upload module.
#'
#' @param id A character string that matches the ID used in \code{csvUploadUI}.
#' @param vars_title A character string for the title of the variables table.
#'
#' @return A reactive expression containing the uploaded data.
#'
#' @examples
#' server <- function(input, output, session) {
#'   csvUploadServer("my_data", "My Variables")
#' }
#'
#' @export
csvUploadServer <- function(id, vars_title = "Available Variables") {
  shiny::moduleServer(id, function(input, output, session) {

    # Reactive: Read the uploaded CSV file
    uploaded_data <- shiny::reactiveVal()

    # read in csv file
    shiny::observe({
      inFile <- input$datafile
      if (!is.null(inFile)) {
        data <- utils::read.csv(inFile$datapath, stringsAsFactors = TRUE)
        uploaded_data(data)
      }
    })

    # get variable title
    output$variables_title <- shiny::renderUI({
      if (!is.null(uploaded_data()) && nrow(uploaded_data()) > 0) {
        shiny::tags$h2(vars_title)
      }
    })

    # create DT datatable
    output$variables_table <- DT::renderDataTable({
      shiny::req(uploaded_data())
      data <- uploaded_data()
      df <- data.frame(Variable = names(data), Type = sapply(data, class))
      DT::datatable(df, editable = 'cell', options = list(pageLength = 5),
                    rownames = FALSE)
    })

    # change variable types based on user input
    shiny::observeEvent(input$variables_table_cell_edit, {
      info <- input$variables_table_cell_edit
      shiny::req(uploaded_data())
      data <- uploaded_data()

      row_number <- info$row
      new_value <- info$value

      if (info$col == 0) {
        tryCatch({
          names(data)[row_number] <- new_value
          uploaded_data(data)
        }, error = function(e) {
          shiny::showNotification(
            paste("Error in changing variable name:", e$message),
            type = "error",
            duration = NULL
          )
        })
      }

      if (info$col == 1) {
        variable_name <- names(data)[row_number]
        tryCatch({
          data[[variable_name]] <- switch(new_value,
                                          "factor" = as.factor(data[[variable_name]]),
                                          "numeric" = as.numeric(data[[variable_name]]),
                                          "integer" = as.integer(data[[variable_name]]),
                                          "double" = as.double(data[[variable_name]]),
                                          "character" = as.character(data[[variable_name]]),
                                          stop("New data type must be one of the following: factor, numeric, integer, double, character")
          )
          uploaded_data(data)
        }, error = function(e) {
          shiny::showNotification(
            paste("Error in changing data type:", e$message),
            type = "error",
            duration = NULL
          )
        })
      }
    })

    # Return the reactive data
    return(uploaded_data)
  })
}
