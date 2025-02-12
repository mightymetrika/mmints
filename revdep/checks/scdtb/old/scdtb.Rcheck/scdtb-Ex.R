pkgname <- "scdtb"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
options(pager = "console")
library('scdtb')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("cross_lagged")
### * cross_lagged

flush(stderr()); flush(stdout())

### Name: cross_lagged
### Title: Cross-Lagged Correlation
### Aliases: cross_lagged

### ** Examples

# Creating a sample dataset
reversal_withdrawal <- data.frame(
  phase = c(rep("baseline1", 6), rep("treatment1", 5), rep("baseline2", 5), rep("treatment2", 5)),
  time = 1:21,
  extbehavs = c(15, 10, 14, 17, 13, 12, 2, 1, 1, 0, 0, 9, 9, 11, 15, 20, 1, 0, 4, 0, 1)
)

reversal_withdrawal$synth <- sapply(reversal_withdrawal$time, function(x) {
  stats::rpois(1, x)
})

reversal_withdrawal <- as.data.frame(reversal_withdrawal)

# Using the cross_lagged function
cl_result <- cross_lagged(reversal_withdrawal, .x = "time", .y = "synth")




cleanEx()
nameEx("mixed_model_analysis")
### * mixed_model_analysis

flush(stderr()); flush(stdout())

### Name: mixed_model_analysis
### Title: Mixed Model Analysis
### Aliases: mixed_model_analysis

### ** Examples

res <- mixed_model_analysis(efficacy_of_CBT, .dv = "Anxious", .time = "time",
                            .phase = "phase",rev_time_in_phase = TRUE,
                            phase_levels = c(0, 1),
                            phase_labels = c("Exposure", "Exposure + CT"))

summary(res$fitted_mod)




cleanEx()
nameEx("nap")
### * nap

flush(stderr()); flush(stdout())

### Name: nap
### Title: Non-overlap of All Pairs (NAP) Analysis
### Aliases: nap

### ** Examples

nap(.df = reversal_withdrawal, .y = "extbehavs", .phase = "phase",
    .time = "time", type = "reversability",
    phases = list("baseline1", "baseline2"), improvement = "negative")




cleanEx()
nameEx("napjack")
### * napjack

flush(stderr()); flush(stdout())

### Name: napjack
### Title: Nap Jack: A Single Case Design Card Game
### Aliases: napjack

### ** Examples

# To run the Shiny app
if(interactive()){
  napjack()
}




cleanEx()
nameEx("plot.cross_lagged")
### * plot.cross_lagged

flush(stderr()); flush(stdout())

### Name: plot.cross_lagged
### Title: Plot Cross-Lagged Correlation Results
### Aliases: plot.cross_lagged

### ** Examples

#Creating a sample dataset
reversal_withdrawal <- data.frame(
  phase = c(rep("baseline1", 6), rep("teratment1", 5), rep("baseline2", 5), rep("teratment2", 5)),
  time = 1:21,
  extbehavs = c(15, 10, 14, 17, 13, 12, 2, 1, 1, 0, 0, 9, 9, 11, 15, 20, 1, 0, 4, 0, 1)
)

reversal_withdrawal$synth <- sapply(reversal_withdrawal$time, function(x) {
  stats::rpois(1, x)
})

reversal_withdrawal <- as.data.frame(reversal_withdrawal)

# Using the cross_lagged function
cl_result <- cross_lagged(reversal_withdrawal, .x = "time", .y = "synth")

# Plot the cross-lagged correlation results
plot(cl_result)




cleanEx()
nameEx("plot.replext_gls")
### * plot.replext_gls

flush(stderr()); flush(stdout())

### Name: plot.replext_gls
### Title: Plot Results from Replications and Extension of GLS Simulation
### Aliases: plot.replext_gls

### ** Examples

