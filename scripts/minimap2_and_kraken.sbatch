#!/bin/bash
### set the job name
#SBATCH --job-name=Minimap2...kraken
### Set the number of CPUs to use 
#SBATCH --cpus-per-task=8
###Total RAM allocated
#SBATCH --mem=40G
### Set the partition to use
#SBATCH --partition=normal
###Specify the node on which the job should run
#SBATCH --nodelist=node02
### error file and file output
#SBATCH --output=/scratch/noe/sugarcane_projet/logs/Minimap2...kraken_%j.out 
#SBATCH --error=/scratch/noe/sugarcane_projet/logs/Minimap2...kraken_%j.err
##########################################

# defissons les variables
REF="/scratch/noe/sugarcane_projet/banks/reference_cat_sugarcane/genome_ref.fna"
RAW_DATA="/scratch/noe/sugarcane_projet/raw_data/merged_fastq"
CLEANING_DIR="/scratch/noe/sugarcane_projet/results/2_mapping"
DB_KRAKEN="/scratch/noe/sugarcane_projet/banks/db_kraken"
OUT_KRAKEN="/scratch/noe/sugarcane_projet/results/3_kraken_read_unmapped"

# telechargeons les modules
module load  bioinfo-wave
module load minimap2/2.17
module load samtools/1.19.2
module load kraken2/2.17.1

# creons les dossiers recursifs
mkdir -p "$CLEANING_DIR"
mkdir -p "$OUT_KRAKEN"

# definissons la commande minimap car c'est un alias
MINIMAP2_CMD="singularity run /usr/local/bioinfo/containers/minimap2-2.2.17.sif"

for file in "${RAW_DATA}"/*.fastq; do
  names=$(basename "$file" .fastq)
  echo "debut d'analyse de $names"
  # suppression du genomes de references et recuperation des reads unmapped
  echo "suppression du genomes de references pour l'echantillons $names"
  $MINIMAP2_CMD -I 20G -t "$SLURM_CPUS_PER_TASK" -ax map-ont "$REF" "$file" -o "${CLEANING_DIR}/${names}_mapped.sam"
  echo "generation des stats du mapping (samtools flagstat) pour $names"
  samtools flagstat "${CLEANING_DIR}/${names}_mapped.sam" > "${CLEANING_DIR}/$names.stats"
  echo "recuperation des reads unmapped pour $names, conversion sam en bam (samtools view) et bam en fastq (samtools fastq) "
  samtools view -@ "$SLURM_CPUS_PER_TASK" -f 4 -b "${CLEANING_DIR}/${names}_mapped.sam" > "${CLEANING_DIR}/${names}_unmapped.bam"
  samtools fastq "${CLEANING_DIR}/${names}_unmapped.bam" > "${CLEANING_DIR}/${names}_unmapped.fastq"
  # classification taxonomique des reads unmapped avec kraken2 avec la base de données k2_pluspfp_16_GB
  echo "kraken2 de $names"
  kraken2 --db "$DB_KRAKEN" "${CLEANING_DIR}/${names}_unmapped.fastq" --threads "$SLURM_CPUS_PER_TASK" --report "${OUT_KRAKEN}/${names}_kraken_report.txt" --output "${OUT_KRAKEN}/${names}_kraken_output.txt"
  echo "fin de l'analyse"
done





