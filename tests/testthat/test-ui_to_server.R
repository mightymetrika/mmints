test_that("text_to_vector works", {

  # Comma separated list of quoted numbers to numeric vector
  char_to_num_vec <- text_to_vector("1,2,3,4,5")
  expect_equal(length(char_to_num_vec), 5)
  expect_false(is.character(char_to_num_vec))

  # Quoted semi-colon range of numbers to numeric vector
  colon_to_num_vec <- text_to_vector("1:5")
  expect_equal(length(colon_to_num_vec), 5)
  expect_false(is.character(colon_to_num_vec))

  # Quoted rep to numeric vector
  rep_to_num_vec <- text_to_vector("rep(1:5, times = 2)")
  expect_equal(length(rep_to_num_vec), 10)
  expect_false(is.character(rep_to_num_vec))
})

test_that("vec_null works", {

  # Convert missing value to NULL
  expect_null(vec_null())
  expect_null(vec_null(NA))
  expect_null(vec_null("na", alt_na="na"))

  # Conver to vector when input is not missing
  num_vec <- vec_null("2,8,3,7")
  expect_true(is.vector(num_vec))
  expect_equal(length(num_vec), 4)

  # Convert to NULL when single value in vector is missing
  expect_null(vec_null("2,3,NA,5", "NA"))

})

test_that("text_to_list works", {

  # Create a named list from a string
  named_list <- text_to_list("'one' = 1, 'two' = 2, 'three' = 3")
  expect_true(is.list(named_list))
  expect_equal(sum(names(named_list) == c("one", "two", "three")), 3)

  # Create a list of vectors from a string
  vec_list <- text_to_list("c('x1', 'x2'), c('x3', 'x4')")
  expect_true(is.list(vec_list))
  expect_equal(sum(vec_list[[1]]== c("x1", "x2")), 2)
  expect_equal(sum(vec_list[[2]]== c("x3", "x4")), 2)
})

test_that("list_null works", {
  # Convert missing value to null
  expect_null(list_null())
  expect_null(list_null(NA))
  expect_null(list_null("na", alt_na="na"))

  # Convert non-missing value to list
  named_list <- list_null("'one' = 1, 'two' = 2, 'three' = 3")
  expect_true(is.list(named_list))
  expect_equal(sum(names(named_list) == c("one", "two", "three")), 3)

  # Convert to null when a single vector is missing
  expect_null(list_null("'one' = 1, 'two' = NA, 'three' = 3", alt_na = "NA"))
  expect_null(list_null("'one' = 1, NA, 'three' = 3", alt_na = "NA"))
})
