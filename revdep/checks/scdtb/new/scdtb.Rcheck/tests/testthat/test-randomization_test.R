test_that("randomization_test works with num_permutations", {
  res <- randomization_test(sleeping_pills, .out = "sever_compl", .cond = "treatment",
                            .time = "day", num_permutations = 1000, cond_levels = c("C", "E"))
  expect_equal(length(res), 6)
})


test_that("randomization_test works with consec set to observed", {
  res <- randomization_test(sleeping_pills, .out = "sever_compl", .cond = "treatment",
                            .time = "day", consec = "observed", cond_levels = c("C", "E"))
  expect_equal(length(res), 6)
})

test_that("randomization_test works with consec set to fixed", {
  res <- randomization_test(sleeping_pills, .out = "sever_compl", .cond = "treatment",
                            .time = "day", consec = "fixed", cond_levels = c("C", "E"),
                            max_consec = 3, min_consec = 1)
  expect_equal(length(res), 6)
})

test_that("randomization_test works with baseic_scd and num_permutations", {
  res <- randomization_test(basic_scd, .out = "socbehavs", .cond = "phase",
                            .time = "time", num_permutations = 1000, cond_levels = c("baseline", "treatment"))

  expect_equal(length(res), 6)
})

test_that("randomization_test works with reversal_withdrawal and num_permutations
          when phases used for .cond are reduced to two categories", {

  # Modify the phase column in base R
  reversal_withdrawal$phase <- ifelse(reversal_withdrawal$phase == "baseline1" | reversal_withdrawal$phase == "baseline2",
                                      "baseline",
                                      "treatment")

  # Call randomization_test function with the modified data frame
  res <- randomization_test(reversal_withdrawal,
                            .out = "extbehavs",
                            .cond = "phase",
                            .time = "time",
                            num_permutations = 1000,
                            cond_levels = c("baseline", "treatment"))

  expect_equal(length(res), 6)
})

test_that("randomization_test throws error when phases used for .cond has more
          than two categories", {

            expect_error(randomization_test(reversal_withdrawal,
                                            .out = "extbehavs",
                                            .cond = "phase",
                                            .time = "time",
                                            num_permutations = 1000),
                         "function designed to test two factor levels")

          })


test_that("randomization_test throws error when cond_levels contains values not found in .cond", {
  expect_error(randomization_test(sleeping_pills, .out = "sever_compl", .cond = "treatment",
                                  .time = "day", num_permutations = 1000, cond_levels = c("hello", "world")),
               "cond_levels contains values that are not found in: treatment")
})

test_that("randomization_test fails when .bins is not a whole number", {
  expect_error(randomization_test(sleeping_pills, .out = "sever_compl", .cond = "treatment",
                                  .time = "day", num_permutations = 1000, cond_levels = c("C", "E"),
                                  .bins = 35.4), ".bins must be a whole number")
})

test_that("randomization_test fails when conf.level is less than zero or greater than one", {
  expect_error(randomization_test(sleeping_pills, .out = "sever_compl", .cond = "treatment",
                                  .time = "day", num_permutations = 1000, cond_levels = c("C", "E"),
                                  conf.level = 1.4), "conf.level must be between 0 and 1")
})

test_that("randomization_test fails when .df is not a data frame", {
  expect_error(randomization_test(as.character(sleeping_pills), .out = "sever_compl", .cond = "treatment",
                                  .time = "day", num_permutations = 1000, cond_levels = c("C", "E")),
               ".df must be a data frame")
})

test_that("randomization_test fails when .out is not a variable in .df", {
  expect_error(randomization_test(sleeping_pills, .out = "hello_world", .cond = "treatment",
                                  .time = "day", num_permutations = 1000, cond_levels = c("C", "E")),
               ".out must be a variable in .df")
})
