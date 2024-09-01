# test_that("Cars Random Sampling App works", {
#   # Build shiny app that randomly samples rows from the cars dataset and submits to database
#   carsRandomSamplingApp <- function() {
#     ui <- shiny::fluidPage(
#       shiny::titlePanel("Random Sampling from Cars Dataset"),
#       shiny::sidebarLayout(
#         shiny::sidebarPanel(
#           shiny::numericInput("sample_size", "Number of rows to sample:",
#                               value = 5, min = 1, max = nrow(cars)),
#           shiny::actionButton("sample_button", "Sample Data"),
#           postgresUI("postgres")$submit,
#           postgresUI("postgres")$download
#         ),
#         shiny::mainPanel(
#           shiny::uiOutput("sampled_data_title"),
#           shiny::tableOutput("sampled_data"),
#           shiny::h4("Database Content:"),
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
#       # Initialize the postgres module
#       postgres_module <- postgresServer("postgres",
#                                         dbname = db_config$dbname,
#                                         datatable = db_config$datatable,
#                                         host = db_config$host,
#                                         port = db_config$port,
#                                         user = db_config$user,
#                                         password = db_config$password,
#                                         data = NULL)
#
#       # Reactive value to store the sampled data
#       sampled_data <- shiny::reactiveVal(NULL)
#
#       # When the Sample Data button is clicked, randomly sample the cars dataset
#       shiny::observeEvent(input$sample_button, {
#         sample_size <- min(input$sample_size, nrow(cars))
#         sampled <- cars[sample(nrow(cars), sample_size, replace = TRUE), , drop = FALSE]
#         sampled_data(sampled)
#         postgres_module$data_to_submit(sampled)
#       })
#
#       # Display the sampled data
#       output$sampled_data_title <- shiny::renderUI({
#         shiny::req(sampled_data())
#         shiny::h4("Sampled Data:")
#       })
#
#       output$sampled_data <- shiny::renderTable({
#         sampled_data()
#       })
#     }
#
#     shiny::shinyApp(ui, server)
#   }
#
#   sap <- carsRandomSamplingApp()
#
#   expect_s3_class(sap, "shiny.appobj")
#
# })
