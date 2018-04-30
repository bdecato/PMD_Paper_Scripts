#!/bin/bash
#SBATCH -J do-methylation_in_out_pmds.slurm
#SBATCH --partition cmb
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=5GB 
#SBATCH --time=100:00:00

# Script for getting average methylation inside and outside of PMDs, as well as CpGs inside and outside of PMDs

cd ${SLURM_SUBMIT_DIR}

species=$(basename $(dirname ${IN}));
if [ $species == 'Human' ]
then
  bedsizes=hg19_chroms.bed
elif [ $species == 'Mouse' ]
then
  bedsizes=mm10_chroms.bed
elif [ $species == 'Cow' ]
then
  bedsizes=bosTau8_chroms.bed
elif [ $species == 'Horse' ]
then
  bedsizes=equCab2_chroms.bed
elif [ $species == 'Rhesus' ]
then
  bedsizes=rheMac8_chroms.bed
elif [ $species == 'SquirrelMonkey' ]
then
  bedsizes=saiBol1_chroms.bed
else
  bedsizes=canFam3_chroms.bed
fi

printf "%s\t%s\t%s\n" $(basename ${IN}) ${species} ${bedsizes};

bedtools subtract -a /home/cmb-panasas2/decato/regions_of_interest/${bedsizes} -b ${IN}.pmd > ${IN}.anti-pmd;
roimethstat -v -L -o ${IN}.roimethstat ${IN}.pmd ${IN}.meth;
roimethstat -v -L -o ${IN}.anti-pmd.roimethstat ${IN}.anti-pmd ${IN}.meth;

## Mapsifter takes BED format methcounts files.
export LC_ALL=C;
awk '{print $1 "\t" $2 "\t" $2+1 "\t" $4 ":" $6 "\t" $5 "\t" $3}' ${IN}.meth | sort -k 1,1 -k 2,2g -k 3,3g -k 6,6 > ${IN}.bed;

bedtools intersect -wa -a ${IN}.bed -b ${IN}.pmd > ${IN}.meth.inpmd;
bedtools intersect -v -wa -a ${IN}.bed -b ${IN}.pmd > ${IN}.meth.outpmd; 

rm ${IN}.bed;
