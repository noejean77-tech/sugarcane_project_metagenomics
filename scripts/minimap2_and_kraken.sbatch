#!/bin/bash

### set the job name
#SBATCH --job-name=Minimap2_and_kraken

### Set the number of CPUs to use 
#SBATCH --cpus-per-task=8

###Total RAM allocated (for step of mapping and kraken)
#SBATCH --mem=30G      

### Set the partition to use
#SBATCH --partition=normal  
 
###Specify the node on which the job should run
#SBATCH --nodelist=node02 

### error file and file output (If an error occurs, I can check the .err file to understand the problem)
#SBATCH --output=/scratch/noe/sugarcane_projet/logs/Minimap2_and_kraken_%j.out 
#SBATCH --error=/scratch/noe/sugarcane_projet/logs/Minimap2_and_kraken_%j.err  


# Let's define the variables
REF="/scratch/noe/sugarcane_projet/banks/reference_cat_sugarcane/genome_ref.fna"
RAW_DATA="/scratch/noe/sugarcane_projet/raw_data/merged_fastq"
CLEANING_DIR="/scratch/noe/sugarcane_projet/results/2_mapping"
DB_KRAKEN="/scratch/noe/sugarcane_projet/banks/db_kraken"
OUT_KRAKEN="/scratch/noe/sugarcane_projet/results/3_kraken_read_unmapped"

# Let's load the modules
module load  bioinfo-wave
module load minimap2/2.30.0
module load samtools/1.19.2
module load kraken2/2.17.1

# Let's create recursive directories
mkdir -p "$CLEANING_DIR"
mkdir -p "$OUT_KRAKEN"


for file in "${RAW_DATA}"/*.fastq; do     # I create a loop that iterates through the files in the RAW_DATA variable, and on each iteration I store the file name in a temporary variable called file 
  names=$(basename "$file" .fastq)        # To retrieve the filename without the .fastq extension, we then assign it to a variable called names       
  echo "start of analysis of $names"    
  # Filtering reads using the reference genome
  echo "Mapping reads to the reference genome for the samples $names"
  minimap2 -I 10G -t "$SLURM_CPUS_PER_TASK" -ax map-ont "$REF" "$file" -o "${CLEANING_DIR}/${names}_mapped.sam"  # because the sugarcane genome is approximately 10GB in size and minimap uses -I 8G by default 
  echo "generation of mapping statistics (samtools flagstat) for $names"
  samtools flagstat "${CLEANING_DIR}/${names}_mapped.sam" > "${CLEANING_DIR}/$names.stats"
  echo "retrieval of unmapped reads for $names, conversion from SAM to BAM (samtools view) and bam in FASTQ (samtools fastq) "
  samtools view -@ "$SLURM_CPUS_PER_TASK" -f 4 -b "${CLEANING_DIR}/${names}_mapped.sam" > "${CLEANING_DIR}/${names}_unmapped.bam"
  samtools fastq "${CLEANING_DIR}/${names}_unmapped.bam" > "${CLEANING_DIR}/${names}_unmapped.fastq"
  # Taxonomic classification of unmapped reads using Kraken2 with the k2_pluspfp_16_GB database
  echo "kraken2 de $names"
  kraken2 --db "$DB_KRAKEN" "${CLEANING_DIR}/${names}_unmapped.fastq" --threads "$SLURM_CPUS_PER_TASK" --report "${OUT_KRAKEN}/${names}_kraken_report.txt" --output "${OUT_KRAKEN}/${names}_kraken_output.txt"
  echo "end of the analysis"
done





