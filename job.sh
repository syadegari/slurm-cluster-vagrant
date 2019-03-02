#!/bin/bash
#SBATCH -o /home/vagrant
#SBATCH -p debug
#SBATCH --ntasks-per-node=1
#SBATCH -t 12:00:00
#SBATCH -J some_job_name
hostname
