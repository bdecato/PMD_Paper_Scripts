#!/bin/bash -l
#SBATCH -J do-roimethstat-boundaries
#SBATCH --partition cmb
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=5GB 
#SBATCH --time 100:00:00

cd ${SLURM_SUBMIT_DIR}

/home/cmb-panasas2/decato/bin/methpipe/bin/roimethstat -L -o ${LL}.roimethstat ${LL} $(dirname ${LL})/$(basename ${LL} .pmd.ll).meth
/home/cmb-panasas2/decato/bin/methpipe/bin/roimethstat -L -o ${LR}.roimethstat ${LR} $(dirname ${LR})/$(basename ${LR} .pmd.lr).meth
/home/cmb-panasas2/decato/bin/methpipe/bin/roimethstat -L -o ${RL}.roimethstat ${RL} $(dirname ${RL})/$(basename ${RL} .pmd.rl).meth
/home/cmb-panasas2/decato/bin/methpipe/bin/roimethstat -L -o ${RR}.roimethstat ${RR} $(dirname ${RR})/$(basename ${RR} .pmd.rr).meth
