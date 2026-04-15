#!/bin/bash

### Set the job name
#SBATCH --job-name=Kraken_Classification

### Set the number of CPUs to use
#SBATCH --cpus-per-task=4

### Set the partition to use
#SBATCH --partition=normal

#SBATCH --nodelist=node02

### error file and file output
#SBATCH --output=/scratch/noe/sugarcane_projet/logs/Kraken_Classification_%j.out
#SBATCH --error=/scratch/noe/sugarcane_projet/logs/Kraken_Classification_%j.err

# Download the module
module load bioinfo-shared
module load kraken2/2.1.2
module load krona

# Let's define the variables
CONTIGS_POLISHING="/scratch/noe/sugarcane_projet/results/5_polishing/Racon_polishing"
OUT_DIR="/scratch/noe/sugarcane_projet/results/6_kraken_contigs_polishing"
DB_KRAKEN="/scratch/noe/sugarcane_projet/banks/db_kraken"

mkdir -p "$OUT_DIR"

for file in "$CONTIGS_POLISHING"/*_polishing.fasta; do
   names=$(basename $file _polishing.fasta)
   echo "Kraken of $names"

   # Fix fasta headers to remove everything after the ID
   fixed_file="${OUT_DIR}/${names}_headers_fixed.fasta"
   awk '{print $1}' "$file" > "$fixed_file"

   # Classification taxonmique kraken
   kraken2 --db "$DB_KRAKEN" "$fixed_file" --threads $SLURM_CPUS_PER_TASK --report "$OUT_DIR/${names}_kraken_report" --output "$OUT_DIR/${names}_kraken_output"
done

ktImportTaxonomy -q 2 -t 5 ${OUT_DIR}/*_kraken_report -o ${OUT_DIR}/sugarcane_polishing_krona.htmlktImportTaxonomy -q 2 -t 5 ${OUT_DIR}/*_kraken_report -tax /home/noe/krona_db -o ${OUT_DIR}/combined_samples_krona.html
