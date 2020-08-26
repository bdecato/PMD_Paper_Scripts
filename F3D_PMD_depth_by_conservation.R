#!/usr/bin/Rscript
library(tidyverse)
library(hexbin)

###########################################
# Observed/expected ratio statistics: gene-level depletion
###########################################

data <- read.table("~/Desktop/Decato-PMD-revision-analysis/OE_statistics/human_genes_inside_pmds_OE",header=TRUE)

ggplot(data,aes(x=log(OE))) + 
  geom_density()

summary(data$OE) # There is a median OE ratio of 0.67 across all PMD containing samples.

data <- data %>%
  filter(ExpOverlap>0)

data <- data %>%
  rowwise() %>%
  mutate(BinomTestP = (binom.test(ObsOverlap, NumGenes, ExpOverlap/NumGenes))$p.value) %>%
  mutate(adjP = p.adjust(BinomTestP)) %>% mutate(sig = ifelse(adjP < 0.05,"Yes","No")) 

table(data$sig)

###########################################
# Retrotransposon family-level depletion
###########################################

# F3A suppTable build from output of repeats_in_pmds.sh:
human <- read.table("~/Desktop/Decato-PMD-revision-analysis/F3A_OE_data/Roadmap-2015_Human_Placenta.pmd_PMD_family_OE")
human <- human %>%
  mutate(Species = "Human")

mouse <- read.table("~/Desktop/Decato-PMD-revision-analysis/F3A_OE_data/Schroeder-2015-Mouse_Placenta.pmd_PMD_family_OE")
mouse <- mouse %>%
  mutate(Species = "Mouse")

sm <- read.table("~/Desktop/Decato-PMD-revision-analysis/F3A_OE_data/Schroeder-2015-SquirrelMonkey_Placenta.pmd_PMD_family_OE")
sm <- sm %>%
  mutate(Species = "Squirrel Monkey")

cow <- read.table("~/Desktop/Decato-PMD-revision-analysis/F3A_OE_data/Schroeder-2015-Cow_Placenta.pmd_PMD_family_OE")
cow <- cow %>%
  mutate(Species = "Cow")

dog <- read.table("~/Desktop/Decato-PMD-revision-analysis/F3A_OE_data/Schroeder-2015-Dog_Placenta.pmd_PMD_family_OE")
dog <- dog %>%
  mutate(Species = "Dog")

horse <- read.table("~/Desktop/Decato-PMD-revision-analysis/F3A_OE_data/Schroeder-2015-Horse_Placenta.pmd_PMD_family_OE")
horse <- horse %>%
  mutate(Species = "Horse")

rhesus <- read.table("~/Desktop/Decato-PMD-revision-analysis/F3A_OE_data/Schroeder-2015-Rhesus_Placenta.pmd_PMD_family_OE")
rhesus <- rhesus %>%
  mutate(Species = "Rhesus")

fullTable <- rbind(human, cow, dog, horse, rhesus, sm, mouse)
colnames(fullTable) <- c("Retrotransposon family", "Number of PMDs",
                         "Number of retros in family", "Obs. retros in PMDs", "Exp. retros in PMDs", "O/E ratio", "Species")

# Binomial tests for significance
fullTable <- fullTable %>%
  rowwise() %>%
  mutate(BinomTestP = (binom.test(`Obs. retros in PMDs`, `Number of retros in family`, 
                                  `Exp. retros in PMDs`/`Number of retros in family`))$p.value) %>%
  mutate(adjP = p.adjust(BinomTestP)) %>% 
  mutate(sig = ifelse(adjP < 0.05,"Yes","No")) 

table(fullTable$sig)

write.table(fullTable, file = "~/Desktop/Decato-PMD-revision-analysis/F3A_OE_table.tsv", quote = FALSE,
            append = FALSE, sep = "\t", row.names = FALSE)

rm(cow, dog, horse, human, mouse, rhesus, sm)

#####################################
# Boundary associations with CpG islands, TSS/TES, CTCF, and chromatin loops
#####################################
cgi <- read.table("~/Desktop/Decato-PMD-revision-analysis/OE_statistics/human_cgi_boundary_OE", header = TRUE)
summary(cgi$OE) # There is a median OE ratio of 1.9 across all PMD containing samples.

cgi <- cgi %>%
  rowwise() %>%
  mutate(BinomTestP = (binom.test(ObsOverlap, NumCGIs, ExpOverlap/NumCGIs))$p.value) %>%
  mutate(adjP = p.adjust(BinomTestP)) %>% mutate(sig = ifelse(adjP < 0.05,"Yes","No")) %>%
  mutate(Region = "CGI")
table(cgi$sig)

write.table(cgi, file = "~/Desktop/Decato-PMD-revision-analysis/cgi_OE_table.tsv", quote = FALSE,
            append = FALSE, sep = "\t", row.names = FALSE)

#### TSS
tss <- read.table("~/Desktop/Decato-PMD-revision-analysis/OE_statistics/human_TSS_boundary_OE", header = TRUE)
summary(tss$OE) # There is a median OE ratio of 1.65 across all PMD containing samples.

tss <- tss %>%
  rowwise() %>%
  mutate(BinomTestP = (binom.test(ObsOverlap, NumTSSs, ExpOverlap/NumTSSs))$p.value) %>%
  mutate(adjP = p.adjust(BinomTestP)) %>% mutate(sig = ifelse(adjP < 0.05,"Yes","No")) %>%
  mutate(Region = "TSS")
table(tss$sig)

write.table(tss, file = "~/Desktop/Decato-PMD-revision-analysis/tss_OE_table.tsv", quote = FALSE,
            append = FALSE, sep = "\t", row.names = FALSE)



#### TES
tes <- read.table("~/Desktop/Decato-PMD-revision-analysis/OE_statistics/human_TES_boundary_OE", header = TRUE)
summary(tes$OE) # There is a median OE ratio of 1.65 across all PMD containing samples.

tes <- tes %>%
  rowwise() %>%
  mutate(BinomTestP = (binom.test(ObsOverlap, NumTESs, ExpOverlap/NumTESs))$p.value) %>%
  mutate(adjP = p.adjust(BinomTestP)) %>% mutate(sig = ifelse(adjP < 0.05,"Yes","No")) %>%
  mutate(Region = "TES")
table(tes$sig)

write.table(tes, file = "~/Desktop/Decato-PMD-revision-analysis/tes_OE_table.tsv", quote = FALSE,
            append = FALSE, sep = "\t", row.names = FALSE)

#####################################
# Figure 3D.
#####################################
data<-read.table("~/Desktop/Decato-PMD-revision-analysis/F3D_depth_by_conservation.txt",header=TRUE)

smoothScatter(data$meanMeth~data$numSamples)

model <- lm(data=data, meanMeth~numSamples)
summary(model)

# Figure 3D.
#smoothScatter(data$numSamples,data$meanMeth)

ggplot(data,aes(x=numSamples,y=meanMeth)) + 
  geom_hex() + 
  stat_smooth(method=lm, color="red") +
  theme_bw() +
  theme(legend.position = "bottom", text = element_text(size=14), axis.text = element_text(size = 10),
        axis.text.x = element_text(angle = 45, hjust = 1), strip.background = element_blank(),
        strip.placement = "outside")

