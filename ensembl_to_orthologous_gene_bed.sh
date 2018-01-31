
## Script to use ensembl's ortholog information to get a set of ensembl gene IDs that have orthologs across the 7 species we are studying.

## Download the hg19 ensembl annotation from the UCSC table browser:
## Name: hg19_ensembl
# https://genome.ucsc.edu/cgi-bin/hgTables?hgsid=654903791_ABSLVJTc3ZpnKMTrGugvfRcWKZGE&clade=mammal&org=Human&db=hg19&hgta_group=genes&hgta_track=ensGene&hgta_table=0&hgta_regionType=genome&position=chr21%3A33%2C031%2C597-33%2C041%2C570&hgta_outputType=primaryTable&hgta_outFileName=hg19_ensembl

## Download the orthologous ensembl IDs, ortholog quality score, ortholog location in distant species, and dN/dS values from ensembl's biomart.
## Name convention: Human_SPECIES_ensembl
# http://uswest.ensembl.org/biomart/martview/.

#!/bin/bash

## Identify the human ensembl IDs with an ortholog in every species:
for i in *_ensembl; do awk '{print $1}' ${i} | sort -k 1b,1 | uniq > ${i}.tojoin; done
one=$(ls *.tojoin| head -n 1);
two=$(ls *.tojoin| head -n 2 | tail -n 1);
join ${one} ${two} > joined;
rm ${one} ${two};
for i in *.tojoin; do
  join joined ${i} > temp;
  mv temp joined;
done
rm *.tojoin
grep -v "Gene" joined > temp; mv temp joined # Get rid of the header

## There are 13674 orthologs present in all 7 species, but only 13495 of them are in the hg19_ensembl annotation.
## We print them if they exist as below and then update the "joined" file to reflect the reduced set of genes.
for i in $(cat joined); do 
  grep "$i" ~/Downloads/hg19_ensembl | awk '{print $3 "\t" $5 "\t" $6 "\t" $13}' | sort -k 1,1 -k 2,2g -k 3,3g > temp;
  bedtools merge -d 10000000 -i temp -c 4 -o collapse >> hg19_orthologs_collapsed;
done

awk '{split($4,a,","); print a[1]}' hg19_orthologs_collapsed > joined;

## for each of the 13675 orthologs present in all 7 species, make bed file for other species. 13506 existed in hg19.

for i in $(cat joined); do
  for j in *_ensembl; do
    grep "$i" ${j} | awk '{if(NF==11){print $5 "\t" $6 "\t" $7 "\t" $1} if(NF==12){print $6 "\t" $7 "\t" $8 "\t" $1}}' | sort -k 1,1 -k 2,2g -k 3,3g > temp;
    bedtools merge -d 10000000 -i temp -c 4 -o collapse >> ${j}_orthologs_collapsed;
  done
done

