# test_that("authModule works", {
#
#   authApp <- function() {
#     ui <- shiny::fluidPage(
#       shiny::tags$head(
#         shiny::tags$style(
#           ".auth-container { max-width: 400px; margin: 50px auto; padding: 20px; }
#          .auth-container .btn { margin: 10px 0; }
#          .pull-right { float: right; }"
#         )
#       ),
#       shiny::titlePanel("Authentication Demo"),
#
#       # Authentication UI
#       authUI("auth_module"),
#
#       # Content shown only for authenticated users
#       shiny::uiOutput("authenticated_content")
#     )
#
#     server <- function(input, output, session) {
#       # Initialize Postgres module (with new 'executeQuery' method)
#       postgres <- postgresServer(
#         "postgres_module",
#         dbname   = Sys.getenv("DBNAME"),
#         datatable= Sys.getenv("DATATABLE"),
#         host     = Sys.getenv("HOST"),
#         port     = as.integer(Sys.getenv("PORT")),
#         user     = Sys.getenv("USER"),
#         password = Sys.getenv("PASSWORD"),
#         data     = reactive(NULL)
#       )
#
#       # Initialize our auth module
#       auth <- authServer("auth_module", postgres, "users")
#
#       # Show some content for authenticated users
#       output$authenticated_content <- shiny::renderUI({
#         shiny::req(auth()$user_auth)  # must be logged in
#         shiny::div(
#           class = "container",
#           shiny::h3("Welcome, ", auth()$info$user, "!"),
#           shiny::p("Your role is: ", auth()$info$permissions),
#
#           shiny::wellPanel(
#             shiny::h4("Example Protected Content"),
#             if (auth()$info$permissions == "admin") {
#               shiny::tagList(
#                 shiny::p("This is admin-only content."),
#                 shiny::actionButton("admin_action", "Admin Action")
#               )
#             } else {
#               shiny::p("This is standard user content.")
#             }
#           )
#         )
#       })
#
#       shiny::observeEvent(input$admin_action, {
#         shiny::req(auth()$user_auth, auth()$info$permissions == "admin")
#         shiny::showNotification("Admin action triggered!", type = "message")
#       })
#     }
#
#     shiny::shinyApp(ui, server)
#   }
#
#   runAuthApp <- function(
#     dbname   = Sys.getenv("DBNAME"),
#     host     = Sys.getenv("HOST"),
#     port     = as.integer(Sys.getenv("PORT")),
#     user     = Sys.getenv("USER"),
#     password = Sys.getenv("PASSWORD")
#   ) {
#     authApp()
#   }
#
#   expect_s3_class(runAuthApp(), "shiny.appobj")
#
# })

# testthat::test_that("authModule & postgresModule work together",{
#
#   twoTabApp <- function() {
#     ui <- shiny::fluidPage(
#       shiny::titlePanel("Two-Tab App: Auth + Random Cars Sampling"),
#       # A tabsetPanel with an ID
#       shiny::tabsetPanel(
#         id = "main_tabs",
#         # Only the Login tab is initially present
#         shiny::tabPanel("Login / Signup", value = "auth_tab",
#                         authUI("auth_module"))
#       )
#     )
#
#     server <- function(input, output, session) {
#       # 1) Auth Postgres module + authServer
#       db_config_auth <- list(
#         dbname    = Sys.getenv("DBNAME"),
#         datatable = Sys.getenv("DATATABLEAUTH"),
#         host      = Sys.getenv("HOST"),
#         port      = as.integer(Sys.getenv("PORT")),
#         user      = Sys.getenv("USER"),
#         password  = Sys.getenv("PASSWORD")
#       )
#       postgres_module_auth <- postgresServer(
#         "postgres_auth",
#         dbname    = db_config_auth$dbname,
#         datatable = db_config_auth$datatable,
#         host      = db_config_auth$host,
#         port      = db_config_auth$port,
#         user      = db_config_auth$user,
#         password  = db_config_auth$password,
#         data      = shiny::reactive(NULL)
#       )
#       auth <- authServer("auth_module", postgres_module_auth, user_table = "users")
#
#       # 2) Cars Postgres module
#       db_config_cars <- list(
#         dbname    = Sys.getenv("DBNAME"),
#         datatable = Sys.getenv("DATATABLE"),
#         host      = Sys.getenv("HOST"),
#         port      = as.integer(Sys.getenv("PORT")),
#         user      = Sys.getenv("USER"),
#         password  = Sys.getenv("PASSWORD")
#       )
#       postgres_module_cars <- postgresServer(
#         "postgres_cars",
#         dbname    = db_config_cars$dbname,
#         datatable = db_config_cars$datatable,
#         host      = db_config_cars$host,
#         port      = db_config_cars$port,
#         user      = db_config_cars$user,
#         password  = db_config_cars$password,
#         data      = shiny::reactive(NULL)
#       )
#
#       # 3) Define the entire second tab
#       cars_tab <- shiny::tabPanel(
#         title = "Cars Random Sampling",
#         value = "cars_tab",
#         shiny::sidebarLayout(
#           shiny::sidebarPanel(
#             shiny::uiOutput("auth_status_message"),
#             shiny::numericInput("sample_size", "Number of rows to sample:",
#                                 value = 5, min = 1, max = nrow(cars)),
#             shiny::actionButton("sample_button", "Sample Data"),
#             postgresUI("postgres_cars")$submit,
#             postgresUI("postgres_cars")$download
#           ),
#           shiny::mainPanel(
#             shiny::uiOutput("sampled_data_title"),
#             shiny::tableOutput("sampled_data"),
#             shiny::h4("Database Content:"),
#             postgresUI("postgres_cars")$table
#           )
#         )
#       )
#
#       # 4) Show or remove that second tab based on auth
#       shiny::observeEvent(auth()$user_auth, {
#         if (isTRUE(auth()$user_auth)) {
#           shiny::removeTab(inputId = "main_tabs", target = "cars_tab")
#           shiny::appendTab(inputId = "main_tabs", cars_tab, select = FALSE)
#         } else {
#           shiny::removeTab(inputId = "main_tabs", target = "cars_tab")
#         }
#       })
#
#       # 5) Logic for sampling, now with username appended
#       sampled_data <- shiny::reactiveVal(NULL)
#       shiny::observeEvent(input$sample_button, {
#         shiny::req(auth()$user_auth)
#
#         # Sample from cars
#         sz <- min(input$sample_size, nrow(cars))
#         new_sample <- cars[sample(nrow(cars), size = sz, replace = TRUE), ]
#
#         # Add the user name as an extra column
#         new_sample$username <- auth()$info$user
#
#         sampled_data(new_sample)
#
#         # Pass data to the "cars" module
#         postgres_module_cars$data_to_submit(new_sample)
#       })
#
#       output$sampled_data_title <- shiny::renderUI({
#         shiny::req(sampled_data())
#         shiny::h4("Sampled Data:")
#       })
#       output$sampled_data <- shiny::renderTable(sampled_data())
#
#       output$auth_status_message <- shiny::renderUI({
#         if (!isTRUE(auth()$user_auth)) {
#           shiny::p("You are not logged in. Please sign up, log in, or continue as guest.")
#         } else {
#           shiny::p(
#             shiny::strong("Authenticated as:"),
#             auth()$info$user,
#             "(role:", auth()$info$permissions, ")"
#           )
#         }
#       })
#     }
#
#     shiny::shinyApp(ui, server)
#   }
#
#   expect_s3_class(twoTabApp(), "shiny.appobj")
#
# })
