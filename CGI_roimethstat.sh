## Script to calculate methylation levels inside CGIs for each PMD-containing mouse and human sample.
## Takes two arguments: paths to the CGI annotation file for mouse and humans.
## I used mm10_cpgislands.bed and hg19_cpgislands.bed, which are produced via annotations.sh from raw CGIs downloaded from the UCSC table browser.
#!/bin/bash

grep "Human" pmd_samplenames > human_pmdsamplenames
for i in $(cat human_pmdsamplenames); do qsub -v IN=${i}.meth,REF=${1} do-roimethstat-islands.pbs; sleep 0.1; done

grep "Mouse" pmd_samplenames > mouse_pmdsamplenames
for i in $(cat mouse_pmdsamplenames); do qsub -v IN=${i}.meth,REF=${2} do-roimethstat-islands.pbs; sleep 0.1; done

rm human_pmdsamplenames mouse_pmdsamplenames;

