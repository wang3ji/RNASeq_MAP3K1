# 📥 Data Acquisition

## Data Source

This project uses the RNA-seq dataset associated with the publication:

> *MAP3K1 regulates female reproductive tract development*  
> Disease Models & Mechanisms (2024) 17(3): dmm050669  
> DOI: https://doi.org/10.1242/dmm.050669

---

## GEO Accession

The RNA-seq dataset is publicly available through the Gene Expression Omnibus (GEO):

- **GEO Series:** GSE237130

GEO link:  
https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE237130

The GEO entry contains:
- experiment description
- sample annotations
- sequencing platform information
- links to Sequence Read Archive (SRA) records

---

## Retrieve SRA Metadata

From the GEO page:

1. Open the **SRA Run Selector**
2. Download the metadata table:
   - `SraRunTable.csv`

This table contains:
- SRA accession IDs
- sample names
- experimental groups
- sequencing metadata

---

## Install SRA Toolkit

The SRA Toolkit is required for downloading sequencing data from NCBI.

Installation instructions:  
https://github.com/ncbi/sra-tools/wiki/Downloads

After installation, verify:

```bash
fasterq-dump --version
