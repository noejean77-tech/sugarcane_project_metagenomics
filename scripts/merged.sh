#!/bin/bash

# Dossier où seront stockés les fichiers fusionnés
mkdir -p merged_fastq

for b in {75..85}; do
    echo "Fusion en cours pour le barcode ${b}..."

    # On vérifie si le dossier du barcode existe pour éviter les erreurs
    if [ -d "barcode${b}" ]; then
        # On fusionne tous les fichiers du dossier dans un seul fichier final

        cat "barcode${b}/"*.fastq > "merged_fastq/barcode${b}_merged.fastq"
        echo "Fichier barcode${b}_merged.fastq créé avec succès."
    else
        echo "Attention : Le dossier barcode${b} est introuvable."
    fi
done
