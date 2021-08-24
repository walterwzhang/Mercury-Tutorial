#!/bin/bash

#Here is a comment

#SBATCH --account=phd

#SBATCH --job-name=Parallel_Job
#SBATCH --output=parallel-%j.out
#SBATCH --error=parallel-%j.err

#SBATCH --time=00:05:00

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=2 # Use 2 cores
##SBATCH --mem-per-cpu=1G # Ask for 1 GB memory per cpu


# Print some useful variables

echo "Job ID: $SLURM_JOB_ID"
echo "Job User: $SLURM_JOB_USER"
echo "Num Cores: $SLURM_JOB_CPUS_PER_NODE"
echo "I have $SLURM_JOB_CPUS_PER_NODE cores allocated on this job."


# Load the Modules
module load R/4.0/4.0.2


# Run your code
echo "Begin Job"
Rscript parallel-job.R
echo "Job Complete"
