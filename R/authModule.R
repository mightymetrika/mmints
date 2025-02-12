#' Create UI elements for Authentication Shiny Module
#'
#' This function generates the UI components for the Authentication module,
#' including login, signup, and guest access options.
#'
#' @param id A character string that uniquely identifies this module instance
#'
#' @return A list containing UI elements for authentication
#'
#' @export
#'
#' @examples
#' shiny::fluidPage(
#'   authUI("auth_module")
#' )
authUI <- function(id) {
  ns <- shiny::NS(id)

  shiny::tagList(
    # Container for auth elements
    shiny::div(
      class = "auth-container",
      # Login UI from shinyauthr
      shinyauthr::loginUI(ns("login")),

      # Logout UI from shinyauthr
      shiny::div(
        class = "pull-right",
        shinyauthr::logoutUI(ns("logout"))
      ),

      # Guest login button
      shiny::actionButton(
        ns("guest_login"),
        "Continue as Guest",
        class = "btn-primary"
      ),

      # Signup UI (shown when signup_toggle is clicked)

      # Toggle between login and signup
      shiny::actionLink(ns("signup_toggle"), "Need an account? Sign up"),

      # conditionalPanel relies on a JavaScript expression, which we tie to an output value
      shiny::conditionalPanel(
        condition = sprintf("output['%s'] == true", ns("show_signup")),
        shiny::textInput(ns("signup_username"), "Username"),
        shiny::passwordInput(ns("signup_password"), "Password"),
        shiny::textInput(ns("signup_email"), "Email"),
        shiny::textInput(ns("dispay_name"), "Display Name"),
        shiny::actionButton(ns("signup_submit"), "Sign Up")
      )
    )
  )
}

#' Server function for Authentication Shiny Module
#'
#' This function sets up the server-side logic for the Authentication module,
#' handling user authentication, signup, and guest access.
#'
#' @param id A character string that matches the ID used in `authUI()`
#' @param postgres_module A postgresModule instance to handle database operations
#' @param user_table A character string specifying the name of the users table
#'
#' @return A list containing authentication status and user information
#'
#' @export
#'
#' @examples
#' server <- function(input, output, session) {
#'   postgres <- postgresServer("postgres_module", ...)
#'   auth <- authServer("auth_module", postgres, "users")
#' }
authServer <- function(id, postgres_module, user_table = "users") {
  shiny::moduleServer(id, function(input, output, session) {

    # Create the users table if it doesn't exist:
    shiny::observe({
      tryCatch({
        create_users_sql <- sprintf("
          CREATE TABLE IF NOT EXISTS %s (
            username TEXT PRIMARY KEY,
            password TEXT NOT NULL,
            email    TEXT,
            display  TEXT,
            role     TEXT DEFAULT 'standard',
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
          )", user_table)

        # Use the new executeQuery() instead of saveData()!
        postgres_module$executeQuery(create_users_sql)

        # Also ensure there's a 'guest' account
        guest_sql <- sprintf("
          INSERT INTO %s (username, password, role)
          VALUES ('guest', '%s', 'guest')
          ON CONFLICT (username) DO NOTHING",
                             user_table,
                             sodium::password_store("guest")
        )
        postgres_module$executeQuery(guest_sql)

      }, error = function(e) {
        shiny::showNotification(
          paste("Error creating users table:", e$message),
          type = "error"
        )
      })
    })

    # Load user data reactively
    # user_base <- shiny::reactive({
    ## Note: Remove reactivity until 'shinyauthr' is updated on CRAN to include
    ## the following PR: https://github.com/PaulC91/shinyauthr/pull/62
    # Use the module's loadData()
    users <- postgres_module$loadData()

    # Convert to a tibble with the columns shinyauthr expects
    user_base <- data.frame(
      user        = users$username,
      password    = users$password,
      permissions = users$role,
      email       = users$email,
      display     = users$display
    )
    # })


    # Initialize shinyauthr
    logout_init <- shinyauthr::logoutServer(
      id = "logout",
      active = shiny::reactive(credentials()$user_auth)
    )

    credentials <- shiny::reactiveVal(NULL)

    auth_info <- shinyauthr::loginServer(
      id            = "login",
      data          = user_base,  # calls the reactive immediately
      user_col      = user,
      pwd_col       = password,
      sodium_hashed = TRUE,
      log_out       = shiny::reactive(logout_init())
    )

    # Handle guest login
    shiny::observeEvent(input$guest_login, {
      # Force-assign "guest" credentials
      credentials(list(
        user_auth = TRUE,
        info = list(
          user        = "guest",
          permissions = "guest"
        )
      ))
    })

    # A reactiveVal that starts off FALSE = not showing signup panel
    show_signup <- shiny::reactiveVal(FALSE)

    # Flip the value on click
    shiny::observeEvent(input$signup_toggle, {
      show_signup(!show_signup())  # if FALSE -> TRUE, if TRUE -> FALSE
    })

    # Then define an output that our conditionalPanel can "see"
    output$show_signup <- shiny::reactive({
      show_signup()
    })

    # Must explicitly do this so conditionalPanel can update properly
    shiny::outputOptions(output, "show_signup", suspendWhenHidden = FALSE)


    # Handle signup
    shiny::observeEvent(input$signup_submit, {
      # Basic validation
      if (nchar(input$signup_username) < 3 ||
          nchar(input$signup_password) < 6) {
        shiny::showNotification(
          "Username must be at least 3 characters and password at least 6 characters",
          type = "error"
        )
        return()
      }

      # Hash password
      hashed_pwd <- sodium::password_store(input$signup_password)

      # Insert new user
      new_user <- data.frame(
        username = input$signup_username,
        password = hashed_pwd,
        email    = input$signup_email,
        display  = input$dispay_name,
        role     = "standard"
      )

      tryCatch({
        postgres_module$saveData(new_user)
        shiny::showNotification("User created successfully", type = "message")
      }, error = function(e) {
        shiny::showNotification(
          paste("Error creating user:", e$message),
          type = "error"
        )
      })
    })

    # Merge credentials from guest login or loginServer
    merged_credentials <- shiny::reactive({
      shiny::req(auth_info())
      if (!is.null(credentials())) {
        credentials()
      } else {
        auth_info()
      }
    })

    # Return the merged credentials
    merged_credentials
  })
}
