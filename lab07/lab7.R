set.seed(123)
x <- runif(n=100)

serial_sum <- function(x){
  x_sum <- sum(x)
  return(x_sum)
}


library(parallel)
set.seed(123)
x <- runif(n=100)

parallel_sum <- function(x) {
  
  # Set number of cores to use
  n_cores <- min(4, parallel::detectCores())
  
  # Make cluster
  cl <- parallel::makeCluster(n_cores)
  
  # Export x to the cluster
  parallel::clusterExport(cl, "x", envir = .GlobalEnv)
  
  # Split x into chunks
  x_split <- split(x, rep(1:n_cores, length.out = length(x)))
  
  # Calculate partial sums using parLapply
  partial_sums <- parallel::parLapply(cl, x_split, sum)
  
  # Stop the cluster
  parallel::stopCluster(cl)
  
  # Add and return partial sums
  return(sum(unlist(partial_sums)))
}

parallel_sum()

###Better solution
parallel_sum2 <- function(x, n_cores = 4) {
  
  # Set number of cores to use
  cl <- parallel::makePSOCKcluster(n_cores)
  
  # Split the data into chunks for each core
  indices <- parallel::splitIndices(length(x), n_cores)
  x_split <- lapply(indices, \(i) x[i])
  
  # Calculate partial sums doing something like:
  partial_sums <- parallel::parSapply(cl, x_split, sum)
  
  # Stop the cluster
  parallel::stopCluster(cl)
  
  # Add and return the partial sums
  sum(partial_sums)
  
}


# Compare with regular sum
serial_sum(x)
parallel_sum(x)
parallel_sum2(x)

bench::mark(
  serial = serial_sum(x),
  parallel = parallel_sum(x),
  parallel2 = parallel_sum2(x),
  relative = TRUE,
  check = TRUE
)


###### Question 2
library(parallel)

# 1. A function that simulates ONE dataset of size n using a given seed,
#    fits the probit model, and returns TRUE if H0 is rejected
sim_one <- function(n, seed, beta = c(0, 0.5, 1), alpha = 0.05) {
  
  set.seed(seed)
  
  x <- rnorm(n, mean = 0, sd = 1)
  
  d <- sample(rep(c(0, 1), each = n / 2))
  
  p <- pnorm(beta[1] + beta[2] * d + beta[3] * x)
  
  y <- rbinom(n, size = 1, prob = p)
  
  # Fit the probit model
  model <- glm(y ~ d + x,
               family = binomial(link = "probit"))
  
  # Extract the z-value for d
  z <- summary(model)$coefficients["d", "z value"]
  
  # Return TRUE/FALSE
  abs(z) > qnorm(1 - alpha / 2)
  
  
}

# 2. The simulation grid: one row per (sample size, replicate), with its
#    own seed drawn ONCE in the main session
set.seed(7045)
sizes <- seq(100, 1000, by = 100)
nsim  <- 500
grid  <- expand.grid(rep = 1:nsim, n = sizes)
grid$seed <- sample.int(.Machine$integer.max, nrow(grid))

# 3. Run the simulation in serial
ans_serial <- lapply(seq_len(nrow(grid)), function(i) {
  sim_one(grid$n[i], grid$seed[i])
})

# 4. Run the simulation in parallel (create the cluster, export what
#    the workers need, run parLapply, stop the cluster)

# Set number of cores
n_cores <- 4

# Create cluster
cl <- parallel::makeCluster(n_cores)

# Export variables and function
parallel::clusterExport(
  cl,
  c("grid", "sim_one"),
  envir = environment()
)

# Run simulations in parallel
ans_parallel <- parallel::parLapply(
  cl,
  seq_len(nrow(grid)),
  function(i) {
    sim_one(grid$n[i], grid$seed[i])
  }
)

# Stop cluster
parallel::stopCluster(cl)

# Convert to logical vector
ans_parallel <- unlist(ans_parallel)

# Calculate empirical power
power_parallel <- aggregate(
  ans_parallel,
  by = list(n = grid$n),
  FUN = mean
)

names(power_parallel)[2] <- "power"

print(power_parallel)


# 5. Check that both are the same and compute the power by sample size
identical(ans_serial, ans_parallel)
tapply(unlist(ans_parallel), grid$n, mean)
