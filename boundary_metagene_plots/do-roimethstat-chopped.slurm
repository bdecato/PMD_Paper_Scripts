#!/bin/bash -l
#SBATCH -J do-roimethstat-chopped
#SBATCH --partition cmb
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=5GB 
#SBATCH --time 100:00:00

cd ${SLURM_SUBMIT_DIR}

/home/cmb-panasas2/decato/bin/methpipe/bin/roimethstat -L -o ${IN}.roimethstat ${REF} ${IN}

