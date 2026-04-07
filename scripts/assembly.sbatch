#!/bin/bash

#SBATCH --job-name=Flye
#SBATCH --cpus-per-task=4
#SBATCH --mail-user noejean77@gmail.com
#SBATCH --partition=normal
#SBATCH --output=/home/noe/cibig_noe/project_stage_tutore/logs/Flye_%j.out
#SBATCH --error=/home/noe/cibig_noe/project_stage_tutore/logs/Flye_%j.err
##########################################

# definissons les variables
DATA="/home/noe/cibig_noe/project_stage_tutore/results/2_cleaning"
OUTDIR="/home/noe/cibig_noe/project_stage_tutore/results/4_assemblage"

mkdir -p "$OUTDIR"

# telechargeons les modules
module load bioinfo-wave
module load flye/2.9.6-b1802

# definissons la commande singularity Flye
FLYE_CMD="singularity run /usr/local/bioinfo/containers/flye-2.9.6.sif"

for file in "$DATA"/*.fastq; do
  names=$(basename "$file" .unmapped.fastq)
  echo "Assemblage de $names"
  # effectuons l'assemblage
  $FLYE_CMD --nano-raw "$file" --threads "$SLURM_CPUS_PER_TASK" --out-dir "$OUTDIR/$names"
done