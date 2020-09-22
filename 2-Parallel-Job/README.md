# Instructions

Submit the job to SLURM by running the following command in the Linux command line. The job will call a parallelized R script (parallel-job.R).

```
sbatch parallel.sh
```

With your booth id, see your job in action with:

```
squeue -u <Booth-ID>
```

- The output of the job is in `parallel-<job-id>.out`
- The errors from the job will be in `parallel-<job-id>.err` if there were any errors
