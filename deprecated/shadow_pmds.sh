## Arguments: 1: species folder (Mouse, Human) 2: Species assembly (hg19, mm10)

#!/bin/bash

# get the union and difference of PMDs for the species passed in
grep "$1" pmd_samplenames > ${1}_pmdsamples;
for i in $(cat ${1}_pmdsamples); do
  cat ${i}.pmd;
done | sort -k 1,1 -k2,2g -k 3,3g > to_merge;
bedtools merge -i to_merge > Union_${1}_PMDs.bed;
bedtools subtract -a /home/cmb-panasas2/decato/regions_of_interest/${2}_chroms.bed -b Union_${1}_PMDs.bed > Difference_${1}_PMDs.bed;
rm to_merge;

# Exclude regulatory regions from difference
bedtools subtract -a Difference_${1}_PMDs.bed -b /home/cmb-panasas2/decato/regions_of_interest/${2}/${2}_promoters.bed > temp;
mv temp Difference_${1}_PMDs.bed;
bedtools subtract -a Difference_${1}_PMDs.bed -b /home/cmb-panasas2/decato/regions_of_interest/${2}/${2}_cpgislands.bed > temp;

# Exclude expanded gene bodies and +/-100kb from those gene bodies from difference, added after
mv temp Difference_${1}_PMDs.bed;
bedtools subtract -a Difference_${1}_PMDs.bed -b /home/cmb-panasas2/decato/hg19_gencode/hg19_gencode_combined.bed > temp;
#mv temp Difference_${1}_PMDs.bed;
#bedtools subtract -a Difference_${1}_PMDs.bed -b /home/cmb-panasas2/decato/regions_of_interest/${2}/${2}_genes_flanking_50kb.bed > temp;
mv temp Difference_${1}_PMDs.bed;


# Get the intersection of PMDs
first=$(head -n 1 ${1}_pmdsamples);
second=$(head -n 2 ${1}_pmdsamples | tail -n 1);
bedtools intersect -a ${first}.pmd -b ${second}.pmd > intersection;
for i in $(sed 1,2d ${1}_pmdsamples); do
  bedtools intersect -a intersection -b ${i}.pmd > temp;
  mv temp intersection;
done

sort -k 1,1 -k 2,2g -k 3,3g intersection > Intersection_${1}_PMDs.bed
rm intersection;

# Get the filenames for human samples that don't have PMDs:
for i in $(find ${1} -name "*.pmd"); do 
  echo $(dirname ${i})/$(basename ${i} .pmd); 
done | sort > ${1}_allsamples
sort ${1}_pmdsamples > temp;
diff temp ${1}_allsamples | awk '{if(NF==2){print $2}}' > ${1}_nonpmdsamples
rm temp ${1}_allsamples;

# get average methylation level inside and outside of union PMDs for non-PMD samples
for i in $(cat ${1}_nonpmdsamples); do
  sbatch --job-name=${i}-roimethstat-inoutunion --output ${i}.out --error ${i}.error --export=IN="${i}.meth",UNION="Intersection_${1}_PMDs.bed",DIFFERENCE="Difference_${1}_PMDs.bed" /home/cmb-panasas2/decato/bin/PMD_Paper_Scripts/do-roimethstat-inoutunion.slurm; sleep 0.1;
done
