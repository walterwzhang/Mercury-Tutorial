# Bootstrap-OLS-Parallel.R
# ---------------------------------------------------------------------------------------
# Author: Walter W. Zhang
# Last Edited: 9-21-2020
# Parallel Job
# Submit the job with `sbatch parallel.sh`



# Load packages
require(parallel)

# Get the number of cores requested from the job
num_cores <- as.integer(Sys.getenv("SLURM_JOB_CPUS_PER_NODE"))
print(paste0("I have ", num_cores, " cores ready in R."))



# Simulate the Data ---------------------------------------------------------------------

p <- 50     # Number of Covariates
N <- 10000  # Number of Observations

# Set the seed
set.seed(1234)

# Simulate X1, ..., X50 \sim N(0,1)
X_mat <- matrix(rnorm(p * N), ncol = 50)
# Simulate \sim N(01,)
epsilon <- rnorm(N)
# True betas are (1, ..., 50)
beta_true <- 1:50

# Construct Y
Y <-  X_mat %*% beta_true + epsilon

# ---------------------------------------------------------------------------------------



# Bootstrap Procedure -------------------------------------------------------------------

B <- 1000 # Bootstrap Iterations

# Bootstrap Loop over B
init_time <- Sys.time()
## mclapply here for parallel lapply
### mclapply doesn't work on windows
B_list <- mclapply(1:B, function(bootstrap_ind)
{
    # We need to be careful with the random seed for parallel jobs
    ## Force the seed for each b
    set.seed(1234 * 1000 + bootstrap_ind)

    # For each b or bootstrap_ind
    ## Sample with replacement for bootstrap of the data
    sample_ind <- sample(1:N, N, replace = TRUE)
    ## Get OLS Coefficients on the bootstrap
    coef(lm(Y[sample_ind,] ~ X_mat[sample_ind,] + 0))
}, mc.cores = num_cores)
end_time <- Sys.time()
paste0("Time Elapsed: ", format(end_time - init_time, digits = 3))

# Collate results to a matrix (B X P)
B_mat <- do.call(rbind, B_list)
colnames(B_mat) <- c(paste0("X", 1:p))

# Compute bootstrap estimates
mean_vec <- colMeans(B_mat)    # Bootstrap Means for each p
se_vec <- apply(B_mat, 2, sd)  # Bootstrap SE for each p

# Data.frame of results
coef_boot_DF <- data.frame(Estimate = mean_vec,
                           SE       = se_vec)

# Bootstrap Mean and SE
print("Bootstrap Results ----------------------------------------------------------------------")
print(coef_boot_DF)
print("----------------------------------------------------------------------------------------")
# ---------------------------------------------------------------------------------------



# Comparison ----------------------------------------------------------------------------

# OLS Coef with SE
print("OLS Results ----------------------------------------------------------------------------")
summary(lm(Y ~ X_mat + 0))
print("----------------------------------------------------------------------------------------")
# ---------------------------------------------------------------------------------------
