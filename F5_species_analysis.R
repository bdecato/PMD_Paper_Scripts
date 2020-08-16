#!/usr/bin/Rscript
library(tidyverse)
library(hexbin)

### F5B
data <- read.table("~/Desktop/Decato-PMD-revision-analysis/F5B_mean_TPM_long.txt",header=TRUE)

ggplot(data, aes(x=Species, y=log(MeanTPM))) +
  geom_boxplot() +
  facet_wrap(~PMDState,ncol=4, scales="free") +
  theme_bw() +
  theme(legend.position = "right", text = element_text(size=14), axis.text = element_text(size = 10),
        axis.text.x = element_text(angle = 45, hjust = 1), strip.background = element_blank(),
        strip.placement = "outside")

### F5C
data <- read.table("~/Desktop/Decato-PMD-revision-analysis/F5C_data.txt",header=TRUE)

ggplot(data, aes(x=Species, y=Density)) +
  geom_boxplot() +
  facet_wrap(~Context,ncol=4, scales="free") +
  theme_bw() +
  theme(legend.position = "right", text = element_text(size=14), axis.text = element_text(size = 10),
        axis.text.x = element_text(angle = 45, hjust = 1), strip.background = element_blank(),
        strip.placement = "outside")

# Test whether genes with PMDs overlapping mouse but not human have lower gene density in mouse than human.
inout <- data %>% filter(Context == "inout")
wilcox.test(inout$Density~inout$Species, alternative = "greater")

# Test whether genes with PMDs overlapping human but not mouse have lower gene density in human than mouse.
outin <- data %>% filter(Context == "outin")
wilcox.test(outin$Density~outin$Species, alternative = "less")






