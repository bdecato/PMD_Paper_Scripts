#!/bin/bash -l
#SBATCH -J do-methylseekr
#SBATCH --partition cmb
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=8GB 
#SBATCH --time 24:00:00

cd ${SLURM_SUBMIT_DIR}

/usr/bin/time -v /home/cmb-panasas2/decato/bin/anaconda2/bin/Rscript /home/cmb-panasas2/decato/bin/PMD_Paper_Scripts/run_methylseekr.R ${IN}
