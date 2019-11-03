#!/bin/bash
#SBATCH -J dopairwise-pmd-intersect
#SBATCH --partition cmb
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=10GB 
#SBATCH --time=100:00:00

cd ${SLURM_SUBMIT_DIR}

bn=$(basename ${IN});

for i in $(grep "Human" pmd_samplenames); do
  bedtools intersect -a ${IN}.pmd -b ${i}.pmd | sort -k 1,1 -k 2,2g -k 3,3g > ${bn}.cur_regions;
  roimethstat -v -L -o ${bn}_self.roi ${bn}.cur_regions ${IN}.meth
  roimethstat -v -L -o ${bn}_$(basename ${i}).roi ${bn}.cur_regions ${i}.meth
  awk '{print $1 ":" $2 "-" $3 "\t" $5}' ${bn}_self.roi | sort -k 1b,1 > ${bn}_self.tojoin;
  awk '{print $1 ":" $2 "-" $3 "\t" $5}' ${bn}_$(basename ${i}).roi | sort -k 1b,1 > ${bn}_$(basename ${i}).tojoin;
  join ${bn}_self.tojoin ${bn}_$(basename ${i}).tojoin > ${bn}_$(basename ${i}).joined;
  rm ${bn}*tojoin ${bn}*roi ${bn}*cur_regions;
done

#/home/cmb-panasas2/decato/bin/methpipe/bin/roimethstat -L -o ${IN}.pmds $(dirname ${IN})/$(basename ${IN} .meth).pmd ${IN}
