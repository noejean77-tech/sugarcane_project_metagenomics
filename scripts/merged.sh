#!/bin/bash

# Folder where the merged files will be stored
mkdir -p merged_fastq

for b in {75..85}; do
    echo "Barcode merging in progress ${b}..."

    # We check if the barcode file exists to avoid errors
    if [ -d "barcode${b}" ]; then
        # We merge all the files in the folder into a single final file

        cat "barcode${b}/"*.fastq > "merged_fastq/barcode${b}_merged.fastq"
        echo "file barcode${b}_merged.fastq created successfully."
done
