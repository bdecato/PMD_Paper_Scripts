####################################################
## preprocess_EPIC_data.sh <epic.txt> <manifest>  ##
####################################################
# Manifest downloaded from: https://support.illumina.com/array/array_kits/infinium-methylationepic-beadchip-kit/downloads.html
# infinium-methylationepic-v-1-0-b4-manifest-file-csv.zip
# epic.txt should be a normalized beta file: example is the EPIC processed datasets from Pidsley et al. (2016):
# https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE86831

## Preprocess the manifest to join chromosome information to beta values

awk -F $',' '{print $1 "\tchr" $12 ":" $13 ":" $15}' $2 | awk '{if(NF==2){print $0}}' | sort -k 1b,1 > $2.joiner;

## Preprocess the beta table from GSE86831 assuming the file format is:
## ID_REF	sample1_beta	sample1_pval	sample2_beta	sample2_pval ...
## cg2350926 0.236	0.007	0.9267	0.2347	...
## ...

x=$(awk -F $'\t' '{print NF}' $1 | head -n 1)
for ((i=2; i<=${x}; i+=2))
do
  awk -v rownum=${i} -F $'\t' '{print $1 "\t" $rownum}' $1  > ${i}.meth
  filename=$(head -n 1 ${i}.meth | awk -F $'\t' '{print $2}' | tr " " "_");
  sed '1d' ${i}.meth | sort -k 1b,1 > ${filename}.tojoin;
  rm ${i}.meth;
done

## 

for i in *.tojoin; do
  join ${i} $2.joiner | awk '{split($3,a,":"); if(a[3]=="F"){print a[1] "\t" a[2]-1 "\t+\t" $1 "\t" $2}else{print a[1] "\t" a[2]-1 "\t+\t" $1 "\t" $2}}' | sort -k 1,1 -k 2,2g > $(basename ${i} .tojoin).meth;
done

rm *.joiner *.tojoin;
