## Script to get CGIs inside and outside of PMDs and summarize their methylation levels into a file. Assumes manifest is in the directory and is sorted to join on.
#!/bin/bash

for i in $(find . -name "*.meth.islands"); do
  species=$(basename $(dirname ${i}));
  bedtools intersect -f 0.999  -wa -a ${i} -b $(dirname ${i})/$(basename ${i} .meth.islands).pmd > ${i}.inpmds;
  bedtools intersect -v -f 0.999  -wa -a ${i} -b $(dirname ${i})/$(basename ${i} .meth.islands).pmd > ${i}.outpmds;
  awk -v spec=${species} -v samp=$(basename ${i} .meth.islands) '{print samp "\t" spec "\tout\t"  $5}' ${i}.outpmds >> island_summary;
  awk -v spec=${species} -v samp=$(basename ${i} .meth.islands) '{print samp "\t" spec "\tin\t"  $5}' ${i}.inpmds >> island_summary;
  rm ${i}.inpmds ${i}.outpmds;
done

find . -name "*.meth.islands" -exec rm {} \;

sort -k 1b,1 island_summary > temp; mv temp island_summary;
join manifest island_summary > temp; mv temp island_summary;

