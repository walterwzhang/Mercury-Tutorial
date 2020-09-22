# Instructions

Submit the job to SLURM by running the following command in the Linux command line.

```
sbatch --array=[0-2] array.sh
```

With your booth id, see your job in action with:

```
squeue -u <Booth-ID>
```

- The output of the job is in `array-<job-id>-<array-id>.out`
- The errors from the job will be in `array-<job-id>-<array-id>.err` if there were any errors
