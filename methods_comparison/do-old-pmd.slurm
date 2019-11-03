#!/bin/bash -l
#SBATCH -J do-old-pmd
#SBATCH --partition cmb
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=8GB 
#SBATCH --time 24:00:00

cd ${SLURM_SUBMIT_DIR}
base=$(basename ${IN} .meth);
directory=$(dirname ${IN});

/usr/bin/time -v /home/cmb-panasas2/decato/bin/old_methpipe/methpipe/bin/pmd -v -b 1000 -i 1000  -o ${directory}/${base}.oldpmd ${IN}.autosomes


