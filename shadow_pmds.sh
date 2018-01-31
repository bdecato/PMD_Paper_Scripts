#!/bin/bash


# Probably should've done this earlier. Get rid of any weird
# chromosome names in the PMDs.
for i in $(find . -name "*.pmd"); do
  grep -v -e "chrUn" -e "_random" -e "_hap" ${i} > ${i}.temp;
  mv ${i}.temp ${i};
done

# get the union and difference of PMDs for human
grep "Human" pmd_samplenames > human_pmdsamples;
for i in $(cat human_pmdsamples); do
  cat ${i}.pmd;
done | sort -k 1,1 -k2,2g -k 3,3g > to_merge;
bedtools merge -i to_merge > Union_Human_PMDs.bed;
bedtools subtract -a /home/cmb-panasas2/decato/regions_of_interest/hg19_chroms.bed -b Union_Human_PMDs.bed > Difference_Human_PMDs.bed;
rm to_merge;

# Get the intersection of PMDs for human
first=$(head -n 1 human_pmdsamples);
second=$(head -n 2 human_pmdsamples | tail -n 1);
bedtools intersect -a ${first}.pmd -b ${second}.pmd > intersection;
for i in $(sed 1,2d human_pmdsamples); do
  bedtools intersect -a intersection -b ${i}.pmd > temp;
  mv temp intersection;
done

mv intersection Intersection_Human_PMDs.bed;

# Get the filenames for human samples that don't have PMDs:
for i in $(find Human -name "*.pmd"); do 
  echo $(dirname ${i})/$(basename ${i} .pmd); 
done | sort > human_allsamples
sort human_pmdsamples > temp;
diff temp human_allsamples | awk '{if(NF==2){print $2}}' > human_nonpmdsamples
rm temp human_allsamples;

# get average methylation level inside and outside of union PMDs for non-PMD samples
for i in $(cat human_nonpmdsamples); do
  qsub -v IN=${i}.meth,UNION="Intersection_Human_PMDs.bed",DIFFERENCE="Difference_Human_PMDs.bed" /home/cmb-panasas2/decato/bin/PMD_Paper_Scripts/do-roimethstat-inoutunion.pbs; sleep 0.1;
done
