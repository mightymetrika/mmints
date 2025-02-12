test_that("cross_lagged works", {

  # Add second outcome variable to reversal_withdrawal data
  rw <- reversal_withdrawal
  rw$synth <- sapply(rw$time, function(x){
    stats::rpois(1, x)
  })

  rw <- as.data.frame(rw)


  # Get cross_lagged correlations
  cl <- cross_lagged(.df = rw, .x = "extbehavs", .y = "synth")


  expect_equal(length(cl), 8)
  expect_s3_class(cl, "cross_lagged")
})

test_that("crossed_lagged works like example in Maric & Werf",{
  data <- data.frame(phase         = c(rep(0,5), rep(1,5)),
                     time_in_phase = rep(4:0, 2),
                     Anxious       = c(17, 14, 13, 13, 7, 10, 8,11, 10, 12),
                     CATS_N        = c(2,4,2,4,2, 8,5,8,7,6),
                     time          = 1:10,
                     participant   = factor(rep("x",10)))

  cl <- cross_lagged(.df = data, .x = "CATS_N", .y = "Anxious")

  expect_equal(length(cl), 8)
  expect_s3_class(cl, "cross_lagged")
})
