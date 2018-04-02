#!/bin/bash
#SBATCH -J do-roimethstat-inoutunion
#SBATCH --partition cmb
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=5GB 
#SBATCH --time=100:00:00

cd ${SLURM_SUBMIT_DIR}

/home/cmb-panasas2/decato/bin/methpipe/bin/roimethstat -L -o ${IN}.inPMDs.roimethstat ${UNION} ${IN}
/home/cmb-panasas2/decato/bin/methpipe/bin/roimethstat -L -o ${IN}.outPMDs.roimethstat ${DIFFERENCE} ${IN}

#/home/cmb-panasas2/decato/bin/methpipe/bin/roimethstat -L -o ${IN}.pmds $(dirname ${IN})/$(basename ${IN} .meth).pmd ${IN}
