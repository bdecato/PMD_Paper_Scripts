#!/bin/bash

## $1 = gene annotation BED file
## $2 = species (Human, Mouse, SquirrelMonkey, Rhesus, Cow, Horse, Dog)
export LC_ALL=C;

# Don't merge book-ended genes
bedtools merge -d -1 -c 4 -o collapse -i $1 | awk '{print $0 "\t0\t+"}' | sort -k 1,1 -k 2,2g -k 3,3g > $1.uniq;
awk '{print $4}' $1.uniq | sort | uniq -c | awk '{if($1>1){print $2}}' > duplicate_genes;
grep -v -f duplicate_genes $1.uniq > $1.uniq2;
mv $1.uniq2 $1.uniq;
rm duplicate_genes;

awk '{if($2>100000){print $1 "\t" $2-100000 "\t" $2 "\t" $4 "\t0\t+"}else{print $1 "\t0\t" $2 "\t" $4 "\t0\t+"}}' $1.uniq > $1.left100k
awk '{print $1 "\t" $3 "\t" $3+100000 "\t" $4 "\t0\t+"}' $1.uniq > $1.right100k


grep "$2" pmd_samplenames > $2_samples;

for i in $(cat $2_samples); do
  bedtools intersect -wao -a $1.uniq -b ${i}.pmd | awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $13 "\t+"}' | sort -k 1,1 -k 2,2g -k 3,3g > tempescapee;
  bedtools merge -d -1 -c 4,5 -o distinct,sum -i tempescapee | awk '{print $4 "\t" $1 ":" $2 "-" $3 "\t" $3-$2 "\t" $5/($3-$2)}' | sort -k 1b,1 > ${i}.props.tojoin;

  bedtools intersect -wao -a $1.left100k -b ${i}.pmd | awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $13 "\t+"}' | sort -k 1,1 -k 2,2g -k 3,3g > tempescapee;
  bedtools merge -d -1 -c 4,5 -o distinct,sum -i tempescapee | awk '{print $4 "\t" $5/($3-$2)}' | sort -k 1b,1 > ${i}.lefts.tojoin;

  bedtools intersect -wao -a $1.right100k -b ${i}.pmd | awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $13 "\t+"}' | sort -k 1,1 -k 2,2g -k 3,3g > tempescapee;
  bedtools merge -d -1 -c 4,5 -o distinct,sum -i tempescapee | awk '{print $4 "\t" $5/($3-$2)}' | sort -k 1b,1 > ${i}.rights.tojoin;

  ## Aggregate all the necessary proportions
  join ${i}.props.tojoin ${i}.lefts.tojoin > tempescapee;
  join tempescapee ${i}.rights.tojoin | awk -v name=$(basename ${i}) '{ print name "\t" $0}' >> escapees

  ## Cleanup
  rm ${i}.rights.tojoin ${i}.lefts.tojoin ${i}.props.tojoin;
done

sort -k 1b,1 escapees > tempescapee;
mv tempescapee escapees;
sort -k 1b,1 manifest > manifest.tojoin;
join manifest.tojoin escapees > escapees.joined;

# rm $1.right100k $1.left100k
# rm $2_samples manifest.tojoin;

