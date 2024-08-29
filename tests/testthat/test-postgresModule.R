# test_that("postgresModule works with single line of input", {
#
#   # Build shiny app that submits rows of the cars dataset to database
#   carsTestApp <- function(){
#     ui <- shiny::fluidPage(
#       shiny::titlePanel("PostgreSQL Data Management"),
#       shiny::sidebarLayout(
#         shiny::sidebarPanel(
#           shiny::actionButton("submit", "Submit Next Row"),
#           shiny::textOutput("rowCounter")
#         ),
#         shiny::mainPanel(
#           postgresUI("postgres")
#         )
#       )
#     )
#
#     server <- function(input, output, session) {
#       # Get database connection details from environment variables
#       db_config <- list(
#         dbname = Sys.getenv("DBNAME"),
#         datatable = Sys.getenv("DATATABLE"),
#         host = Sys.getenv("HOST"),
#         port = as.integer(Sys.getenv("PORT")),
#         user = Sys.getenv("USER"),
#         password = Sys.getenv("PASSWORD")
#       )
#
#       # Initialize the postgres module
#       postgres_module <- postgresServer("postgres",
#                                         dbname = db_config$dbname,
#                                         datatable = db_config$datatable,
#                                         host = db_config$host,
#                                         port = db_config$port,
#                                         user = db_config$user,
#                                         password = db_config$password)
#
#       # Create a reactive value to store the counter
#       counter <- shiny::reactiveVal(0)
#
#       # When the Submit button is clicked, save the next row of data
#       shiny::observeEvent(input$submit, {
#         # Increment the counter
#         counter(counter() + 1)
#
#         # Get the row number, wrapping around if we exceed the number of rows in cars
#         row_num <- (counter() - 1) %% nrow(cars) + 1
#
#         # Use the selected row of the cars dataset as sample data
#         sample_data <- cars[row_num, ]
#
#         # Save the data to the database
#         tryCatch({
#           postgres_module$saveData(sample_data)
#           shiny::showNotification(sprintf("Row %d saved successfully", row_num), type = "message")
#
#           # Reload the data to update the table
#           new_data <- postgres_module$loadData()
#           postgres_module$current_data(new_data)
#         }, error = function(e) {
#           shiny::showNotification(paste("Error saving data:", e$message), type = "error")
#         })
#       })
#
#       # Display the current row number
#       output$rowCounter <- shiny::renderText({
#         if(counter() == 0) {
#           "No rows submitted yet"
#         } else {
#           sprintf("Current row: %d", ((counter() - 1) %% nrow(cars) + 1))
#         }
#       })
#     }
#
#     shiny::shinyApp(ui, server)
#
#   }
#
#   sap <- carsTestApp()
#
#   expect_s3_class(sap, "shiny.appobj")
#
# })
