test_that("raw_plot works on sleeping_pills example", {

  rp <- raw_plot(.df = sleeping_pills, .out = "sever_compl", .time = "day",
                 .cond = "treatment", cond_levels = c("C", "E"),
                 cond_labels = c("Control", "Experimental"))
  expect_s3_class(rp, "gg")
  expect_s3_class(rp, "ggplot")
})

test_that("raw_plot works on the efficacy_of_CBT example", {
  rp <- raw_plot(.df = efficacy_of_CBT, .out = "Anxious", .time = "time",
                 .phase = "phase", phase_levels = c(0, 1),
                 phase_labels = c("Exposure", "Exposure + CT"))

  expect_s3_class(rp, "gg")
  expect_s3_class(rp, "ggplot")
})


test_that("raw_plot works on the efficacy_of_CBT example with multiple participants", {
  temp_CBT1 <- efficacy_of_CBT
  temp_CBT1$part <- "x"
  temp_CBT1$CATS_N <- temp_CBT1$CATS_N + stats::rpois(nrow(temp_CBT1), 2)

  temp_CBT2 <- efficacy_of_CBT
  temp_CBT2$part <- "y"
  temp_CBT2$CATS_N <- temp_CBT2$CATS_N + stats::rpois(nrow(temp_CBT1), 10)

  bound_CBT <- rbind(temp_CBT1, temp_CBT2)

  rp <- raw_plot(.df = bound_CBT, .out = "CATS_N", .time = "time",
                 .phase = "phase", phase_levels = c(0, 1),
                 phase_labels = c("Exposure", "Exposure + CT"),
                 .participant = "part")

  expect_s3_class(rp, "gg")
  expect_s3_class(rp, "ggplot")

})

test_that("raw_plot works on the efficacy_of_CBT example with multiple participants
          and different phase breaks", {
  temp_CBT1 <- efficacy_of_CBT
  temp_CBT1$part <- "x"
  temp_CBT1$CATS_N <- temp_CBT1$CATS_N + stats::rpois(nrow(temp_CBT1), 2)
  temp_CBT1$phase <- c(0,0,0,1,1,1,1,1,1,1)

  temp_CBT2 <- efficacy_of_CBT
  temp_CBT2$part <- "y"
  temp_CBT2$CATS_N <- temp_CBT2$CATS_N + stats::rpois(nrow(temp_CBT1), 10)

  bound_CBT <- rbind(temp_CBT1, temp_CBT2)

  rp <- raw_plot(.df = bound_CBT, .out = "CATS_N", .time = "time",
                 .phase = "phase", phase_levels = c(0, 1),
                 phase_labels = c("Exposure", "Exposure + CT"),
                 .participant = "part")

  expect_s3_class(rp, "gg")
  expect_s3_class(rp, "ggplot")

})


test_that("raw_plot works on the efficacy_of_CBT example with 4 phases", {
  temp_CBT1 <- efficacy_of_CBT
  temp_CBT1$part <- "x"
  temp_CBT1$phase <- c(rep(0, 5), rep(1,5))
  temp_CBT1$time <- 1:10
  temp_CBT1$CATS_N <- temp_CBT1$CATS_N + stats::rpois(nrow(temp_CBT1), 2)

  temp_CBT2 <- efficacy_of_CBT
  temp_CBT2$part <- "x"
  temp_CBT2$phase <- c(rep(2, 5), rep(3,5))
  temp_CBT2$time <- 11:20
  temp_CBT2$CATS_N <- temp_CBT2$CATS_N + stats::rpois(nrow(temp_CBT2), 10)

  bound_CBT <- rbind(temp_CBT1, temp_CBT2)

  rp <- raw_plot(.df = bound_CBT, .out = "CATS_N", .time = "time",
                 .phase = "phase", phase_levels = c(0, 1, 2, 3),
                 phase_labels = c("Exposure", "Exposure + CT", "Exposure", "Exposure + CT"),
                 .participant = "part")

  expect_s3_class(rp, "gg")
  expect_s3_class(rp, "ggplot")

})

test_that("raw_plot works on the efficacy_of_CBT example with 4 phases and no participant", {
  temp_CBT1 <- efficacy_of_CBT
  temp_CBT1$part <- "x"
  temp_CBT1$phase <- c(rep(0, 5), rep(1,5))
  temp_CBT1$time <- 1:10
  temp_CBT1$CATS_N <- temp_CBT1$CATS_N + stats::rpois(nrow(temp_CBT1), 2)

  temp_CBT2 <- efficacy_of_CBT
  temp_CBT2$part <- "x"
  temp_CBT2$phase <- c(rep(2, 5), rep(3,5))
  temp_CBT2$time <- 11:20
  temp_CBT2$CATS_N <- temp_CBT2$CATS_N + stats::rpois(nrow(temp_CBT2), 10)

  bound_CBT <- rbind(temp_CBT1, temp_CBT2)

  rp <- raw_plot(.df = bound_CBT, .out = "CATS_N", .time = "time",
                 .phase = "phase", phase_levels = c(0, 1, 2, 3),
                 phase_labels = c("Exposure", "Exposure + CT", "Exposure", "Exposure + CT"))

  expect_s3_class(rp, "gg")
  expect_s3_class(rp, "ggplot")

})
