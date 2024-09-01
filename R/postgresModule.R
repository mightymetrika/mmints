#' Create UI elements for Postgres Shiny Module
#'
#' This function generates the UI components for the Postgres Shiny module,
#' including a submit button, a data table, and a download button.
#'
#' @param id A character string that uniquely identifies this module instance
#'
#' @return A list containing three UI elements:
#'   \item{submit}{An action button for submitting data to database}
#'   \item{table}{A DT output for displaying the database data}
#'   \item{download}{A download button for exporting database data to csv}
#'
#' @export
#'
#' @examples
#' shiny::fluidPage(
#'   postgresUI("postgres_module")$submit,
#'   postgresUI("postgres_module")$table,
#'   postgresUI("postgres_module")$download
#'   )
postgresUI <- function(id) {

  # create namespaced IDs
  ns <- shiny::NS(id)

  # create ui elements
  list(
    submit = shiny::tagList(
      shiny::actionButton(ns("submit"), "Submit Data")
    ),
    table = shiny::tagList(
      DT::DTOutput(ns("data_table"))
    ),
    download = shiny::tagList(
      shiny::downloadButton(ns("downloadBtn"), "Download Data")
    )
  )
}


#' Server function for Postgres Shiny Module
#'
#' This function sets up the server-side logic for the Postgres Shiny module,
#' handling database connections, data submission, retrieval, and download.
#'
#' @param id A character string that matches the ID used in `postgresUI()`
#' @param dbname A character string specifying the name of the database
#' @param datatable A character string specifying the name of the table in the database
#' @param host A character string specifying the host of the database
#' @param port A numeric value specifying the port number for the database connection
#' @param user A character string specifying the username for database access
#' @param password A character string specifying the password for database access
#' @param data A reactive expression that provides the data to be submitted
#'
#' @return A list of functions and reactive values:
#'   \item{saveData}{A function to save data to the database}
#'   \item{loadData}{A function to load data from the database}
#'   \item{current_data}{A reactive value containing the current data in the table}
#'   \item{data_to_submit}{A reactive value containing the data to be submitted}
#'
#' @export
#'
#' @examples
#' server <- function(input, output, session) {
#'   postgres_module <- postgresServer("postgres_module", "my_db", "my_table",
#'                                     "localhost", 5432, "user", "password",
#'                                     reactive({ input$data }))
#'  }
postgresServer <- function(id, dbname, datatable, host, port, user, password, data) {
  shiny::moduleServer(id, function(input, output, session) {

    # function to create database connection
    connect_db <- function() {
      pool::dbPool(
        drv = RPostgres::Postgres(),
        dbname = dbname,
        host = host,
        user = user,
        password = password,
        port = port
      )
    }

    # function to save data
    saveData <- function(data) {

      # create pool object
      pool <- connect_db()

      # close pool on stop
      shiny::onStop(function() {
        pool::poolClose(pool)
      })

      # convert NA to NaN for database
      data[is.na(data)] <- NaN

      # create database query
      if (nrow(data) == 1) {

        # single line insert
        query <- sprintf(
          "INSERT INTO %s (%s) VALUES ('%s')",
          datatable,
          paste(names(data), collapse = ", "),
          paste(data, collapse = "', '")
        )

        # send single line to database
        pool::dbExecute(pool, query)
      } else {
        # loop through rows of data and save to database
        lapply(1:nrow(data), function(i){

          # get row i
          row_data <- data[i, ]

          # create query for row i
          query <- sprintf(
            "INSERT INTO %s (%s) VALUES ('%s')",
            datatable,
            paste(names(row_data), collapse = ", "),
            paste(row_data, collapse = "', '")
          )

          # send row i to database
          tryCatch({
            pool::dbExecute(pool, query)
          }, error = function(e) {
            print(paste("Error inserting row", i, ":", e))
          })

        })
      }
    }

    # function to load data
    loadData <- function() {

      # create pool object
      pool <- connect_db()

      # close pool on stop
      shiny::onStop(function() {
        pool::poolClose(pool)
      })

      # get query
      query <- sprintf("SELECT * FROM %s", datatable)
      pool::dbGetQuery(pool, query)
    }

    # reactive value to store the current data
    current_data <- shiny::reactiveVal(NULL)

    # reactive value to store the data to be submitted to database
    data_to_submit <- shiny::reactiveVal(NULL)

    # load data when the module initializes. Store as current_data.
    shiny::observe({
      data <- loadData()
      current_data(data)
    })

    # Download handler for exporting data
    output$downloadBtn <- shiny::downloadHandler(
      filename = function() {
        paste0(datatable, "_", Sys.Date(), ".csv")
      },
      content = function(file) {
        # Use the current_data reactive value
        data_to_download <- current_data()

        # Write the data to a CSV file
        utils::write.csv(data_to_download, file, row.names = FALSE)
      }
    )

    # handle submit button click
    shiny::observeEvent(input$submit, {
      # check if there's data to submit
      if (is.null(data_to_submit()) || nrow(data_to_submit()) == 0) {
        shiny::showModal(shiny::modalDialog(
          title = "Error",
          "No data to submit. Please ensure data is available before submitting.",
          easyClose = TRUE,
          footer = NULL
        ))
        return()
      }

      # Submit data
      submit_data()
    })

    # function to submit data
    submit_data <- function() {
      tryCatch({
        saveData(data_to_submit())
        shiny::showNotification("Data saved successfully", type = "message")

        # reload the data to update the table
        new_data <- loadData()
        current_data(new_data)

        # clear the data to be submitted
        data_to_submit(NULL)
      }, error = function(e) {
        shiny::showNotification(paste("Error saving data:", e$message), type = "error")
      })
    }

    # render data table
    output$data_table <- DT::renderDT({
      current_data()
    })

    # return functions to be used in the main app
    list(
      saveData = saveData,
      loadData = loadData,
      current_data = current_data,
      data_to_submit = data_to_submit
    )
  })
}
