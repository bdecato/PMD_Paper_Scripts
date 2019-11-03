#!/bin/bash

#assembly=$1
#genomesize=$2
# closeness to boundary cutoff, default 5k = $3
#PMD sample name=$4
#repeat annotation=$5
export LC_ALL=C;

awk -v bound=$3 '{if($2>bound){print $1 "\t" $2-bound "\t" $2 "\t" $4 "\t" $5 "\t" $6}}' ${4} > ${4}.external_boundaries;
awk -v bound=$3 '{print $1 "\t" $3 "\t" $3+bound"\t" $4 "\t" $5 "\t" $6}' ${4} >> ${4}.external_boundaries;
awk -v bound=$3 '{print $1 "\t" $2 "\t" $2+bound "\t" $4 "\t" $5 "\t" $6}' ${4} > ${4}.internal_boundaries;
awk -v bound=$3 '{if($3>bound){print $1 "\t" $3-bound "\t" $3 "\t" $4 "\t" $5 "\t" $6}}' ${4} >> ${4}.internal_boundaries;

sort -k 1,1 -k 2,2g -k 3,3g -k 6,6 ${4}.external_boundaries > ${4}.temp; mv ${4}.temp ${4}.external_boundaries;
sort -k 1,1 -k 2,2g -k 3,3g -k 6,6 ${4}.internal_boundaries > ${4}.temp; mv ${4}.temp ${4}.internal_boundaries;

awk '{split($4,a,":"); print a[1]}' $5 | sort | uniq > $4_class.bed
awk '{split($4,a,":"); print a[1] ":" a[2]}' $5 | sort | uniq > $4_family.bed
awk '{split($4,a,":"); print a[1] ":" a[2] ":" a[3]}' $5 | sort | uniq > $4_subfamily.bed

for i in $(cat $4_class.bed); do
  grep "$i" $5 | sort -k 1,1 -k 3,3g -k 2,2g -k 6,6 | grep -v -e "chrUn" -e "chrM" -e "chrX" -e "chrY" -e "hap" -e "random" > ${4}_${i}_rmsk.bed;
  printf "%s\tinternal\t" ${i}; 
  sigoverlap -v -s $2 -t ${4}.internal_boundaries ${4}_${i}_rmsk.bed
  printf "%s\texternal\t" ${i};
  sigoverlap -v -s $2 -t ${4}.external_boundaries ${4}_${i}_rmsk.bed
  rm ${4}_${i}_rmsk.bed;
done > ${4}_class_OE_$3

for i in $(cat $4_family.bed); do
  x=$(echo ${i} | sed 's/:/-/g')
  grep "$i" $5 | sort -k 1,1 -k 3,3g -k 2,2g -k 6,6 | grep -v -e "chrUn" -e "chrM" -e "chrX" -e "chrY" -e "hap" -e "random" > ${4}_${x}_rmsk.bed;
  printf "%s\tinternal\t" ${i}
  sigoverlap -v -s $2 -t ${4}.internal_boundaries ${4}_${x}_rmsk.bed
  printf "%s\texternal\t" ${i}
  sigoverlap -v -s $2 -t ${4}.external_boundaries ${4}_${x}_rmsk.bed
  rm ${4}_${x}_rmsk.bed;
done > ${4}_family_OE_$3

for i in $(cat $4_subfamily.bed); do
  x=$(echo ${i} | sed 's/:/-/g')
  grep "$i" $5 | sort -k 1,1 -k 3,3g -k 2,2g -k 6,6 | grep -v -e "chrUn" -e "chrM" -e "chrX" -e "chrY" -e "hap" -e "random" > ${4}_${x}_rmsk.bed;
  printf "%s\tinternal\t" ${i}
  sigoverlap -v -s $2 -t ${4}.internal_boundaries ${4}_${x}_rmsk.bed
  printf "%s\texternal\t" ${i}
  sigoverlap -v -s $2 -t ${4}.external_boundaries ${4}_${x}_rmsk.bed
  rm ${4}_${x}_rmsk.bed;
done > ${4}_subfamily_OE_$3

#rm $1_class.bed $1_family.bed $1_subfamily.bed;
#rm *.external_boundaries *.internal_boundaries;
 
