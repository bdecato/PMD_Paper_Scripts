#!/usr/bin/Rscript
library(tidyverse)

## Argument 1: the "segmentation_statistics" output file from segmentation_statistics.sh
## Argument 2: the "segmentation_size_dtns" output file from segmentation_statistics.sh
## Argument 3: the "pmd_size_dtns" output file from segmentation_statistics.sh

data <- read.table("~/Desktop/Decato-PMD-revision-analysis/segmentation_statistics", header=TRUE)

#ggplot(data,aes(x=Binsize,fill=Species)) +
#  geom_histogram(alpha=1) +
#  theme_bw() + 
#  theme(legend.position = "right", text = element_text(size=14), axis.text = element_text(size = 10),
#        axis.text.x = element_text(angle = 45, hjust = 1), strip.background = element_blank(),
#        strip.placement = "outside")

# Figure 2A
# Over half (154/267, 57%) of the samples available from TCGA and MethBase were segmented using a bin size
# greater than the previous standard 1kb, allowing a standardized look at PMD summary statistics
# across a significantly greater number of methylomes than previously possible.
ggplot(data, aes(x=Depth, y=Binsize, color = Species)) + 
  geom_point() + 
  xlab("Mean CpG Sequencing Depth") +
  ylab("Selected bin size (bp)") +
  theme_bw() + 
  theme(legend.position = "bottom", text = element_text(size=10), axis.text = element_text(size = 8),
        axis.text.x = element_text(angle = 45, hjust = 1), strip.background = element_blank(),
        strip.placement = "outside")

test <- data %>% gather("Stats", "Value", FractionSegmented:MeanSize)
frac <- data %>% select(Sample, FractionSegmented)
test <- test %>%
  left_join(frac)
options(scipen=10000)

# Figure 2B
ggplot(test, aes(x = reorder(Sample, FractionSegmented), y = Value, fill = Species)) + 
  geom_bar(stat="identity") + 
  coord_flip() + 
  facet_wrap(~Stats,ncol=2,scales="free") + 
  theme_bw() + 
  theme(legend.position = "bottom", text = element_text(size=10), axis.text = element_blank(),
        axis.text.x = element_text(angle = 45, hjust = 1), strip.background = element_blank(),
        strip.placement = "outside")

data<-read.table(args[2])
ordered<-reorder(data$V1,data$V3,median)
pdf("segmentation_size_dtns_with_outliers.pdf",useDingbats=FALSE)
boxplot(data$V3~ordered,las=2,xlab="Sample",ylab="Segment size")
dev.off()

pdf("segmentation_size_dtns_no_outliers.pdf",useDingbats=FALSE)
boxplot(data$V3~ordered,las=2,outline=FALSE,xlab="Sample",ylab="Segment size")
dev.off()

data<-read.table(args[3])
ordered<-reorder(data$V1,data$V3,median)
pdf("pmd_size_dtns_with_outliers.pdf",useDingbats=FALSE)
boxplot(data$V3~ordered,las=2,xlab="Sample",ylab="PMD size")
dev.off()

pdf("pmd_size_dtns_no_outliers.pdf",useDingbats=FALSE)
boxplot(data$V3~ordered,outline=FALSE,las=2,xlab="Sample",ylab="PMD size")
dev.off()

