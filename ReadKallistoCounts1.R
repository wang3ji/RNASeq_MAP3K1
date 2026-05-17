library(tidyverse) 
library(tximport) 
library(ensembldb) 
library(EnsDb.Hsapiens.v86) 
targets <- read_tsv("studydesign.txt")

files <- file.path(targets$sample, "abundance.tsv") 
names(files) <- targets$sample
tx2gene <- transcripts(
  EnsDb.Hsapiens.v86,
  columns = c("tx_id", "gene_id")
) %>%
  as_tibble() %>%
  dplyr::select(tx_id, gene_id) %>%
  dplyr::rename(target_id = tx_id)

txi_gene <- tximport(
  files,
  type = "kallisto",
  tx2gene = tx2gene,
  txOut = FALSE,
  countsFromAbundance = "no",
  ignoreTxVersion = TRUE
)
