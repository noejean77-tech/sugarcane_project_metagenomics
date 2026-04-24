#!/bin/bash


# definissons les variables
BASE_DIR="/home/noe/cibig_noe/project_stage_tutore"
RAW_DATA="$BASE_DIR/raw_data/merged_fastq"
DIR_QC="$BASE_DIR/results/1_QC"

mkdir -p "$DIR_QC"


# telechargeons des modules
echo "chargement des modules"
module load  nanoplot/1.41.3
module load NanoComp/1.23.1

for file in "${RAW_DATA}"/*.fastq; do
  name=$(basename "$file" .fastq)
  echo "Debut d'analyse de $name"
  # controle qualité des reads
  echo "QC de $name"
  NanoPlot -t "$SLURM_CPUS_PER_TASK" --fastq "$file" -o "$DIR_QC/${name}"
done


# Comparaison QC globale 
echo "Comparaison QC des 11 échantillons"

# Construction des listes de fichiers et de noms
FASTQ_FILES=()
NAMES=()

for file in "$RAW_DATA/"*.fastq; do
    name=$(basename "$file" .fastq)
    FASTQ_FILES+=("$file")
    NAMES+=("$name")
done

NanoComp -t "$SLURM_CPUS_PER_TASK" \
         --fastq "${FASTQ_FILES[@]}" \
         --names "${NAMES[@]}" \
         -o "${DIR_QC}/all_samples_QC"

echo "Analyse terminée !"
