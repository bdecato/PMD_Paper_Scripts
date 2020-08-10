#!/usr/bin/Rscript
library(ggplot2)
library(hexbin)

data <- read.table("~/Desktop/Decato-PMD-revision-analysis/repliseq_summary",header=TRUE)

# Too many bins to effectively visualize this relationship.
ggplot(data, aes(x=Methylation_Level, y=Repliseq_Signal)) +
  stat_binhex() +
  scale_fill_viridis_c() +
  facet_wrap(~Sample, ncol=2,scales="free") +
  stat_smooth(method=lm) +
  theme_bw() +
  theme(legend.position = "right", text = element_text(size=14), axis.text = element_text(size = 10),
        axis.text.x = element_text(angle = 45, hjust = 1), strip.background = element_blank(),
        strip.placement = "outside")

data <- data %>%
  mutate(Bin = ifelse(Methylation_Level<0.33, "Low", ifelse(Methylation_Level<0.67, "Med","High"))) %>%
  mutate(MethylationPercent = Methylation_Level*100)

data$Bin <- factor(data$Bin, levels=c("High","Med","Low"))

ggplot(data, aes(x=Sample, y=Repliseq_Signal,fill=Bin)) +
  geom_boxplot() +
  theme_bw() +
  theme(legend.position = "right", text = element_text(size=14), axis.text = element_text(size = 10),
        axis.text.x = element_text(angle = 45, hjust = 1), strip.background = element_blank(),
        strip.placement = "outside")

# R^2=0.2757, p<2e-16, 1% reduction in methylation corresponds to 0.5199 loss in repliseq signal
imr90 <- data %>% filter(Sample == "Lister-ESC-2009_Human_IMR90")
summary(lm(imr90$Repliseq_Signal~imr90$MethylationPercent))

# R^2=0.3314, p<2e-16, 1% reduction in methylation corresponds to 0.3815 loss in repliseq signal
mcf7 <- data %>% filter(Sample == "Menafra-2014_Human_MCF7")
summary(lm(mcf7$Repliseq_Signal~mcf7$MethylationPercent))

# R^2=0.2612, p<2e-16, 1% reduction in methylation corresponds to 0.4263 loss in repliseq signal
gm12878 <- data %>% filter(Sample == "Schlesinger-2013_Human_GM12878")
summary(lm(gm12878$Repliseq_Signal~gm12878$MethylationPercent))

# R^2=0.3018, p<2e-16, 1% reduction in methylation corresponds to 0.4197 loss in repliseq signal
hepg2<- data %>% filter(Sample == "Ziller-2013-Human_HepG2")
summary(lm(hepg2$Repliseq_Signal~hepg2$MethylationPercent))

######
# Escapee status and Repli-seq signal
######
data$Region <- factor(data$Region, levels=c("inPMD","escapeePMD","outPMD"))

ggplot(data, aes(x=Sample, y=Repliseq_Signal,fill=Region)) +
  geom_violin() +
  theme_bw() +
  theme(legend.position = "right", text = element_text(size=14), axis.text = element_text(size = 10),
        axis.text.x = element_text(angle = 45, hjust = 1), strip.background = element_blank(),
        strip.placement = "outside")

#### TPM figures
tpm <- read.table("~/Desktop/Decato-PMD-revision-analysis/TPM_info", header=TRUE)
tpm$Region <- factor(tpm$Region, levels=c("inPMDs","escapees","outPMDs"))

# SA: Healthy small airway, BE: Healthy bronchial epithelium
tpm <- tpm %>%
  separate(Sample, sep = "_", into = c("PMD_Source","tpm2","RNA","Barcode","Replicate"), extra = "warn") %>%
  mutate(CancerHealthy = ifelse(RNA == "SA" | RNA == "BE", "Healthy","Cancer"))

ggplot(tpm, aes(x=PMD_Source, y=log(TPM),fill=CancerHealthy)) +
  geom_boxplot(outlier.shape=NA) +
  coord_cartesian(ylim=c(-5.5,8))+
  facet_wrap(~Region, ncol=6) +
  theme_bw() +
  theme(legend.position = "bottom", text = element_text(size=14), axis.text = element_text(size = 10),
        axis.text.x = element_text(angle = 45, hjust = 1), strip.background = element_blank(),
        strip.placement = "outside")

escapees_outPMDs <- tpm %>% 
  filter(Region == "escapees" | Region == "outPMDs")
wilcox.test(escapees_outPMDs$TPM~escapees_outPMDs$Region, paired=FALSE) # p<0.1027, n.s.

escapees_inPMDs <- tpm %>%
  filter(Region == "escapees" | Region == "inPMDs")
wilcox.test(escapees_inPMDs$TPM~escapees_inPMDs$Region) # p<2.2e-16

tpm %>%
  filter(Region == "inPMDs") %>%
  group_by(PMD_Source) %>%
  do(w = wilcox.test(TPM~CancerHealthy, alternative = "less", data=., paired=FALSE)) %>%
  summarise(PMD_Source, Wilcox = w$p.value)

# PMD_Source    Wilcox
# 1650Lung      3.21e-88
# 441NSCLC      3.09e-84
# Calu1Lung     2.66e-37
# M3Lung        2.25e-81

tpm %>%
  filter(Region == "escapees") %>%
  group_by(PMD_Source) %>%
  do(w = wilcox.test(TPM~CancerHealthy, alternative = "less", data=., paired=FALSE)) %>%
  summarise(PMD_Source, Wilcox = w$p.value)

# PMD_Source    Wilcox
# 1650Lung      0.176    
# 441NSCLC      0.494    
# Calu1Lung     0.0000863
# M3Lung        0.704   

tpm %>%
  filter(Region == "outPMDs") %>%
  group_by(PMD_Source) %>%
  do(w = wilcox.test(TPM~CancerHealthy, alternative = "less", data=., paired=FALSE)) %>%
  summarise(PMD_Source, Wilcox = w$p.value)

# PMD_Source   Wilcox
# 1650Lung   1.04e-70
# 441NSCLC   2.54e-19
# Calu1Lung  6.32e- 9
# M3Lung     7.46e- 1


