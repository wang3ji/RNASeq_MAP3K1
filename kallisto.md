# Kallisto workflow
## workflow
Check the quality of the fastq files -> build an index from the reference fasta file -> map the reads to the indexed reference host transcriptome

## use fastqc to check the quality of fastq files
**fastqc is a command-line tool**

**Basic Syntax:** fastqc [options] seqfiles seqfile2 ...

**Key Arguments:**

-o / --outdir: Specifies the directory for output files.

-t / --threads: Enables multi-threading to speed up processing for multiple files.

-f: Forces a specific file format(e.g., fastq, bam,sam)

``` bash
fastqc *.fastq -t 8
```
**fastqc results**

For my data, there are two fails in Per base sequence content and Sequence Duplication Levels.

**Per base sequence content** 

It is the "False Alarm" when doing **RNA-Seq**. RNA-seq libraries often use "random hexamer" priming. In reality, these primers are not perfectly random; they have a slight preference for certain sequences. You will see jagged, non-parallel lines in the first 10–15 bases of the read.  This is a known technical artifact that does not usually affect alignment or gene expression quantification. 

**Sequence Duplication Levels**

Only about 30% of my reads are unique (appearing only once), which is why FastQC is flagging this as a FAIL. This profile is actually quite common for high-depth RNA-Seq. The sequences appearing >1k times are likely highly abundant housekeeping genes (like Actin or GAPDH) or ribosomal RNA (rRNA) if the depletion step wasn't perfect. If this is WGS (Whole Genome Sequencing): This is a major red flag.

**Overall, all the data I downloaded here pass the quality control** 

### fastp to trim the data

Trimming can be helpful, but only for certain types of "fails." It is excellent for fixing adapter contamination and low-quality ends.

To remove adapter contamination, we can use specialized command-line tools, like fastp, Trimmomatic, or Cutadapt. Modern pipelines often prefer fastp because it is 2–5 times faster and automatically detects common Illumina adapter sequences.

**Command**
```bash
fastp -i SRR25245096_1.fastq.gz -I SRR25245096_2.fastq.gz \  # -i Input read 1 (forward reads) -I Input read 2 (reverse reads)
      -o trimmed_1.fastq.gz -O trimmed_2.fastq.gz \ # -o Output trimmed read 1, -O Output trimmed read 2
      --detect_adapter_for_pe \ # Auto-detect adapters for paired-end data
      --html report.html \  # Generate an HTML QC report
      --json report.json \
      --thread 4 \
      --qualified_quality_phred 20 \   # Stricter quality threshold
      --length_required 36 \           # Drop reads shorter than 36bp
      --correction \                   # PE overlap error correction
      --overrepresentation_analysis    # Detect overrepresented sequences
```

