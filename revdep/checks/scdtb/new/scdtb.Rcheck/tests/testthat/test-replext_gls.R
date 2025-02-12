test_that("replext_gls works with univariate covariates", {

  # Covariate specifications
  covariate_specs <- list(
    list(vars = "cov1", dist = rnorm, args = list(mean = 0, sd = 1)),
    list(vars = "cov2", dist = runif, args = list(min = 0, max = 1))
  )

  # Model formula
  formula <- y ~ phase * time_in_phase + cov1 + cov2

  # Regression coefficients
  betas <- c("(Intercept)" = 0,
             "phase1" = 0,
             "time_in_phase" = 0,
             "phase1:time_in_phase" = 0,
             "cov1" = 0,
             "cov2" = 0)

  # Time points per phase and autocorrelation coefficients
  n_timepoints_list <- c(5, 10)
  rho_list <- c(0.1, 0.3)

  # Number of iterations
  iterations <- 10

  results <- replext_gls(n_timepoints_list = n_timepoints_list,
                         rho_list = rho_list,
                         iterations = iterations,
                         n_phases = 2,
                         n_IDs = 1,
                         betas = betas,
                         formula = formula,
                         covariate_specs = covariate_specs)

  expect_equal(ncol(results), 18)
  expect_s3_class(results, "replext_gls")
})


test_that("replext_gls works with two IDs along with correlated and univariate covariates", {

  # Covariate specifications
  covariate_specs <- list(
    list(
      vars = c("x1", "x2"),
      dist = "mvnorm",
      args = list(
        mu = c(0, 0),
        Sigma = matrix(c(1, 0.5, 0.5, 1), 2, 2)
      )
    ),
    list(
      vars = "x3",
      dist = "rnorm",
      args = list(mean = 0, sd = 1)
    )
  )

  # Model formula
  formula <- y ~ phase * time_in_phase + x1 + x2 + x3

  # Regression coefficients
  betas <- c("(Intercept)" = 0,
             "phase1" = 0,
             "time_in_phase" = 0,
             "phase1:time_in_phase" = 0,
             "x1" = 0,
             "x2" = 0,
             "x3" = 0)

  # Time points per phase and autocorrelation coefficients
  n_timepoints_list <- c(5, 10)
  rho_list <- c(0.1, 0.3)

  # Number of iterations
  iterations <- 10

  results <- replext_gls(n_timepoints_list = n_timepoints_list,
                         rho_list = rho_list,
                         iterations = iterations,
                         n_phases = 2,
                         n_IDs = 2,
                         betas = betas,
                         formula = formula,
                         covariate_specs = covariate_specs)

  expect_equal(ncol(results), 18)
  expect_s3_class(results, "replext_gls")
})

test_that("replext_gls works with two IDs along with correlated skew-normal
          and univariate covariates", {

            # Covariate specifications
            covariate_specs <- list(
              list(
                vars = c("x1", "x2"),
                dist = "rmsn",
                args = list(
                  xi = c(0.3, -0.6),
                  # Omega = stats::rWishart(1, 2, diag(2))[,,1],
                  Omega = matrix(c(1, 0.5, 0.5, 1), 2, 2),
                  alpha = c(1, -2)
                )
              ),
              list(
                vars = "x3",
                dist = "rnorm",
                args = list(mean = 0, sd = 1)
              )
            )

            # Model formula
            formula <- y ~ phase * time_in_phase + x1 + x2 + x3

            # Regression coefficients
            betas <- c("(Intercept)" = 0,
                       "phase1" = 0,
                       "time_in_phase" = 0,
                       "phase1:time_in_phase" = 0,
                       "x1" = 0,
                       "x2" = 0,
                       "x3" = 0)

            # Time points per phase and autocorrelation coefficients
            n_timepoints_list <- c(5, 10)
            rho_list <- c(0.1, 0.3)

            # Number of iterations
            iterations <- 10

            results <- replext_gls(n_timepoints_list = n_timepoints_list,
                                   rho_list = rho_list,
                                   iterations = iterations,
                                   n_phases = 2,
                                   n_IDs = 2,
                                   betas = betas,
                                   formula = formula,
                                   covariate_specs = covariate_specs)

            expect_equal(ncol(results), 18)
            expect_s3_class(results, "replext_gls")
          })

test_that("replext_gls works with a covariate correlated with time within phase",{

  # Define covariate_specs with correlation to time_in_phase
  covariate_specs <- list(
    list(
      vars = "X",
      expr = function(n, df) {
        X <- df$time_in_phase + rnorm(n)
        return(data.frame(X = X))
      }
    )
  )

  # Regression coefficients
  betas <- c("(Intercept)" = 0,
             "phase1" = 0,
             "time_in_phase" = 0,
             "phase1:time_in_phase" = 0,
             "X" = 0)

  # Run simulation
  results <- replext_gls(
    n_timepoints_list = c(10, 20),
    rho_list = c(0.3, 0.6),
    iterations = 10,
    betas = betas,
    formula = y ~ phase * time_in_phase + X,
    covariate_specs = covariate_specs
  )

  expect_equal(ncol(results), 18)
  expect_s3_class(results, "replext_gls")
})
