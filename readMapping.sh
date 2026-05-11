# This script checks the qualitiy of our fastq files and performs an alignment to the human cDNA transcriptome reference with Kallisto.
# To run this 'shell script' you will need to open your terminal and navigate to the directory where this script resides on your computer.
# This should be the same directory where you fastq files and reference fasta file are found.
# Change permissions on your computer so that you can run a shell script by typing: 'chmod 777 readMapping.sh' (without the quotes) at the terminal prompt 
# Then type './readMapping.sh' (without the quotes) at the prompt.  
# This will begin the process of running each line of code in the shell script.

# first use fastqc to check the quality of our fastq files:
fastqc -o fastqc  *.fastq -t 4

# next, we want to build an index from our reference fasta file 
# I get my reference mammalian transcriptome files from here: https://useast.ensembl.org/info/data/ftp/index.html
kallisto index -i Homo_sapiens.GRCh38.cdna.all.index Homo_sapiens.GRCh38.cdna.all.fa.gz

# now map reads to the indexed reference host transcriptome
# use as many 'threads' as your machine will allow in order to speed up the read mapping process.
# note that we're also including the '&>' at the end of each line
# this takes the information that would've been printed to our terminal, and outputs this in a log file that is saved in /data/course_data

# first the healthy subjects (HS)
kallisto quant -i Homo_sapiens.GRCh38.cdna.all.index -o SAM01 -t 8 --single -l 200 -s 20 SRR25245096.fastq &> SAM01.log
kallisto quant -i Homo_sapiens.GRCh38.cdna.all.index -o SAM02 -t 8 --single -l 200 -s 20 SRR25245097.fastq &> SAM02.log
kallisto quant -i Homo_sapiens.GRCh38.cdna.all.index -o SAM03 -t 8 --single -l 200 -s 20 SRR25245098.fastq &> SAM03.log

# then the cutaneous leishmaniasis (CL) patients
kallisto quant -i Homo_sapiens.GRCh38.cdna.all.index -o shRNA08 -t 8 --single -l 200 -s 20 SRR25245099.fastq &> shRNA04.log
kallisto quant -i Homo_sapiens.GRCh38.cdna.all.index -o shRNA05 -t 8 --single -l 200 -s 20 SRR25245100.fastq &> shRNA05.log
kallisto quant -i Homo_sapiens.GRCh38.cdna.all.index -o shRNA06 -t 8 --single -l 200 -s 20 SRR25245101.fastq &> shRNA06.log


# summarize fastqc and kallisto mapping results in a single summary html using MultiQC
multiqc -d . 

echo "Finished"

