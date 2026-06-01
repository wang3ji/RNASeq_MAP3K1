
# first use fastqc to check the quality of our fastq files:
fastqc *.fastq -t 4

# next build an index from our reference fasta file 
kallisto index -i Homo_sapiens.GRCh38.cdna.all.index Homo_sapiens.GRCh38.cdna.all.fa.gz

# now map reads to the indexed reference host transcriptome

kallisto quant -i Homo_sapiens.GRCh38.cdna.all.index -o SAM01 -t 4 --single -l 250 -s 30 SRR25245096.fastq &> SAM01.log
kallisto quant -i Homo_sapiens.GRCh38.cdna.all.index -o SAM02 -t 4 --single -l 250 -s 30 SRR25245097.fastq &> SAM02.log
kallisto quant -i Homo_sapiens.GRCh38.cdna.all.index -o SAM03 -t 4 --single -l 250 -s 30 SRR25245098.fastq &> SAM03.log

kallisto quant -i Homo_sapiens.GRCh38.cdna.all.index -o shRNA04 -t 4 --single -l 250 -s 30 SRR25245099.fastq &> shRNA04.log
kallisto quant -i Homo_sapiens.GRCh38.cdna.all.index -o shRNA05 -t 4 --single -l 250 -s 30 SRR25245100.fastq &> shRNA05.log
kallisto quant -i Homo_sapiens.GRCh38.cdna.all.index -o shRNA06 -t 4 --single -l 250 -s 30 SRR25245101.fastq &> shRNA06.log


# summarize fastqc and kallisto mapping results in a single summary html using MultiQC
multiqc -d . 

echo "Finished"

