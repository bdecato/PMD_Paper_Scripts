#!/bin/bash -l
#SBATCH -J do-liftover
#SBATCH --partition cmb
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=10GB 
#SBATCH --time 100:00:00

# Lifts a methcounts file from one assembly to another and
# calls PMDs/makes tracks in that new assembly.

cd ${SLURM_SUBMIT_DIR}

awk '{print $1 "\t" $2 "\t" $2+1 "\t" $1":"$2":"$2+1":"$3 "\t0\t" $3}' ${IN} > ${IN}.bed;

liftOver ${IN}.bed ${CHAINFILE} ${IN}.index ${IN}.unlifted

fast-liftover -i ${IN}.index -f ${IN} -t ${IN}_${NEWREF} -v

export LC_ALL=C; sort -k 1,1 -k 2,2g -k 3,3 ${IN}_${NEWREF} -o ${IN}_${NEWREF}.sorted

lift-filter -o ${IN}_${NEWREF} ${IN}_${NEWREF}.sorted -v

#pmd -v -p ${IN}_${NEWREF}.params -o ${IN}_${NEWREF}.pmd ${IN}_${NEWREF}
#tracks.sh ${IN}_${NEWREF} ${NEWREF}
#/home/cmb-panasas2/decato/bin/liftOver ${IN}_cpg.bed /home/cmb-panasas2/decato/chainfiles/hg19ToHg38.over.chain ${IN}-hg38.index ${IN}-hg38.unlifted
#echo "done making index"
#/home/cmb-panasas2/decato/bin/methpipe/src/utils/fast-liftover -i ${IN}-hg38.index -f ${IN} -t $(dirname ${IN})/$(basename ${IN} .meth)_hg38.meth -v

