#!/usr/bin/bash

# Get the O/E ratios for genes in PMDs
 for i in *.pmd; do printf "%s\t" $(basename ${i} .pmd); ./sigoverlap -v -s 2881033286 -t ${i} hg19_autosomes.bed.uniq; done > human_genes_inside_pmds_OE

# Get the 5kb around PMD boundaries
for i in *.pmd; do awk '{print $1 "\t" $2-2500 "\t" $2+2500 "\t" $4 "\t" $5 "\t" $6 "\n" $1 "\t" $3-2500 "\t" $3+2500 "\t" $4 "\t" $5 "\t" $6}' ${i} > $(basename ${i} .pmd).boundaries; echo ${i}; done

# Get the O/E ratios for CpG islands and PMD boundaries
 for i in *.boundaries; do printf "%s\t" $(basename ${i} .pmd); ./sigoverlap -v -s 2881033286 -t ${i} hg19_autosome_cpgislands.bed; done > human_cgi_boundary_OE

# Get the O/E ratios for TSS and PMD boundaries
for i in *.boundaries; do printf "%s\t" $(basename ${i} .pmd); ./sigoverlap -v -s 2881033286 -t ${i} hg19_autosomal_TSS.bed; done > human_TSS_boundary_OE

# Get the O/E ratios for TES and PMD boundaries
for i in *.boundaries; do printf "%s\t" $(basename ${i} .pmd); ./sigoverlap -v -s 2881033286 -t ${i} hg19_autosomal_TES.bed; done > human_TES_boundary_OE

# Get the O/E of loop boundaries with PMD boundaries
# Get the 5kb around loop boundaries
for i in *HiCCUPS*.bed; do awk '{print $1 "\t" $2-2500 "\t" $2+2500 "\n" $1 "\t" $3-2500 "\t" $3+2500}' ${i} > $(basename ${i} .bed).boundaries; echo ${i}; done

# Get rid of sex chromosomes in the chromatin loop data
for i in *CCUPS*boundaries; do grep -v "chrX" ${i} | sort -k 1,1 -k 2,2g -k 3,3g > temp; mv temp ${i}; done

./sigoverlap -v -s 2881033286 -t Hon-2012_Human_HMEC.boundaries GSE63525_HMEC_HiCCUPS_looplist_with_motifs.boundaries

./sigoverlap -v -s 2881033286 -t Lister-ESC-2009_Human_IMR90.boundaries GSE63525_IMR90_HiCCUPS_looplist_with_motifs.boundaries

./sigoverlap -v -s 2881033286 -t Schlesinger-2013_Human_GM12878.boundaries GSE63525_GM12878_primary+replicate_HiCCUPS_looplist_with_motifs.boundaries












