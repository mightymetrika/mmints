test_that("csvUpload module works", {

  # Build shiny app
  csvUpload_app <- function(){
    ui <- shiny::fluidPage(
      shiny::titlePanel("CSV Upload Module"),
      shiny::sidebarLayout(
        shiny::sidebarPanel(
          csvUploadUI("data_upload")$input
        ),
        shiny::mainPanel(
          csvUploadUI("data_upload")$output
        )
      )
    )

    server <- function(input, output, session) {
      data <- csvUploadServer("data_upload")
    }

    shiny::shinyApp(ui, server)
  }

  sap <- csvUpload_app()

  expect_s3_class(sap, "shiny.appobj")
})
