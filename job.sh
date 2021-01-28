#!/bin/bash
#SBATCH --output=LOG.exp.icon-lam_nwp1nest.run.%j.o
#SBATCH --error=LOG.exp.icon-lam_nwp1nest.run.%j.e
#SBATCH --ntasks-per-node=1
#SBATCH -t 12:00:00
#SBATCH -J some_job_name

# https://slurm.schedmd.com/sbatch.html
SLURM_vars='SLURM_JOB_ID SLURM_JOB_NAME SLURM_JOB_NODELIST SLURM_JOB_PARTITION SLURM_MEM_PER_CPU SLURM_MEM_PER_NODE SLURM_PRIO_PROCESS SLURM_SUBMIT_DIR SLURM_SUBMIT_HOST SLURM_TASK_PID SLURMD_NODENAME'

echo ">>> Some useful SLURM job environment variables:"

for item in ${SLURM_vars}; do
    printf "${item}: ${!item:-none}\n"
done

printf ">>> System hostname: %s\n" "$(hostname)"
sleep 3
