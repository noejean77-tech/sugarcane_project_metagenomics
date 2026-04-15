#!/bin/bash

### Name of job 
#SBATCH --job-name=Blast_Viral

### number of cpus
#SBATCH --cpus-per-task=4

### Set the partition to use
#SBATCH --partition=normal  

###Specify the node on which the job should run
#SBATCH --nodelist=node06

### out logs 
#SBATCH --output=/scratch/noe/sugarcane_projet/logs/blast_viral_%j.out
#SBATCH --error=/scratch/noe/sugarcane_projet/logs/blast_viral_%j.err

# 1. download of  module BLAST
module load bioinfo-shared
module load blast

# Let's define the varaibles

QUERY_DIR="/scratch/noe/sugarcane_projet/results/6_kraken_contigs_polishing"
DB_VIRAL="/scratch/noe/sugarcane_projet/banks/db_viruses"
OUT_DIR="/scratch/noe/sugarcane_projet/results/7_blast_contigs_polishing"

mkdir -p "$OUT_DIR"

# 3. BLAST launch for each sample
for fasta in "$QUERY_DIR"/*_headers_fixed.fasta; do
    
    name=$(basename "$fasta" _headers_fixed.fasta)
    echo "BLAST analysis for : $name"

    blastn -query "$fasta" \
           -db "$DB_VIRAL" \
           -num_threads $SLURM_CPUS_PER_TASK \
           -outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore stitle" \
           -max_target_seqs 5 \
           -evalue 1e-5 \
           -out "${OUT_DIR}/${name}_viral.txt"

done