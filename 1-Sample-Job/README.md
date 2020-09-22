# Instructions

Submit the job to SLURM by running the following command in the Linux command line.

```
sbatch submit.sh
```

With your booth id, see your job in action with:

```
squeue -u <Booth-ID>
```

- The output of the job is in `slurm-<job-id>.out`
- The errors from the job will be in `slurm-<job-id>.err` if there were any errors