results <- replext_gls(
  n_timepoints_list = c(10),
  rho_list = c(0.2),
  iterations = 10,
  betas = c("(Intercept)" = 0, "phase1" = 1),
  formula = y ~ phase
)
plot(results, term = "phase1", metric = "rejection_rates")




cleanEx()
nameEx("print.cross_lagged")
### * print.cross_lagged

flush(stderr()); flush(stdout())

### Name: print.cross_lagged
### Title: Print Method for Cross-Lagged Objects
### Aliases: print.cross_lagged

### ** Examples

#Creating a sample dataset
reversal_withdrawal <- data.frame(
  phase = c(rep("baseline1", 6), rep("teratment1", 5), rep("baseline2", 5), rep("teratment2", 5)),
  time = 1:21,
  extbehavs = c(15, 10, 14, 17, 13, 12, 2, 1, 1, 0, 0, 9, 9, 11, 15, 20, 1, 0, 4, 0, 1)
)

reversal_withdrawal$synth <- sapply(reversal_withdrawal$time, function(x) {
  stats::rpois(1, x)
})

reversal_withdrawal <- as.data.frame(reversal_withdrawal)

# Using the cross_lagged function
cl_result <- cross_lagged(reversal_withdrawal, .x = "time", .y = "synth")

# Print the summary of cross-lagged analysis
print(cl_result)




cleanEx()
nameEx("randomization_test")
### * randomization_test

flush(stderr()); flush(stdout())

### Name: randomization_test
### Title: Randomization Test for Single-Case Experiments
### Aliases: randomization_test

### ** Examples

result <- randomization_test(sleeping_pills, .out = "sever_compl",
                             .cond = "treatment", .time = "day",
                             num_permutations = 100,
                             cond_levels = c("C", "E"))

result$conf_int




cleanEx()
nameEx("raw_plot")
### * raw_plot

flush(stderr()); flush(stdout())

### Name: raw_plot
### Title: Plot Raw Data with Optional Phase and Condition Annotations
### Aliases: raw_plot

### ** Examples

rp <- raw_plot(.df = efficacy_of_CBT, .out = "Anxious", .time = "time",
               .phase = "phase", phase_levels = c(0, 1),
               phase_labels = c("Exposure", "Exposure + CT"))




cleanEx()
nameEx("replext_gls")
### * replext_gls

flush(stderr()); flush(stdout())

### Name: replext_gls
### Title: Replications and Extension of Generalized Least Squares
###   Simulation
### Aliases: replext_gls

### ** Examples

results <- replext_gls(
  n_timepoints_list = c(10),
  rho_list = c(0.2),
  iterations = 10,
  betas = c("(Intercept)" = 0, "phase1" = 1),
  formula = y ~ phase
)




cleanEx()
nameEx("replext_pgsql")
### * replext_pgsql

flush(stderr()); flush(stdout())

### Name: replext_pgsql
### Title: Replication and Extension of Generalized Least Squares
###   Simulation Shiny App
### Aliases: replext_pgsql

### ** Examples

if(interactive()){
replext_pgsql(
  dbname = "my_database",
  datatable = "simulation_results",
  host = "localhost",
  port = 5432,
  user = "myuser",
  password = "mypassword"
)
}




cleanEx()
nameEx("scdtb")
### * scdtb

flush(stderr()); flush(stdout())

### Name: scdtb
### Title: Single Case Design Toolbox Shiny Application
### Aliases: scdtb

### ** Examples

# To run the Shiny app
if(interactive()){
  scdtb()
}




cleanEx()
nameEx("simulate_gls_once")
### * simulate_gls_once

flush(stderr()); flush(stdout())

### Name: simulate_gls_once
### Title: Simulate and Analyze Generalized Least Squares
### Aliases: simulate_gls_once

### ** Examples

# Simple example with 2 phases, 10 timepoints per phase, and no covariates
result <- simulate_gls_once(
  n_timepoints_per_phase = 10,
  rho = 0.2,
  betas = c("(Intercept)" = 0, "phase1" = 1),
  formula = y ~ phase
)




### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
