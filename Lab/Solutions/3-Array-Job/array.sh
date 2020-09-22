#!/bin/bash

# This is a comment

#---------------------------------------------------------------------------------
# Account information

#SBATCH --account=phd              # basic (default), staff, phd, faculty

#---------------------------------------------------------------------------------
# Resources requested

#SBATCH --partition=standard       # standard (default), long, gpu, mpi, highmem
#SBATCH --cpus-per-task=1          # number of CPUs requested (for parallel tasks)
#SBATCH --mem=1G                   # requested memory
#SBATCH --time=0-00:05:00          # wall clock limit (d-hh:mm:ss)

# We requested 1 cpu, 1GB RAM, and 5 minutes of run time

#---------------------------------------------------------------------------------
# Job specific name (helps organize and track progress of jobs)

#SBATCH --job-name=serial_job    # user-defined job name

# Error and Output file names

#SBATCH --output=array_job-%j.out
#SBATCH --error=array_job-%j.err

#---------------------------------------------------------------------------------
# Print some useful variables

echo "Job ID: $SLURM_JOB_ID"
echo "Job User: $SLURM_JOB_USER"
echo "Num Cores: $SLURM_JOB_CPUS_PER_NODE"
echo "Running job array number: $SLURM_ARRAY_TASK_ID"

#---------------------------------------------------------------------------------
# Load necessary modules for the job

# module load <modulename>
module load R

#---------------------------------------------------------------------------------
# Commands to execute below

Rscript --vanilla Bootstrap-OLS-Array.R

#---------------------------------------------------------------------------------
