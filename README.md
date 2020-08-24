# Data availability

Raw bisulfite and RNA-sequencing data for novel methylomes and transcriptomes used in this study can be accessed via the Gene Expression Omnibus (GEO) under accession number GSE152819. Additionally, we provide here a compressed dataset containing the chromosomal locations of called PMDs in all tissues (`AllPMDs.tar.gz2`).

# PMD Paper Scripts

This repository contains a mix of shell, Python, and R scripts, some designed to be run with the slurm high-performance computing environment scheduler. These scripts were important for figure generation. For now, these are stored in a flat format. Most Rscripts take flat files from their paired shell script as input.

All analysis performed assumes a directory structure like the following:

```
Decato-PMD-Analysis
├───Human
├───Mouse
├───Cow
├───Horse
├───Dog
├───SquirrelMonkey
└───Rhesus
```

Inside each species folder contains a `.meth` extension output file from the MethPipe program `methcounts`, a `.pmd`-extension output file from the MethPipe program `pmd`, and a `.hmr`-extension file that contains the output from the MethPipe program `hmr`. All programs used are the versions committed on the day of submission for this paper.

Many downstream scripts also assume a file called ```pmd_samplenames``` exists in the top-level directory, which has the results of the command `awk '{if($3>0.05 && $4>100000){print $2 "/" $1}}' segmentation_statistics > pmd_samplenames` run on the output of `segmentation_statistics.sh`.

# TrackHubs

## Overview

The segmentation results used in this paper are split into three trackhubs to maximize the convenience of their use. The first trackhub contains all PMD-containing samples mapped to their native reference and segmented. It is organized by study and PMD-containing samples were chosen using a cutoff of at least 5% of the genome segmented and a mean segment size of 50kb. The second trackhub contains all non-PMD-containing samples mapped to their native reference and segmented. It is intended to be used as a supplementary browsing tool for people to see the result of my segmentation on samples that don't have PMDs. The last trackhub is the "lifted" trackhub. It contains all non-human samples mapped to hg19 and segmented, as well as all human samples mapped to mm10 and then segmented. Due to the distance between species, there are a few low-coverage samples that we were unable to segment following liftover, but they have been included anyway.

## Layout

For all three trackhubs, we provide the following files:

* Methylation (shown) and coverage (hidden) bigWig files
* PMD and HMR bigBed segments (shown)
* PMD posterior probability bigWig files (hidden)
* PMD boundary score bigWig files (hidden)

The trackhubs can be loaded by providing the following the following links to the "add trackhub" section of the UCSC genome browser:

http://smithlab.usc.edu/lab/public/decato/Decato-PMDs/hub.txt

http://smithlab.usc.edu/lab/public/decato/Decato-nonPMDs/hub.txt

http://smithlab.usc.edu/lab/public/decato/Decato-Lifted-PMDs/hub.txt

After loading the trackhubs, you can load the session below to quickly and easily browse the methylation levels and PMD calls (centered around an escapee gene, MAD2L1, mitotic spindle assembly checkpoint protein, MAD2A):

http://genome.ucsc.edu/s/bdecato/Decato%2DHuman%2DPMDs%2D2020
