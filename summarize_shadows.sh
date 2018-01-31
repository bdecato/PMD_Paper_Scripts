## 1 argument: species used (Human / Mouse)

#!/bin/bash

for i in ${1}/*inPMDs.roimethstat; do 
  printf "%s\t" $(basename ${i} .meth.inPMDs.roimethstat); 
  awk 'BEGIN{total=0;count=0}{split($4,a,":"); total+=$5*a[5]; count+=a[5]}END{print total/count}' ${i} | tr "\n" " ";
  awk 'BEGIN{total=0;count=0}{split($4,a,":"); total+=$5*a[5]; count+=a[5]}END{print total/count}' $(dirname ${i})/$(basename ${i} .inPMDs.roimethstat).outPMDs.roimethstat;
done | awk '{print $0 "\t" $3-$2}' | sort -k 4,4g


