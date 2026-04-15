#!/bin/bash

### Set the job name
#SBATCH --job-name=Polishing

### Set the number of CPUs to use 
#SBATCH --cpus-per-task=4

### Set the partition to use
#SBATCH --partition=normal

#SBATCH --nodelist=node02

### error file and file output
#SBATCH --output=/scratch/noe/sugarcane_projet/logs/polishing_%j.out
#SBATCH --error=/scratch/noe/sugarcane_projet/logs/polishing_%j.err


# Let's define the variables 
READS="/scratch/noe/sugarcane_projet/results/2_mapping/"
CONTIGS="/scratch/noe/sugarcane_projet/results/5_polishing/input_contigs/"
OUTDIR="/scratch/noe/sugarcane_projet/results/5_polishing"
OUTDIR_RACON="/scratch/noe/sugarcane_projet/results/5_polishing/Racon_polishing"

mkdir -p "$OUTDIR"
mkdir -p "$OUTDIR_RACON"

# download the modules 
module load bioinfo-wave
module load minimap2/2.30.0 
module load racon/1.4.20 

# Creating a loop 
for file in "$READS"/*_unmapped.fastq; do
  # Retrieve the file names and store them in a new variable without the extension _unmapped.fastq
  names=$(basename $file _unmapped.fastq)
  echo "Polishing of $names"
  # Let’s retrieve the files from the CONTIGS variable and then store them in a new variable called contigs 
  contigs="$CONTIGS/${names}_contigs.fasta"
  # Mapping unmapped reads to contigs 
  minimap2 -t $SLURM_CPUS_PER_TASK -x map-ont "$contigs" "$file" > "$OUTDIR/${names}_backmapping.paf" 
  # Let's launch racon
  racon -t $SLURM_CPUS_PER_TASK "$file" "$OUTDIR/${names}_backmapping.paf" "$contigs" > "$OUTDIR_RACON/${names}_racon_polishing.fasta"
  echo "End of polishing de $names"
done

