#!/usr/bin/Rscript
library(ggplot2)
library(tidyverse)

## Argument 1: the "Out_In_PMD_Statistics" output file from methylation_in_out.sh
data <- read.table("~/Desktop/Decato-PMD-revision-analysis/Out_In_PMD_Statistics", header=TRUE)
data$CellType <- as.character(data$CellType)

cultured_primary_cancers <- data %>% filter(PMDs == "yes" & InOutPMD == "pmd" & HealthyCancer == "Cancer")

# HCT116 mislabeled as bladder, it's colorectal cancer
cultured_primary_cancers <- cultured_primary_cancers %>%
  mutate(CellType = ifelse(Sample=="Blattler-2014_Human_HCT116","Colon",CellType))

# Figure 3E.
ggplot(cultured_primary_cancers, aes(x=CellType,y=MethylationLevel,fill=PrimaryCultured)) +
  geom_boxplot() +
  theme_bw() +
  theme(legend.position = "right", text = element_text(size=14), axis.text = element_text(size = 10),
        axis.text.x = element_text(angle = 45, hjust = 1), strip.background = element_blank(),
        strip.placement = "outside")

# For tissues with cultured and primary data, Wilcox test on methylation levels.
cultured_primary_cancers %>%
  filter(CellType == "Brain" | CellType == "Breast" | CellType == "Colon" | CellType == "Lung") %>%
  group_by(CellType) %>%
  do(w = wilcox.test(MethylationLevel~PrimaryCultured, alternative = "less", data=., paired=FALSE)) %>%
  summarise(CellType, Wilcox = w$p.value)

# CellType    Wilcox
# 1 Brain    1.28e-222
# 2 Breast   0.       
# 3 Colon    6.15e- 23
# 4 Lung     0.     


