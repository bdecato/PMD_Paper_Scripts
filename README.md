# PMD_Paper_Scripts
A repository containing some shell, Python, and R scripts that were important for figure generation in my PMD paper.

For now (AKA until I have a figure layout), these are stored in a flat format. Most Rscripts take flat files from their paired shell script as input. Some shell scripts require access to a high-performance computing cluster, as they submit a QSUB job with a portable batch file.

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

Where inside each species folder is a `.meth`-extension output file from the MethPipe program `methcounts`, a `.pmd`-extension output file from the MethPipe program `pmd` (the latest version of this program, committed on the day of submission for this paper), and a `.meth.error`-extension file that contains the std::error verbose output from the `pmd` program run.

Many downstream scripts also assume a file called ```pmd_samplenames``` exists in the top-level directory, which has the results of the command `awk '{if($3>0.05 && $4>100000){print $2 "/" $1}}' segmentation_statistics > pmd_samplenames` run on the output of `segmentation_statistics.sh`.
