#!/bin/bash

#Here is a comment

#SBATCH --account=phd

#SBATCH --job-name=Array_Job

# Use '%A' for array-job ID, '%J' for job ID and '%a' for task ID

#SBATCH --output=array-%j-%a.err
#SBATCH --error=array-%j-%a.out

#SBATCH --time=00:02:00

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
##SBATCH --mem-per-cpu=1G


# Print some useful variables

echo "Job ID: $SLURM_JOB_ID"
echo "Job User: $SLURM_JOB_USER"
echo "Num Cores: $SLURM_JOB_CPUS_PER_NODE"


echo "Array Job Begin"


# Use the $SLURM_ARRAY_TASK_ID variable to provide different inputs for each job

echo "Running job array number: $SLURM_ARRAY_TASK_ID"


# You can use the array index as an array index

input=(A B C D E)
echo "Hello I am selling T-shirt design "  ${input[$SLURM_ARRAY_TASK_ID]}


# You can also move the array index around to provide different inputs

input=$((SLURM_ARRAY_TASK_ID*100+5))
echo "Running job array number: "$SLURM_ARRAY_TASK_ID "input " $input


echo "Array Job Complete"
