# Bootstrap-OLS-Array.R
# ---------------------------------------------------------------------------------------
# Author: Walter W. Zhang
# Last Edited: 9-21-2020
# Array Job
# Submit the job with `sbatch --array=[1-2] array.sh`
## First array job computes first 500 bootstrap iterations
## Second array job computes last 500 bootstrap iterations
# Run Bootstrap-OLS-Array-Combiner.R after the jobs are done to combine the saved results

# Get the Array Job Index
array_index <- as.integer(Sys.getenv("SLURM_ARRAY_TASK_ID"))
print(paste0("This is array job ", array_index, "."))



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

# First job runs first 500 bootstrap indices
# Second job runs last 500 bootstrap indices
# We also need to be careful with the random seed
if (array_index == 1)
{
    boot_vec <- 1:(B/2)
    set.seed(1234 * 2000)
} else
{
    boot_vec <- (B/2+1):B
    # Set seed so the second array job has fresh draws
    set.seed(1234 * 2000 + 500)
}

# Bootstrap Loop over B, which is over boot_vec here
init_time <- Sys.time()
B_list <- lapply(boot_vec, function(bootstrap_ind)
{


    # For each b or bootstrap_ind
    ## Sample with replacement for bootstrap of the data
    sample_ind <- sample(1:N, N, replace = TRUE)
    ## Get OLS Coefficients on the bootstrap
    coef(lm(Y[sample_ind,] ~ X_mat[sample_ind,] + 0))
})
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
print("Bootstrap Results (500 iterations)) ----------------------------------------------------")
print(coef_boot_DF)
print("----------------------------------------------------------------------------------------")
# ---------------------------------------------------------------------------------------



# Comparison ----------------------------------------------------------------------------

# OLS Coef with SE
print("OLS Results ----------------------------------------------------------------------------")
summary(lm(Y ~ X_mat + 0))
print("----------------------------------------------------------------------------------------")

# ---------------------------------------------------------------------------------------



# Save Bootstrap Results ----------------------------------------------------------------
## We can combine then later (in an interactive R session)

save(B_mat, file = paste0("Bootstrap_Coef_Mat_Array-Job-", array_index, ".RData"))

# ---------------------------------------------------------------------------------------