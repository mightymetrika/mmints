test_that("mixed_model_analysis reproduces the results in Table 7.1 works of
          Maric, M., & van der Werff, V. (2020) using the Anxious outcome", {

  res <- mixed_model_analysis(efficacy_of_CBT, .dv = "Anxious", .time = "time",
                              .phase = "phase",rev_time_in_phase = TRUE,
                              phase_levels = c(0, 1),
                              phase_labels = c("Exposure", "Exposure + CT"))

  expect_equal(length(res), 3)

})

test_that("mixed_model_analysis reproduces the results in Table 7.1 works of
          Maric, M., & van der Werff, V. (2020) using the Negative Cognitions
          outcome", {

            res <- mixed_model_analysis(efficacy_of_CBT, .dv = "CATS_N", .time = "time",
                                        .phase = "phase",rev_time_in_phase = TRUE,
                                        phase_levels = c(0, 1),
                                        phase_labels = c("Exposure", "Exposure + CT"))

            expect_equal(length(res), 3)

          })

test_that("mixed_model_analysis fails when .df is not a data frame", {

  expect_error(mixed_model_analysis(as.character(efficacy_of_CBT), .dv = "CATS_N",
                                    .time = "time", .phase = "phase",
                                    rev_time_in_phase = TRUE, phase_levels = c(0, 1),
                                    phase_labels = c("Exposure", "Exposure + CT")),
               ".df must be a data frame")

})

test_that("mixed_model_analysis fails when .dv is not found if .df", {

  expect_error(mixed_model_analysis(efficacy_of_CBT, .dv = "hello_world",
                                    .time = "time", .phase = "phase",
                                    rev_time_in_phase = TRUE, phase_levels = c(0, 1),
                                    phase_labels = c("Exposure", "Exposure + CT")),
               ".dv must be a variable in .df")

})

test_that("mixed_model_analysis fails when rev_time_in_phase is not bolean", {

  expect_error(mixed_model_analysis(efficacy_of_CBT, .dv = "CATS_N",
                                    .time = "time", .phase = "phase",
                                    rev_time_in_phase = 25, phase_levels = c(0, 1),
                                    phase_labels = c("Exposure", "Exposure + CT")),
               "rev_time_in_phase must be boolean")

})

test_that("mixed_model_analysis fails when phase_levels are not found in .phase", {

  expect_error(mixed_model_analysis(efficacy_of_CBT, .dv = "CATS_N",
                                    .time = "time", .phase = "phase",
                                    rev_time_in_phase = TRUE, phase_levels = c("hello", "world"),
                                    phase_labels = c("Exposure", "Exposure + CT")),
               "phase_levels contains values that are not found in: phase")

})

test_that("mixed_model_analysis fails when phase_levels and phase_labels are not
          of the same length", {

  expect_error(mixed_model_analysis(efficacy_of_CBT, .dv = "CATS_N",
                                    .time = "time", .phase = "phase",
                                    rev_time_in_phase = TRUE, phase_levels = c(0, 1),
                                    phase_labels = c("Exposure", "Exposure + CT", "hello")),
               "phase_levels and phase_labels must have the same length")

})

test_that("mixed_model_analysis works with covs", {

            res <- mixed_model_analysis(efficacy_of_CBT, .dv = "CATS_N",
                                              .time = "time", .phase = "phase",
                                              rev_time_in_phase = TRUE, phase_levels = c(0, 1),
                                              phase_labels = c("Exposure", "Exposure + CT"),
                                              covs = c("Anxious"))

            expect_equal(length(res), 3)

          })

test_that("mixed_model_analysis fails when covs not found in .df", {

  expect_error(mixed_model_analysis(efficacy_of_CBT, .dv = "CATS_N",
                                    .time = "time", .phase = "phase",
                                    rev_time_in_phase = TRUE, phase_levels = c(0, 1),
                                    phase_labels = c("Exposure", "Exposure + CT"),
                                    covs = c("hello_world")),
               "covs contains variables that are not found in .df")

})


# test_that("mixed_model_analysis uses the .participant variable to label data points
#           when .participant is not NULL", {
#
#   temp_CBT1 <- efficacy_of_CBT
#   temp_CBT1$part <- "x"
#   temp_CBT1$CATS_N <- temp_CBT1$CATS_N + stats::rpois(nrow(temp_CBT1), 2)
#
#   temp_CBT2 <- efficacy_of_CBT
#   temp_CBT2$part <- "y"
#   temp_CBT2$CATS_N <- temp_CBT2$CATS_N + stats::rpois(nrow(temp_CBT1), 10)
#
#   bound_CBT <- rbind(temp_CBT1, temp_CBT2)
#
#   res <- mixed_model_analysis(bound_CBT, .dv = "CATS_N", .time = "time",
#                               .phase = "phase", .participant = "part",
#                               rev_time_in_phase = TRUE, phase_levels = c(0, 1),
#                               phase_labels = c("Exposure", "Exposure + CT"))
#
#   expect_equal(res$plot$labels$shape, "factor(part)")
#
# })
