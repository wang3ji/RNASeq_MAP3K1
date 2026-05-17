library(tidyverse)
library(limma)
library(edgeR)
library(gt)
library(DT)
library(plotly)

group <- factor(targets$group,
                levels = c("down_expressed", "over_expressed"))

design <- model.matrix(~0 + group)
colnames(design) <- c("down_expressed", "over_expressed")


v.DEGList.filtered.norm <- voom(myDGEList.filtered.norm, design, plot = FALSE)
fit <- lmFit(v.DEGList.filtered.norm, design)
contrast.matrix <- makeContrasts(
  over_vs_down = over_expressed - down_expressed,
  levels = design
)

fits <- contrasts.fit(fit, contrast.matrix)
ebFit <- eBayes(fits)
myTopHits <- topTable(
  ebFit,
  adjust.method = "BH",
  coef = 1,
  lfc = 2,
  number = Inf,
  sort.by = "logFC"
)
myTopHits.df <- myTopHits %>%
  as_tibble(rownames = "geneID")
myTopHits.df <- myTopHits.df %>%
  filter(!is.na(adj.P.Val), adj.P.Val > 0)

myTopHits.df$significant <- myTopHits.df$adj.P.Val < 0.05 & abs(myTopHits.df$logFC) > 1

vplot <- ggplot(myTopHits.df) +
  aes(y=-log10(adj.P.Val), x=logFC, color = significant,text = paste("Symbol:", geneID)) +
  geom_point(size=2) +
  geom_hline(yintercept = -log10(0.01), linetype="longdash", colour="grey", linewidth=1) +
  geom_vline(xintercept = 1, linetype="longdash", colour="#BE684D", linewidth=1) +
  geom_vline(xintercept = -1, linetype="longdash", colour="#2C467A", linewidth=1) +
  #annotate("rect", xmin = 1, xmax = 12, ymin = -log10(0.01), ymax = 7.5, alpha=.2, fill="#BE684D") +
  #annotate("rect", xmin = -1, xmax = -12, ymin = -log10(0.01), ymax = 7.5, alpha=.2, fill="#2C467A") +
  labs(title="Volcano plot",
       subtitle = "Cutaneous leishmaniasis",
       caption=paste0("produced on ", Sys.time())) +
  theme_bw()

ggplotly(vplot)

myTopHits <- topTable(
  ebFit,
  adjust.method = "BH",
  coef = 1,
  p.value = 0.01,
  lfc = 2,
  number = Inf
)
diffGenes.df <- myTopHits %>%
  as_tibble(rownames = "geneID")

datatable(diffGenes.df,
          extensions = c('KeyTable', "FixedHeader"),
          caption = 'Table 1: DEGs in cutaneous leishmaniasis',
          options = list(keys = TRUE, searchHighlight = TRUE, pageLength = 10, lengthMenu = c("10", "25", "50", "100"))) %>%
  formatRound(columns=c(2:11), digits=2)

