
## gene_transcription_direction.sh <list_of_pmd_files> <gene_bed_file> 

#!/bin/bash
for i in $(grep "Human" $1); do
  bedtools closest -D a -io -iu -s -a ${i}.pmd -b $2 | awk '{print $13 "\tright\taway"}' >> gene_distances_and_orientations # right of PMD, transcribed away
  bedtools closest -D a -io -iu -S -a ${i}.pmd -b $2 | awk '{print $13 "\tright\ttowards"}' >> gene_distances_and_orientations  # right of PMD, transcribed towards
  bedtools closest -D a  -io -id -s -a ${i}.pmd -b $2 | awk '{print $13 "\tleft\ttowards"}' >> gene_distances_and_orientations # left of PMD, transcribed towards
  bedtools closest -D a -io -id -S -a ${i}.pmd -b $2 | awk '{print $13 "\tleft\taway"}' >> gene_distances_and_orientations # left of PMD, transcribed away
done



