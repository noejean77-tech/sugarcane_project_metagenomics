#!/bin/bash

# Source and destination folder

SOURCE_DIR="/scratch/noe/sugarcane_projet/raw_data/Metagenomics/sugarecane_demux"
Dest_dir="/scratch/noe/sugarcane_projet/raw_data"

# Create the destination folder for each barcode.
mkdir -p "$Dest_dir"

# Loop on the barcodes
for b in {75..85}; do
    # Create the specific folder for the barcode
    TARGET_DIR="$Dest_dir/barcode${b}"
    mkdir -p "$TARGET_DIR"

    echo "Barcode processing ${b}..."
# Let's find all the FastQ files for the barcodes in the source folder and then copy those files into 
    # in the destination folder in the corresponding barcodes 
    find "$SOURCE_DIR" -type f -name "*barcode${b}*.fastq" | while read -r file; do
        # We extract the name of the run (ex: AQN321)
      
        BASE_NAME=$(basename "$file")

        # Copying and renaming the file 
        cp "$file" "$TARGET_DIR/${BASE_NAME}"
    done
done
