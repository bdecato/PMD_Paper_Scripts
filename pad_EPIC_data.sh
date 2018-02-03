#!/bin/bash

# As currently written, pmd requires all samples used together to have the 
# same number of input lines. To add the empty WGBS CpGs to the array data,
# run with $1 = your WGBS sample:

awk '{print $1 ":" $2}' $1 > $1.positions
for i in *_EPIC.meth; do
  cat $1.positions > temp;
  awk '{print $1 ":" $2}' ${i} >> temp;
  sort -k 1b,1 temp | uniq -c | awk '{if($1==1){split($2,a,":"); print a[1] "\t" a[2] "\t+\tCpG\t-1"}}' > ${i}.missing;
  cat ${i}.missing ${i} | sort -k 1,1 -k 2,2g > ${i}.final;
  rm ${i}.missing temp;
done


