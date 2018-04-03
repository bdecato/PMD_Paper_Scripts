#!/bin/bash

# For each PMD with size greater than 200kb, break it up into 5kb blocks that stretch 100k left and right of each boundary, and
# name them with binIDs o20 o19 .. o1 i1 i2 .. i20. Get roimethstat across all such bed files and cat them together. boxplot by name

export LC_ALL=C;
for i in $(cat pmd_samplenames); do
  awk -v sname=${i} -v numbins=100 '{
    if($3-$2 > 200000){
      for(i=$2;i>$2-100000;i-=5000){
        if(i-5000>0){print $1 "\t" int(i)-5000 "\t" int(i) "\t" sname ":binID:lo" ($2-i)/5000 "\t0\t" $6}  
      }
      for(i=$2;i<$2+100000;i+=5000){
        print $1 "\t" int(i) "\t" int(i)+5000 "\t" sname ":binID:li" (i-$2)/5000 "\t0\t" $6
      }
      for(i=$3;i>$3-100000;i-=5000){
        if(i-5000>0){print $1 "\t" int(i)-5000 "\t" int(i) "\t" sname ":binID:ri" ($3-i)/5000 "\t0\t" $6}  
      }
      for(i=$3;i<$3+100000;i+=5000){
        print $1 "\t" int(i) "\t" int(i)+5000 "\t" sname ":binID:ro" (i-$3)/5000 "\t0\t" $6
      }
    }
  }' ${i}.pmd | sort -k 1,1 -k 2,2g -k 3,3g -k 6,6 > ${i}.absoluteChopped;
  sbatch --job-name=${i} --error ${i}.error --output ${i}.out --export=IN="${i}.meth",REF="${i}.absoluteChopped" /home/cmb-panasas2/decato/bin/PMD_Paper_Scripts/boundary_metagene_plots/do-roimethstat-chopped.slurm;
done

