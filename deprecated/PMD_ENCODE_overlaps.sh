# Computes O/E ratio for each mark in a chromHMM mark BED with a PMD file.
#!/bin/bash

export LC_ALL=C;
for i in *.meth; do 
  for j in $(awk '{print $4}' $(basename ${i} .meth)_chromHMM.bed | sort | uniq -c | awk '{print $2}'); do
    awk -v mark=${j} '{if($4==mark){print $0}}' $(basename ${i} .meth)_chromHMM.bed | sort -k 1,1 -k 3,3g -k 2,2g > temp;
    printf "%s\t%s\t" $(basename ${i} .meth) ${j};
    sigoverlap -s 288103286 -v -t $(basename ${i} .meth).pmd temp;
    rm temp;
  done
done > sigoverlap_output;

# TODO generalize this script
awk '{if($1=="Schlesinger-Lymphoblastoid-2013_Human_GM12878"){print $1 "\t" $2 "\t" $5/$4 "\t" 1477981687/2881033286 "\t" ($5/$4)/(1477981687/2881033286)} else if($1=="Human_HepG2"){print $1 "\t" $2 "\t" $5/$4 "\t" 1342788182/2881033286 "\t" ($5/$4)/(1342788182/2881033286)}else{print $1 "\t" $2 "\t" $5/$4 "\t" 850113620/2881033286 "\t" ($5/$4)/(850113620/2881033286)}}' sigoverlap_output > temp



