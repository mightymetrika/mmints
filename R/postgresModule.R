# Module UI function
postgresUI <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    DT::DTOutput(ns("data_table"))
  )
}

# Module server function
postgresServer <- function(id, dbname, datatable, host, port, user, password) {
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
      on.exit(pool::poolClose(pool))

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
      on.exit(pool::poolClose(pool))

      query <- sprintf("SELECT * FROM %s", datatable)
      pool::dbGetQuery(pool, query)
    }

    # Reactive value to store the current data
    current_data <- shiny::reactiveVal(NULL)

    # Load data when the module initializes
    shiny::observe({
      data <- loadData()
      current_data(data)
    })

    # Render data table
    output$data_table <- DT::renderDT({
      current_data()
    })

    # Return functions to be used in the main app
    list(
      saveData = saveData,
      loadData = loadData,
      current_data = current_data
    )
  })
}
