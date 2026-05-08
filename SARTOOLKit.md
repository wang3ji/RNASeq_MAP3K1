# 📥 Data Acquisition

## Data Source

This project uses the RNA-seq dataset associated with the publication:

> *MAP3K1 regulates female reproductive tract development*
> Disease Models & Mechanisms (2024) 17(3): dmm050669
> DOI: https://doi.org/10.1242/dmm.050669

---

## GEO Accession

The RNA-seq dataset is publicly available through the Gene Expression Omnibus (GEO):

* **GEO Series:** GSE237130

GEO link:
https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE237130

The GEO entry contains:

* experiment description
* sample annotations
* sequencing platform information
* links to Sequence Read Archive (SRA) records

---

## Retrieve SRA Metadata

From the GEO page:

1. Open the **SRA Run Selector**
2. Download the metadata table:

   * `SraRunTable.csv`

This table contains:

* SRA accession IDs
* sample names
* experimental groups
* sequencing metadata

---

## Install SRA Toolkit

The SRA Toolkit is required for downloading sequencing data from NCBI.

Installation instructions:
https://github.com/ncbi/sra-tools/wiki/Downloads

Verify installation:

```bash
fasterq-dump --version
```

---

## Download SRA Data

Example download:

```bash
prefetch SRR25245096
```

---

## Convert SRA to FASTQ

```bash
fasterq-dump SRR25245096
```

This generates:

```text
SRR25245096.fastq
```

---

# 🔁 Batch Download Workflow

## Create a shell script

```bash
nano download_sra.sh
```

Example script:

```bash
#!/bin/bash

ACCESSIONS=(
SRR25245096
SRR25245097
SRR25245098
SRR25245099
SRR25245100
SRR25245101
)

for SRR in "${ACCESSIONS[@]}"
do
    echo "Processing ${SRR} ..."

    prefetch ${SRR}
    fasterq-dump ${SRR} -e 8
done

echo "Download complete."
```

---

## Make script executable

```bash
chmod +x download_sra.sh
```

---

## Run script

```bash
./download_sra.sh
```

---

# 🧹 Alternative: Use a Text File (Recommended)

Store all SRA accession IDs in a text file:

```bash
nano srr_ids.txt
```

Contents of `srr_ids.txt`:

```text
SRR25245096
SRR25245097
SRR25245098
SRR25245099
SRR25245100
SRR25245101
```

Run download pipeline:

```bash
while read SRR
do
    echo "Processing ${SRR} ..."

    prefetch ${SRR}
    fasterq-dump ${SRR} -e 8
done < srr_ids.txt
```

---

## Expected Directory Structure

```text
data/raw/
├── SRR25245096.fastq
├── SRR25245097.fastq
├── SRR25245098.fastq
├── SRR25245099.fastq
├── SRR25245100.fastq
└── SRR25245101.fastq
```
