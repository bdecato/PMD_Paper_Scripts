
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
  grep "$i" hg19.ensembl | awk '{print $3 "\t" $5 "\t" $6 "\t" $13}' | sort -k 1,1 -k 2,2g -k 3,3g > temp;
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

## Sometimes bedtools merge with a 10Mb distance doesn't work because paralogs are on separate chromosomes.
for i in *_collapsed; do 
  awk '{split($4,a,","); print $1 "\t" $2 "\t" $3 "\t" a[1]}' ${i} > temp; 
  sort -u -k4,4 temp > ${i}.uniqed; 
done

## Final cleanup to ensure every sample has exactly the same number of genes
for i in *.uniqed; do
  awk '{print $4}' ${i} | sort -k 1b,1 > ${i}.final; 
done
one=$(ls *.final| head -n 1);
two=$(ls *.final| head -n 2 | tail -n 1);
join ${one} ${two} > joined;
rm ${one} ${two};
for i in *.final; do
  join ${i} joined > temp;
  mv temp joined;
done

for i in *.uniqed; do
  awk '{print $4 "\t" $0}' ${i} | sort -k 1b,1 > ${i}.tojoin;
  join joined ${i}.tojoin | awk '{print $2 "\t" $3 "\t" $4 "\t" $5}' > ${i};
done

rm *.tojoin *.final joined;

## Minor formatting
export LC_ALL=C;
for i in Human*.uniqed; do
  awk '{print "chr" $0}' ${i} | sort -k 1,1 -k 2,2g -k 3,3g > $(dirname ${i})/$(basename ${i} .uniqed);
done
rm *.uniqed;

sed 's/chr//g' Human_SquirrelMonkey_ensembl_orthologs_collapsed > temp; mv temp Human_SquirrelMonkey_ensembl_orthologs_collapsed # chromosome names were right to begin with
sed 's/\.1//g' Human_SquirrelMonkey_ensembl_orthologs_collapsed > temp; mv temp Human_SquirrelMonkey_ensembl_orthologs_collapsed # chromosome names were right to begin with

## Get consensus PMDs for placenta in each species

bedtools intersect -f 0.999 -wa -a Human_Cow_ensembl_orthologs_collapsed -b Cow/Schroeder-2015-Cow_Placenta.pmd > Cow_genes_in_PMD
bedtools intersect -f 0.999  -wa -a Human_Cow_ensembl_orthologs_collapsed -b Cow/Schroeder-2015-Cow_Placenta.anti-pmd > Cow_genes_out_PMD

bedtools intersect -f 0.999  -wa -a Human_Mouse_ensembl_orthologs_collapsed -b Mouse/Schroeder-2015-Mouse_Placenta.pmd > Mouse_genes_in_PMD
bedtools intersect -f 0.999  -wa -a Human_Mouse_ensembl_orthologs_collapsed -b Mouse/Schroeder-2015-Mouse_Placenta.anti-pmd > Mouse_genes_out_PMD

bedtools intersect -f 0.999  -wa -a Human_Horse_ensembl_orthologs_collapsed -b Horse/Schroeder-2015-Horse_Placenta.pmd > Horse_genes_in_PMD
bedtools intersect -f 0.999  -wa -a Human_Horse_ensembl_orthologs_collapsed -b Horse/Schroeder-2015-Horse_Placenta.anti-pmd > Horse_genes_out_PMD

bedtools intersect -f 0.999  -wa -a Human_Dog_ensembl_orthologs_collapsed -b Dog/Schroeder-2015-Dog_Placenta.pmd > Dog_genes_in_PMD
bedtools intersect -f 0.999  -wa -a Human_Dog_ensembl_orthologs_collapsed -b Dog/Schroeder-2015-Dog_Placenta.anti-pmd > Dog_genes_out_PMD

bedtools intersect -f 0.999  -wa -a Human_SquirrelMonkey_ensembl_orthologs_collapsed -b SquirrelMonkey/Schroeder-2015-SquirrelMonkey_Placenta.pmd > SquirrelMonkey_genes_in_PMD
bedtools intersect -f 0.999  -wa -a Human_SquirrelMonkey_ensembl_orthologs_collapsed -b SquirrelMonkey/Schroeder-2015-SquirrelMonkey_Placenta.anti-pmd > SquirrelMonkey_genes_out_PMD

bedtools intersect -f 0.999  -wa -a Human_Rhesus_ensembl_orthologs_collapsed -b Rhesus/Schroeder-2015-Rhesus_Placenta.pmd > Rhesus_genes_in_PMD
bedtools intersect -f 0.999  -a Human_Rhesus_ensembl_orthologs_collapsed -b Rhesus/Schroeder-2015-Rhesus_Placenta.anti-pmd > Rhesus_genes_out_PMD

bedtools intersect -f 0.999  -wa -a hg19_orthologs_collapsed -b Human/Schroeder-2013_Human_Placenta.pmd > Human_genes_in_PMD
bedtools intersect -f 0.999  -wa -a hg19_orthologs_collapsed -b Human/Schroeder-2013_Human_Placenta.anti-pmd > Human_genes_out_PMD

for i in $(cat species_list); do
  awk '{print $4 "\t1"}' ${i}_genes_in_PMD > ${i}_PMD_status;
  awk '{print $4 "\t0"}' ${i}_genes_out_PMD >> ${i}_PMD_status;
  sort -k 1b,1 ${i}_PMD_status > temp; mv temp ${i}_PMD_status;
done

join Human_PMD_status Rhesus_PMD_status > joined;
join joined SquirrelMonkey_PMD_status > temp; mv temp joined;
join joined Mouse_PMD_status > temp; mv temp joined;
join joined Cow_PMD_status > temp; mv temp joined;
join joined Horse_PMD_status > temp; mv temp joined;
join joined Dog_PMD_status > temp; mv temp joined;
mv joined UpSet-matrix
