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
for i in *.boundaries; do printf "%s\t" $(basename ${i} .pmd); ./sigoverlap -v -s 2881033286 -t ${i} hg19_autosomal_TES.bed; done > human_TSS_boundary_OE

# Get the O/E ratio for CTCF and PMD boundaries
