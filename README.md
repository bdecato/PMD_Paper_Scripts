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
