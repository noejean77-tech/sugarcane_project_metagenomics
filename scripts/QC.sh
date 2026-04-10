#!/bin/bash


# definissons les variables

RAW_DATA="/scratch/noe/sugarcane_projet/raw_data/merged_fastq"
DIR_QC="/scratch/noe/sugarcane_projet/results/1_QC"

mkdir -p "$DIR_QC"


# telechargeons des modules
echo "chargement des modules"
module load bioinfo-wave 
module load  nanoplot/1.41.3
module load NanoComp/1.23.1

for file in "${RAW_DATA}"/*.fastq; do
  name=$(basename "$file" .fastq)
  echo "Debut d'analyse de $name"
  # controle qualité des reads
  echo "QC de $name"
  NanoPlot -t "$SLURM_CPUS_PER_TASK" --fastq "$file" -o "$DIR_QC/${name}"
done


# Comparaison QC globale (NanoComp)
echo "Comparaison QC des 11 échantillons"

NanoComp -t "$SLURM_CPUS_PER_TASK" --fastq "$RAW_DATA"/*.fastq -o "$DIR_QC/all_samples_QC"

echo "Analyse terminée !"
