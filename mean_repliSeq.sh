## Two arguments: PMD file (1) and bedgraph file of matched repliseq values.
## Gets the average repliseq signal for each PMD and reports it + PMD size
#!/bin/bash

while read line; do
  echo $line | tr " " "\t" > $1.tempfile;
  echo $line | awk '{print $0 "\t" $3-$2}' | tr "\n" " ";
  bedtools intersect -a $2 -b $1.tempfile | awk 'BEGIN{total=0;count=0}{total+=$4;count++}END{if(count>0){print total/count}else{print 0}}'
done < $1 > $1.meanRepliseq
rm $1.tempfile;


