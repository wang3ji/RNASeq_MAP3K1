# 🧬 kallisto RNA-seq Workflow

## Workflow Overview

RNA-seq quantification workflow:

```text
FASTQ quality control
→ trimming / filtering
→ build transcriptome index
→ pseudoalignment and quantification with kallisto
→ gene-level summarization with tximport
→ differential expression analysis
```

This project uses kallisto for transcript-level abundance estimation.

Advantages of kallisto:

* fast pseudoalignment
* low computational requirements
* accurate transcript quantification
* suitable for large-scale RNA-seq workflows

Reference:
https://pachterlab.github.io/kallisto/

---

# 🔬 Quality Control with FastQC

FastQC is a command-line tool used to assess sequencing quality before downstream analysis.

## Basic Syntax

```bash
fastqc [options] seqfile1 seqfile2 ...
```

## Common Arguments

| Argument           | Description         |
| ------------------ | ------------------- |
| `-o` / `--outdir`  | Output directory    |
| `-t` / `--threads` | Number of threads   |
| `-f`               | Specify file format |

## Example Command

```bash
fastqc *.fastq -t 8
```

---

# 📊 FastQC Results

For this dataset, FastQC reported two warning/fail categories:

* Per base sequence content
* Sequence duplication levels

---

## Per Base Sequence Content

This is a common and expected artifact in RNA-seq datasets.

RNA-seq libraries often use random hexamer priming during cDNA synthesis. In practice, these primers are not perfectly random and can introduce sequence bias in the first 10–15 bases of reads.

This produces:

* jagged sequence-content curves
* non-parallel nucleotide composition lines

This technical artifact generally does not affect:

* read alignment
* transcript quantification
* downstream differential expression analysis

Therefore, this warning is typically considered acceptable for RNA-seq data.

---

## Sequence Duplication Levels

FastQC indicated elevated duplication levels, with approximately 30% unique reads.

This pattern is common in high-depth RNA-seq datasets because highly expressed transcripts can appear many times.

Examples include:

* housekeeping genes
* ribosomal RNA contamination
* highly abundant transcripts

For RNA-seq, moderate-to-high duplication levels are often biologically expected.

In contrast:

* high duplication would be a major concern in whole-genome sequencing (WGS)

---

# ✅ QC Summary

Overall, the sequencing data passed quality control and were suitable for downstream transcript quantification.

Observed warnings were consistent with expected RNA-seq library characteristics.

---

# ✂️ Read Trimming with fastp

Adapter contamination and low-quality bases can negatively affect pseudoalignment and quantification accuracy.

This project uses fastp for trimming because it:

* automatically detects adapters
* performs quality filtering
* generates QC reports
* is computationally efficient

Alternative tools include:

* Trimmomatic
* Cutadapt

Reference:
https://github.com/OpenGene/fastp

---

# ▶️ fastp Example Command

## Paired-end example

```bash
fastp \
    -i SRR25245096_1.fastq.gz \
    -I SRR25245096_2.fastq.gz \
    -o trimmed_1.fastq.gz \
    -O trimmed_2.fastq.gz \
    --detect_adapter_for_pe \
    --html report.html \
    --json report.json \
    --thread 8 \
    --qualified_quality_phred 20 \
    --length_required 36 \
    --correction \
    --overrepresentation_analysis
```

## Key Parameters

| Parameter                      | Description                     |
| ------------------------------ | ------------------------------- |
| `--detect_adapter_for_pe`      | Auto-detect paired-end adapters |
| `--qualified_quality_phred 20` | Quality threshold               |
| `--length_required 36`         | Minimum read length             |
| `--correction`                 | Overlap-based error correction  |
| `--html`                       | Generate HTML report            |
| `--json`                       | Generate JSON report            |

---

# 📋 MultiQC

MultiQC aggregates outputs from multiple bioinformatics tools into a single interactive report.

Supported tools include:

* FastQC
* fastp
* STAR
* Salmon
* featureCounts
* Cutadapt

Reference:
https://multiqc.info/

## Run MultiQC

```bash
multiqc .
```

This command scans subdirectories for recognized logs and generates:

```text
multiqc_report.html
```

---

# 🧬 kallisto Quantification

## 1. Build Transcriptome Index

Build the kallisto index once per reference transcriptome.

## Example

```bash
kallisto index \
    -i transcripts.idx \
    transcripts.fa
```

---

## Reference Transcriptome

This project uses the Ensembl human transcriptome:

```text
Homo_sapiens.GRCh38.cdna.all.fa.gz
```

Download from Ensembl:

https://useast.ensembl.org/info/data/ftp/index.html

---

## Build Index

```bash
kallisto index \
    -i Homo_sapiens.GRCh38.cdna.all.index \
    Homo_sapiens.GRCh38.cdna.all.fa.gz
```

---

# ▶️ Quantify Samples

## Paired-end RNA-seq

```bash
kallisto quant \
    -i transcripts.idx \
    -o sample_kallisto \
    -b 100 \
    sample1_R1.fastq.gz \
    sample1_R2.fastq.gz
```

---

## Single-end RNA-seq

```bash
kallisto quant \
    -i transcripts.idx \
    -o sample_kallisto \
    --single \
    -l 200 \
    -s 20 \
    sample1.fastq.gz
```

---

# 🧪 Quantification Command Used in This Project

```bash
kallisto quant \
    -i Homo_sapiens.GRCh38.cdna.all.index \
    -o SAM01 \
    -t 8  \
    --single \
    -l 200 \
    -s 20 \
    SRR25245096.fastq \
    &> SAM01.log
```

## Parameters

| Parameter  | Description                        |
| ---------- | ---------------------------------- |
| `-t 8`     | Number of threads                  |
| `--single` | Single-end sequencing              |
| `-l 200`   | Estimated fragment length          |
| `-s 20`    | Fragment length standard deviation |

---

# 🔁 Batch Quantification

For multiple samples, create a shell script and execute it in the terminal.

Example workflow:

```bash
for file in *.fastq
do
    sample=$(basename $file .fastq)

    kallisto quant \
        -i Homo_sapiens.GRCh38.cdna.all.index \
        -o ${sample} \
        -t 8 \
        --single \
        -l 200 \
        -s 20 \
        ${file}

done
```

---

# 📂 kallisto Output

Each sample directory contains:

```text
SAM01/
├── abundance.tsv
├── abundance.h5
└── run_info.json
```

---

# 🔗 Next Step

After transcript quantification:

1. import transcript abundances with tximport
2. summarize transcript counts to gene level
3. perform differential expression analysis using edgeR and limma-voom






