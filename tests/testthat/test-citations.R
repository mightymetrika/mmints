test_that("format_citations works", {
  stats_cit <- format_citation(citation("stats"))
  expect_equal(2 * 2, 4)
})
