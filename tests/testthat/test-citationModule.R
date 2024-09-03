test_that("citationModule works", {

  simple_citations_app <- function() {

    # set up ui
    ui <- shiny::fluidPage(
      shiny::sidebarLayout(
        shiny::sidebarPanel(
          citationUI("citations")$button
        ),
        shiny::mainPanel(
          citationUI("citations")$output
        )
      )
    )

    server <- function(input, output, session) {

      # build citation list
      citations <- list(
        "Software for Building Web Applications:" = function() format_citation(utils::citation("shiny")),
        "Software Implementing Mixed-Effects Model p-values:" = "Kuznetsova A, Brockhoff PB, Christensen RHB (2017). 'lmerTest Package: Tests in Linear Mixed Effects Models.' Journal of Statistical Software, 82(13), 1-26. <doi:10.18637/jss.v082.i13>.",
        "mmints Package:" = function() format_citation(utils::citation("mmints"))
      )

      # create citation for display
      citationServer("citations", citations)
    }

    shiny::shinyApp(ui, server)
  }

  # build 'shiny.appobj'
  sap <- simple_citations_app()

  expect_s3_class(sap, "shiny.appobj")

})
