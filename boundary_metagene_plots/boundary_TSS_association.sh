# $1: Genomic region BED file $2 output prefix (brief description of BED file)
#!/bin/bash

# Get the closest PMD boundary to each genomic region specified.
for i in $(cat pmd_containing_Rhesus_samples); do
  awk '{print $1 "\t" $2 "\t" $2+1 "\tleft:" $4 "\t" $5 "\t" $6 "\n" $1 "\t" $3-1 "\t" $3 "\tright:" $4 "\t" $5 "\t" $6}' ${i} > ${i}.bounds;
  bedtools closest -d -a ${1} -b ${i}.bounds 
done > ${2}_nearest_boundaries

grep -v -e "chrUn" -e "chrM" -e "random" -e "hap" -e "chrX" -e "chrY" ${2}_nearest_boundaries > temp; mv temp ${2}_nearest_boundaries

# From this raw data, I want the gene name, the distance from the PMD boundary
# stranded s.t. negative = internal, positive = external, and orientation
# as either transcribing "towards" or "away" from the boundary.
awk '{
  printf $4;
  split($10,a,":");

  if(a[1] == "left") {
    if($6 == "+") {printf "\ttowards\t"} else {printf "\taway\t"};
    if($2>$8) {print -1*$13} else {print $13};
  }
  else {
    if($6 == "+") {printf "\taway\t"} else {printf "\ttowards\t"};
    if($2>$8) {print $13} else {print -1*$13};
  }
}' ${2}_nearest_boundaries > ${2}_boundary_info;


