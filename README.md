# RNA-seq analysis of MAP3K1 overexpression vs. knockdown in human keratinocytes

A bulk RNA-seq workflow from raw reads to differentially expressed genes. It compares MAP3K1-overexpressing and MAP3K1-knockdown HaCaT keratinocytes, using public data from GEO [GSE237130](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE237130).

**Tools:** SRA Toolkit · FastQC · MultiQC · kallisto · tximport · edgeR (TMM normalization) · limma-voom

## Biological question

MAP3K1 is a MAPK kinase kinase that controls epithelial migration and tissue closure during development. This analysis asks which genes and pathways change in keratinocytes when MAP3K1 is turned up or turned down.

## Data

| Sample | SRA run | Group | Perturbation |
|---|---|---|---|
| SAM01 | SRR25245096 | over_expressed | CRISPR activation (dCas9-SAM) of MAP3K1 |
| SAM02 | SRR25245097 | over_expressed | CRISPR activation (dCas9-SAM) of MAP3K1 |
| SAM03 | SRR25245098 | over_expressed | CRISPR activation (dCas9-SAM) of MAP3K1 |
| shRNA04 | SRR25245099 | down_expressed | shRNA knockdown of MAP3K1 |
| shRNA05 | SRR25245100 | down_expressed | shRNA knockdown of MAP3K1 |
| shRNA06 | SRR25245101 | down_expressed | shRNA knockdown of MAP3K1 |

The reads are single-end, about 84 bp, from an Illumina NextSeq 550, with about 20–23 million reads per sample. The full metadata is in `SraRunTable.csv`, and the sample-to-group table the R scripts read is `studydesign.txt`.

Source publication: *MAP3K1 regulates female reproductive tract development*, Disease Models & Mechanisms (2024) 17(3): dmm050669, [doi:10.1242/dmm.050669](https://doi.org/10.1242/dmm.050669).

## Workflow

```text
download_sra.sh            SRA → FASTQ (prefetch, fasterq-dump)
readMapping.sh             FastQC → kallisto index + quant (single-end, -l 200 -s 20) → MultiQC
ReadKallistoCounts1.R      tximport: transcript abundances → gene-level counts (EnsDb.Hsapiens.v86)
FilterAndNormalization2.R  edgeR: filterByExpr, TMM normalization, log2 CPM violin plots
DE-limma-voom3.R           limma-voom: over_expressed vs down_expressed, BH-adjusted p-values, volcano plot, DEG table
```

The two notes `SARTOOLKit.md` (data download) and `kallisto.md` (QC, trimming and quantification) explain each step and its parameters. `kallisto.md` also explains how to read the FastQC warnings on this dataset (per-base sequence content and duplication levels), which are normal for RNA-seq.

## Statistical design

- Lowly expressed genes are removed with `edgeR::filterByExpr` using the group labels, and libraries are TMM-normalized.
- `voom` turns counts into log2 CPM with precision weights, and `limma` fits a no-intercept model `~0 + group`.
- The contrast is `over_expressed - down_expressed`. Genes are called differentially expressed at BH-adjusted p < 0.01 and |log2 fold change| ≥ 2.

## How to run

Requirements: [SRA Toolkit](https://github.com/ncbi/sra-tools/wiki/Downloads), FastQC, kallisto, MultiQC, and R with `tidyverse`, `tximport`, `ensembldb`, `EnsDb.Hsapiens.v86`, `edgeR`, `limma`, `cowplot`, `gt`, `DT` and `plotly`.

1. Download the reads:
   ```bash
   bash download_sra.sh
   ```
2. Download the Ensembl human cDNA reference `Homo_sapiens.GRCh38.cdna.all.fa.gz` from [Ensembl](https://useast.ensembl.org/info/data/ftp/index.html). Put it in the same folder as the FASTQ files and `readMapping.sh`, then run:
   ```bash
   bash readMapping.sh
   ```
   This writes one kallisto folder per sample (`SAM01/` … `shRNA06/`) and a MultiQC report.
3. In R, from the folder that holds the kallisto outputs and `studydesign.txt`, run the scripts in order in one session. Each script uses objects made by the one before it.
   ```r
   source("ReadKallistoCounts1.R")
   source("FilterAndNormalization2.R")
   source("DE-limma-voom3.R")
   ```

## Next steps

- Gene set enrichment (GSEA on MSigDB Hallmark and KEGG gene sets) of the limma ranking
- An edgeR quasi-likelihood test to cross-check the limma-voom results
- A single wrapper script and saved figures and tables in a `results/` folder

## License

Apache 2.0
