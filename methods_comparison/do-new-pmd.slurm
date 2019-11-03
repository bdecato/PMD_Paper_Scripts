#!/bin/bash -l
#SBATCH -J do-new-pmd
#SBATCH --partition cmb
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=8GB 
#SBATCH --time 24:00:00

cd ${SLURM_SUBMIT_DIR}
base=$(basename ${IN} .meth);
directory=$(dirname ${IN});


/usr/bin/time -v /home/cmb-panasas2/decato/bin/methpipe-pmd-dev/bin/pmd -v -b 1000 -i 1000 -o ${directory}/${base}.newpmd ${IN}.autosomes

#/home/cmb-panasas2/decato/bin/methpipe-pmd-dev/bin/hmr -v -x ${directory}/${base}.emissions -p ${directory}/${base}.hmrparams -i 1000 -o ${directory}/${base}.hmr ${IN}.autosomes

