#!/bin/bash

# number of threads
THREADS=8

# output directories
SRA_DIR="sra"
FASTQ_DIR="fastq"

mkdir -p $SRA_DIR
mkdir -p $FASTQ_DIR

# list of SRR IDs
SRR_LIST=(
SRR25245096
SRR25245097
SRR25245098
SRR25245099
SRR25245100
SRR25245101
)

# loop through each SRR
for SRR in "${SRR_LIST[@]}"
do
    echo "Processing $SRR ..."

    # download .sra file
    prefetch $SRR -O $SRA_DIR

    # convert to FASTQ
    fasterq-dump $SRA_DIR/$SRR \
        --split-files \
        -O $FASTQ_DIR \
        -e $THREADS

    # compress to save space
    gzip $FASTQ_DIR/${SRR}_*.fastq

    echo "$SRR done"
done

echo "All downloads completed!"
