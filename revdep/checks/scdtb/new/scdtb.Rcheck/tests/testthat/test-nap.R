test_that("nap gives same result as WWC 5.0 Appendix I reversability example", {

  res <- nap(.df = reversal_withdrawal, .y = "extbehavs", .phase = "phase", .time = "time",
             type = "reversability", phases = list("baseline1", "baseline2"),
             improvement = "negative")
  expect_equal(round(res, 3), 0.617)
})

test_that("nap gives same result as WWC 5.0 Appendix I trend example", {
  res <- nap(.df = reversal_withdrawal, .y = "extbehavs", .phase = "phase", .time = "time",
             type = "trend", last_m = 3, phases = list("baseline1"),
             improvement = "negative")
  expect_equal(round(res,2), 0.44)
})

test_that("nap fails if .df is not a data frame", {

  expect_error(nap(.df = as.character(reversal_withdrawal), .y = "extbehavs",
                   .phase = "phase", .time = "time",
                   type = "reversability", phases = list("baseline1", "baseline2"),
                   improvement = "negative"),
               ".df must be a data frame")
})

test_that("nap fails if .time is not found in .df", {

  expect_error(nap(.df = reversal_withdrawal, .y = "extbehavs",
                   .phase = "phase", .time = "hello_world",
                   type = "reversability", phases = list("baseline1", "baseline2"),
                   improvement = "negative"),
               ".time must be a variable in .df")
})

test_that("nap fails if phases contain values not found in .phase", {

  expect_error(nap(.df = reversal_withdrawal, .y = "extbehavs",
                   .phase = "phase", .time = "time",
                   type = "reversability", phases = list("hello", "world"),
                   improvement = "negative"),
               "phases contains values that are not found in: phase")
})

test_that("nap fails if is.null(last_m) and length(phases) != 2", {

  expect_error(nap(.df = reversal_withdrawal, .y = "extbehavs",
                   .phase = "phase", .time = "time",
                   type = "reversability", phases = list("baseline1", "baseline2", "treatment1"),
                   improvement = "negative"),
               "length of phases must equal two if last_m is NULL")
})

test_that("nap fails if !is.null(last_m) and length(phases) != 1", {

  expect_error(nap(.df = reversal_withdrawal, .y = "extbehavs", .phase = "phase", .time = "time",
                   type = "trend", last_m = 3, phases = list("baseline1", "baseline2"),
                   improvement = "negative"),
               "length of phases must equal one if last_m is not NULL")
})

test_that("nap fails if !is.null(last_m) and last_m is not a whole number", {

  expect_error(nap(.df = reversal_withdrawal, .y = "extbehavs", .phase = "phase", .time = "time",
                   type = "trend", last_m = 3.5, phases = list("baseline1"),
                   improvement = "negative"),
               "last_m must be a whole number")
})

test_that("nap fails if .y is not an object of type character", {

  expect_error(nap(.df = reversal_withdrawal, .y = 10,
                   .phase = "phase", .time = "time",
                   type = "reversability", phases = list("baseline1", "baseline2"),
                   improvement = "negative"),
               ".y must be an object of type character")
})
