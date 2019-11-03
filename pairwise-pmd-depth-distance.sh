#!/bin/bash

for i in $(grep "Human" pmd_samplenames); do
  printf "\t%s" $(basename ${i});
done > pairwise_mean_distance;
printf "\n" >> pairwise_mean_distance;
for i in $(grep "Human" pmd_samplenames); do
  printf "%s\t" ${i}
  for j in $(grep "Human" pmd_samplenames); do
    #x=$(Rscript /home/cmb-panasas2/decato/bin/PMD_Paper_Scripts/correlation.R $(basename ${i})_$(basename ${j}).joined | awk '{print $2}');
    awk 'function abs(v) {return v < 0 ? -v : v}BEGIN{total=0;count=0}{total+=abs($2-$3);count++}END{print total/count}' $(basename ${i})_$(basename ${j}).joined | tr "\n" " ";
    #printf "%s\t" "$x"
  done
  printf "\n";
done >> pairwise_mean_distance

