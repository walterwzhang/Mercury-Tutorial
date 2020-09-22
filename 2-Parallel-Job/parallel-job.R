# parallel-job.R
# Runs a parallel job in R

library(parallel)

# Get number of cores from the SLURM_JOB_CPUS_PER_NODE enviromental variable
num_cores <- as.integer(Sys.getenv("SLURM_JOB_CPUS_PER_NODE"))
print(paste0("I have ", num_cores, " cores ready in R."))

# Run a parallel job

print("Using the two cores in parallel.")
print("Each core will sleep for 30 seconds and then print the time.")
print("If the two printed times are the same then we know the jobs were run in parallel.")
print("If the two printed times are 30 seconds apart then we know the jobs were run in serial or sequentially.")

out_list <- mclapply(1:2, function(x)
{
    Sys.sleep(30)
    paste0("Printed Time ", x, ": ", Sys.time())
}, mc.cores = num_cores)

print(out_list)
