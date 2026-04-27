#!/bin/bash

### Name of job 
#SBATCH --job-name=Diamond_blastx

### number of cpus
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G

### Set the partition to use
#SBATCH --partition=normal  

###Specify the node on which the job should run
#SBATCH --nodelist=node06

### out logs 
#SBATCH --output=/scratch/noe/sugarcane_projet/logs/Diamond_blastx_%j.out
#SBATCH --error=/scratch/noe/sugarcane_projet/logs/Diamond_blastx_%j.err

# download of  module BLAST
module load bioinfo-shared
module load blast
module load diamond/2.1.9

# Let's define the varaibles

QUERY_DIR="/scratch/noe/sugarcane_projet/results/6_kraken_contigs_polishing"
DB="/projects/diamond_databse/uniref90.dmnd"
OUT_DIR="/scratch/noe/sugarcane_projet/results/8_blast_diamond_uniref90"

mkdir -p "$OUT_DIR"

#  BLAST launch for each sample
for fasta in "$QUERY_DIR"/*_headers_fixed.fasta; do
    
    name=$(basename "$fasta" _headers_fixed.fasta)
    echo "BLAST analysis for : $name"

     diamond blastx --db "$DB" \
           --query "$fasta" \
           --threads $SLURM_CPUS_PER_TASK \
           --outfmt 6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore stitle \
           --max-target-seqs 1 \
           --out "${OUT_DIR}/${name}_blast_diamond_uniref90.tsv"

done
