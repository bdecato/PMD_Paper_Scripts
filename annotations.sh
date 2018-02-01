
# This script assumes a directory where there are _rmsk files that are raw repeatmasker data downloaded from the UCSC genome browser and raw CpG islands files downloaded from the UCSC genome browser. It produces BED format files from these raw input files.

#!/bin/bash
for i in *_rmsk; do
  echo ${i};
  awk '{if($12=="LINE" || $12=="SINE" || $12=="LTR"){print $6 "\t" $7 "\t" $8 "\t" $12 ":" $13 ":" $11 "\t0\t" $10}}' ${i} | sort -k 1,1 -k 2,2g -k 3,3g -k 6,6 > ${i}.bed;
done 

## TODO: CpG island from raw
