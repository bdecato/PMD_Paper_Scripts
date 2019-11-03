#!/bin/bash
#SBATCH -J do-repeat-analysis
#SBATCH --partition cmb
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=5GB 
#SBATCH --time=100:00:00

cd ${SLURM_SUBMIT_DIR}

#roimethstat -L -o ${IN}.repeatroi ${REPEATS} ${IN}

#repeats_in_PMDs.sh ${REFERENCE} ${SIZE} $(dirname ${IN})/$(basename ${IN} .meth).pmd ${REPEATS}

repeats_at_boundaries.sh ${REFERENCE} ${SIZE} 5000 $(dirname ${IN})/$(basename ${IN} .meth).pmd ${REPEATS}
#/home/cmb-panasas2/decato/bin/methpipe/bin/roimethstat -L -o ${IN}.pmds $(dirname ${IN})/$(basename ${IN} .meth).pmd ${IN}
