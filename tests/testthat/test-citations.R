test_that("format_citations works", {
  stats_cit <- format_citation(citation("stats"))
  expect_true(grepl("R Core Team", stats_cit))
})
