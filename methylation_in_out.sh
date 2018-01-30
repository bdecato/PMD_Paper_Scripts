## Script to produce data frame that has sample metadata from the manifest
## together with methylation levels inside and outside of PMDs.
#!/bin/bash

for i in $(find . -name "*.roimethstat"); do
  species=$(basename $(dirname ${i}))
  sname=$(echo $(basename ${i} .roimethstat) | awk '{split($1,a,"."); print a[1]}');
  context=$(echo $(basename ${i} .roimethstat) | awk '{split($1,a,"."); print a[2]}');
  awk -v name=${sname} -v ctxt=${context} -v spec=${species} '{split($4,a,":"); print name "\t" ctxt "\t" spec "\t" $3-$2 "\t" a[2] "\t" $5}' ${i};
done > Out_In_PMD_Statistics

awk '{if(NF==5){print $1 "\tpmd\t" $2 "\t" $3 "\t" $4 "\t" $5}else{print $0}}' Out_In_PMD_Statistics
sort -k 1b,1 Out_In_PMD_Statistics > Out_In_PMD_Statistics.tojoin;
sort -k 1b,1 manifest > manifest.tojoin
join manifest.tojoin Out_In_PMD_Statistics.tojoin > Out_In_PMD_Statistics.joined;



