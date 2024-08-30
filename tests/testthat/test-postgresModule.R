# test_that("postgresModule works with single line of input", {
#
#   # Build shiny app that submits rows of the cars dataset to database
#   carsTestApp <- function(){
#     ui <- shiny::fluidPage(
#       shiny::titlePanel("PostgreSQL Data Management"),
#       shiny::sidebarLayout(
#         shiny::sidebarPanel(
#           shiny::actionButton("next_row", "Next Row"),
#           shiny::textOutput("rowCounter"),
#           postgresUI("postgres")$submit
#         ),
#         shiny::mainPanel(
#           postgresUI("postgres")$table
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
#       # Create a reactive value to store the counter
#       counter <- shiny::reactiveVal(0)
#
#       # Reactive expression for the current row of data
#       current_row <- shiny::reactive({
#         row_num <- (counter() - 1) %% nrow(cars) + 1
#         cars[row_num, , drop = FALSE]
#       })
#
#       # Initialize the postgres module
#       postgres_module <- postgresServer("postgres",
#                                         dbname = db_config$dbname,
#                                         datatable = db_config$datatable,
#                                         host = db_config$host,
#                                         port = db_config$port,
#                                         user = db_config$user,
#                                         password = db_config$password,
#                                         data = current_row)
#
#       # When the Next Row button is clicked, increment the counter
#       shiny::observeEvent(input$next_row, {
#         counter(counter() + 1)
#         # Update the data_to_submit in the module
#         postgres_module$data_to_submit(current_row())
#       })
#
#       # Display the current row number
#       output$rowCounter <- shiny::renderText({
#         if(counter() == 0) {
#           "No rows selected yet"
#         } else {
#           sprintf("Current row: %d", ((counter() - 1) %% nrow(cars) + 1))
#         }
#       })
#
#       # Clear data_to_submit after successful submission
#       shiny::observeEvent(postgres_module$current_data(), {
#         postgres_module$data_to_submit(NULL)
#       })
#     }
#
#     shiny::shinyApp(ui, server)
#   }
#
#   sap <- carsTestApp()
#
#   expect_s3_class(sap, "shiny.appobj")
# })
#
# test_that("postgresModule works with multiple lines of input", {
#
#   # Build shiny app that submits the cars dataset to database
#   carsTestApp <- function(){
#     ui <- shiny::fluidPage(
#       shiny::titlePanel("PostgreSQL Data Management"),
#       shiny::sidebarLayout(
#         shiny::sidebarPanel(
#           shiny::actionButton("load_data", "Load Cars Data"),
#           postgresUI("postgres")$submit
#         ),
#         shiny::mainPanel(
#           postgresUI("postgres")$table
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
#       # When the Load Data button is clicked, load the cars dataset
#       shiny::observeEvent(input$load_data, {
#         postgres_module$data_to_submit(cars)
#       })
#
#       # Initialize the postgres module
#       postgres_module <- postgresServer("postgres",
#                                         dbname = db_config$dbname,
#                                         datatable = db_config$datatable,
#                                         host = db_config$host,
#                                         port = db_config$port,
#                                         user = db_config$user,
#                                         password = db_config$password,
#                                         data = data_to_submit)
#
#       # Clear data_to_submit after successful submission
#       shiny::observeEvent(postgres_module$current_data(), {
#         postgres_module$data_to_submit(NULL)
#       })
#     }
#
#     shiny::shinyApp(ui, server)
#   }
#
#   sap <- carsTestApp()
#
#   expect_s3_class(sap, "shiny.appobj")
# })
