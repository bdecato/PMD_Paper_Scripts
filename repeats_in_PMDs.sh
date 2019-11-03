#!/bin/bash

#assembly=$1
#genomesize=$2
# PMD sample name =$3
# repeat annotation = $4
export LC_ALL=C;

awk '{split($4,a,":"); print a[1]}' $4 | sort | uniq | grep -v "?" > $3_class.bed
awk '{split($4,a,":"); print a[1] ":" a[2]}' $4 | sort | uniq | grep -v "?" > $3_family.bed
awk '{split($4,a,":"); print a[1] ":" a[2] ":" a[3]}' $4 | sort | uniq | grep -v "?" > $3_subfamily.bed

for i in $(cat $3_class.bed); do
  grep "$i" $4 | sort -k 1,1 -k 3,3g -k 2,2g -k 6,6 > ${3}_${i}_rmsk.bed;
  printf "%s\t" ${i};
  sigoverlap -v -s $2 -t $3 ${3}_${i}_rmsk.bed
  rm ${3}_${i}_rmsk.bed;
done > $3_PMD_class_OE;

for i in $(cat $3_family.bed); do
  x=$(echo ${i} | sed 's/:/-/g') #sanitized filename
  grep "$i" $4 | sort -k 1,1 -k 3,3g -k 2,2g -k 6,6  > ${3}_${x}_rmsk.bed;
  printf "%s\t" ${i};  
  sigoverlap -v -s $2 -t $3 ${3}_${x}_rmsk.bed
  rm ${3}_${x}_rmsk.bed;
done > $3_PMD_family_OE;

for i in $(cat $3_subfamily.bed); do
  x=$(echo ${i} | sed 's/:/-/g') #sanitized filename
  grep "$i" $4 | sort -k 1,1 -k 3,3g -k 2,2g -k 6,6 > ${3}_${x}_rmsk.bed;
  printf "%s\t" ${i};  
  sigoverlap -v -s $2 -t $3 ${3}_${x}_rmsk.bed
  rm ${3}_${x}_rmsk.bed;
done > $3_PMD_subfamily_OE;



