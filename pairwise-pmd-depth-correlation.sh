#!/bin/bash

for i in $(grep "Human" pmd_samplenames); do
  printf "\t%s" $(basename ${i});
done > pairwise_pearson_correlation;
printf "\n" >> pairwise_pearson_correlation;
for i in $(grep "Human" pmd_samplenames); do
  printf "%s\t" ${i}
  for j in $(grep "Human" pmd_samplenames); do
    x=$(Rscript correlation.R $(basename ${i})_$(basename ${j}).joined | awk '{print $2}');
    printf "%s\t" "$x"
  done
  printf "\n";
done >> pairwise_pearson_correlation

