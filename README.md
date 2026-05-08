# RNASeq_MAP3K1
This project presents a fully reproducible RNA-seq analysis pipeline to identify genes and pathways regulated by MAP3K1 perturbation in human keratinocytes. Using dataset GSE237130, the workflow spans from raw sequencing reads to differential expression and pathway enrichment analysis.
# Biological Background
MAP3K1 is a key regulator of MAPK signaling and plays an important role in epithelial biology and developmental processes. Dysregulation of MAP3K1 has been linked to defects in tissue closure and altered EGFR signaling.
This project aims to:

1. Identify differentially expressed genes upon MAP3K1 perturbation
2. Characterize affected biological pathways
3. Reproduce and extend findings from the original study

# Dataset
**Source:** GEO (GSE237130)

**Samples:** 6 total
3 × overexpressed (SAM01–03)
3 × knockdown (shRNA04–06)

**Sequencing:** Single-end RNA-seq

# Workflow
1. Quality Control
FastQC for raw read quality assessment
Adapter/content issues identified and addressed
2. Preprocessing
Read trimming (if applicable)
3. Quantification
Pseudoalignment using kallisto
Transcript-level quantification
4. Gene-Level Summarization
Import using tximport
Mapping transcripts to genes
5. Differential Expression Analysis
edgeR (negative binomial model)
limma-voom (linear modeling with precision weights)
6. Filtering & Normalization
Low-expression filtering (CPM-based)
TMM normalization
7. Exploratory Data Analysis
PCA / MDS plots
Sample clustering
8. Functional Enrichment
Gene Set Enrichment Analysis (GSEA)
Hallmark and curated pathways

# Key Results
Identification of differentially expressed genes (FDR < 0.05)
Strong enrichment of MAPK and EGFR-related pathways
Consistent results between edgeR and limma pipelines
Clear separation between experimental groups in PCA

📂 Repository Structure
rna-seq-map3k1/
├── data/              # metadata and processed data (no raw FASTQ)
├── metadata/          # sample annotations
├── scripts/           # analysis scripts (step-by-step)
├── results/           # outputs (DE tables, plots)
├── notebooks/         # exploratory analysis (RMarkdown)
├── README.md
└── environment.yml / renv.lock

# 🚀 How to Run
1. Clone repository
git clone https://github.com/your-username/rna-seq-map3k1.git
cd rna-seq-map3k1
2. Set up environment

Using R:

install.packages("renv")
renv::restore()
3. Download data
fasterq-dump SRR25245096

(Repeat for all samples)

4. Run pipeline

Execute scripts in order:

scripts/01_qc_fastqc.sh
scripts/02_trim.sh
scripts/03_kallisto.sh
scripts/04_tximport.R
scripts/05_edgeR_DE.R
scripts/06_limma_voom.R
scripts/07_GSEA.R
