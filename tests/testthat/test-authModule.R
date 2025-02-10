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
