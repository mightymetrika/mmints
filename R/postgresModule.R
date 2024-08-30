# Module UI function
postgresUI <- function(id) {
  ns <- shiny::NS(id)
  list(
    submit = shiny::tagList(
      shiny::actionButton(ns("submit"), "Submit Data")
    ),
    table = shiny::tagList(
      DT::DTOutput(ns("data_table"))
    )
  )
}


# Module server function
postgresServer <- function(id, dbname, datatable, host, port, user, password, data) {
  shiny::moduleServer(id, function(input, output, session) {

    # Function to create database connection
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

    # Function to sanitize column names
    sanitize_colnames <- function(data) {
      colnames(data) <- make.names(colnames(data), unique = TRUE)
      data
    }

    # Function to save data
    saveData <- function(data) {
      pool <- connect_db()

      # Close pool on stop
      shiny::onStop(function() {
        pool::poolClose(pool)
      })

      data <- sanitize_colnames(data)
      data[is.na(data)] <- NaN

      if (nrow(data) == 1) {
        # Single line insert
        query <- sprintf(
          "INSERT INTO %s (%s) VALUES ('%s')",
          datatable,
          paste(names(data), collapse = ", "),
          paste(data, collapse = "', '")
        )
        pool::dbExecute(pool, query)
      } else {
        # Loop through rows of data and save to database
        lapply(1:nrow(data), function(i){
          row_data <- data[i, ]
          query <- sprintf(
            "INSERT INTO %s (%s) VALUES ('%s')",
            datatable,
            paste(names(row_data), collapse = ", "),
            paste(row_data, collapse = "', '")
          )
          tryCatch({
            pool::dbExecute(pool, query)
          }, error = function(e) {
            print(paste("Error inserting row", i, ":", e))
          })
        })
      }
    }

    # Function to load data
    loadData <- function() {
      pool <- connect_db()

      # Close pool on stop
      shiny::onStop(function() {
        pool::poolClose(pool)
      })

      query <- sprintf("SELECT * FROM %s", datatable)
      pool::dbGetQuery(pool, query)
    }

    # Reactive value to store the current data
    current_data <- shiny::reactiveVal(NULL)

    # Reactive value to store the data to be submitted
    data_to_submit <- shiny::reactiveVal(NULL)

    # Load data when the module initializes
    shiny::observe({
      data <- loadData()
      current_data(data)
    })

    # Handle submit button click
    shiny::observeEvent(input$submit, {
      # Check if there's data to submit
      if (is.null(data_to_submit()) || nrow(data_to_submit()) == 0) {
        shiny::showModal(shiny::modalDialog(
          title = "Error",
          "No data to submit. Please ensure data is available before submitting.",
          easyClose = TRUE,
          footer = NULL
        ))
        return()
      }

      # Check if the data to be submitted is different from the current data
      if (!is.null(current_data()) && identical(data_to_submit(), current_data())) {
        shiny::showModal(shiny::modalDialog(
          title = "Warning",
          "This data has already been submitted. Do you want to submit it again?",
          footer = shiny::tagList(
            shiny::modalButton("Cancel"),
            shiny::actionButton(session$ns("confirm_submit"), "Submit Anyway")
          )
        ))
      } else {
        # If data is different, submit immediately
        submit_data()
      }
    })

    # Handle confirmation of submission for duplicate data
    shiny::observeEvent(input$confirm_submit, {
      submit_data()
      shiny::removeModal()
    })

    # Function to submit data
    submit_data <- function() {
      tryCatch({
        saveData(data_to_submit())
        shiny::showNotification("Data saved successfully", type = "message")

        # Reload the data to update the table
        new_data <- loadData()
        current_data(new_data)

        # Clear the data to be submitted
        data_to_submit(NULL)
      }, error = function(e) {
        shiny::showNotification(paste("Error saving data:", e$message), type = "error")
      })
    }

    # Render data table
    output$data_table <- DT::renderDT({
      current_data()
    })

    # Return functions to be used in the main app
    list(
      saveData = saveData,
      loadData = loadData,
      current_data = current_data,
      data_to_submit = data_to_submit
    )
  })
}
