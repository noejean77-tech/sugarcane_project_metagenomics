#!/bin/bash

### Set the job name
#SBATCH --job-name=Kraken_contigs_polishing

### Set the number of CPUs to use 
#SBATCH --cpus-per-task=8

### Set the partition to use
#SBATCH --partition=normal

#SBATCH --nodelist=node02

### error file and file output
#SBATCH --output=/scratch/noe/sugarcane_projet/logs/Kraken_contigs_polishing_%j.out
#SBATCH --error=/scratch/noe/sugarcane_projet/logs/Kraken_contigs_polishing_%j.err

# Download the module
module load kraken2/2.1.2 


# Let's define the variables 
CONTIGS_POLISHING="/scratch/noe/sugarcane_projet/results/5_polishing/Racon_polishing"
OUT_DIR="/scratch/noe/sugarcane_projet/results/6_kraken_contigs_polishing"
DB_KRAKEN="/scratch/noe/sugarcane_projet/banks/db_kraken"

mkdir -p "$OUT_DIR"

for file in "$CONTIGS_POLISHING"/*_polishing.fasta; do
   names=$(basename $file _polishing.fasta)
   echo "Kraken of $names" 
   # Classification taxonmique kraken 
   kraken2 --db "$DB_KRAKEN" "$CONTIGS_POLISHING" --threads $SLURM_CPUS_PER_TASK --report "$OUT_DIR/${names}_kraken_report" --output "$OUT_DIR/${names}_kraken_output"  
done 
