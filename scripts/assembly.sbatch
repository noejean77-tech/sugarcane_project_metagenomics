#!/bin/bash

### Set the job name
#SBATCH --job-name=Flye

### Set the number of CPUs to use 
#SBATCH --cpus-per-task=12

### Set the partition to use
#SBATCH --partition=normal


### error file and file output
#SBATCH --output=/scratch/noe/sugarcane_projet/logs/Flye_%j.out
#SBATCH --error=/scratch/noe/sugarcane_projet/logs/Flye_%j.err
##########################################

# Let's define the variables 
DATA="/scratch/noe/sugarcane_projet/results/2_mapping"
OUTDIR="/scratch/noe/sugarcane_projet/results/4_assembly"

mkdir -p "$OUTDIR"

# Download the module flye
module load bioinfo-wave
module load flye/2.9.6


for file in "$DATA"/*.fastq; do
  names=$(basename "$file" .unmapped.fastq)
  echo "Assembly of $names"
  # let's start the assembly 
  flye --nano-raw "$file" --threads "$SLURM_CPUS_PER_TASK" --out-dir "$OUTDIR/$names"
done