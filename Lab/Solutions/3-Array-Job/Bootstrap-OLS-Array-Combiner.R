# Bootstrap-OLS-Array-Combiner.R
# ---------------------------------------------------------------------------------------
# Author: Walter W. Zhang
# Last Edited: 9-21-2020
# Array Job Results Combiner
# Submit the job with `sbatch --array=[3] array.sh`
# Run this script after the array jobs are done to combine the saved results



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


# Combine Results -----------------------------------------------------------------------

# First array job results
load("Bootstrap_Coef_Mat_Array-Job-1.RData")
B_mat_1 <- B_mat
# Second array job results
load("Bootstrap_Coef_Mat_Array-Job-2.RData")
B_mat_2 <- B_mat

# Stack the two matricies
B_mat <- rbind(B_mat_1, B_mat_2)

# B_mat is now (B x P) with all 1000 boostrap iterations


# Compute bootstrap estimates
mean_vec <- colMeans(B_mat)    # Bootstrap Means for each p
se_vec <- apply(B_mat, 2, sd)  # Bootstrap SE for each p

# Data.frame of results
coef_boot_DF <- data.frame(Estimate = mean_vec,
                           SE       = se_vec)
# ---------------------------------------------------------------------------------------



# Comparison ----------------------------------------------------------------------------

# Bootstrap Mean and SE
print("Bootstrap Results (1000 iterations)) ---------------------------------------------------")
print(coef_boot_DF)
print("----------------------------------------------------------------------------------------")


# OLS Coef with SE
print("OLS Results ----------------------------------------------------------------------------")
summary(lm(Y ~ X_mat + 0))
print("----------------------------------------------------------------------------------------")

# ---------------------------------------------------------------------------------------
