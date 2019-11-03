# repeat_list is a list of absolute paths to the methcounts files of the samples you are interested in exploring PMDs in. This script adequately supports all 7 species in the study. It assumes PMD_Paper_Scripts is in your PATH.
for i in $(cat repeat_list); do
  species=$(basename $(dirname ${i}));
  case $species in
    Human )
      sbatch --job-name=${i}.repeats --output ${i}-repeats.out --error  ${i}-repeats.error --export=IN=${i},REFERENCE=hg19,REPEATS=/home/cmb-06/as/bdecato/Decato-PMD-Analysis/rmsk/hg19_rmsk.bed,SIZE=2881033286 do-repeat-preprocessing.slurm; sleep 0.1 ;;
    Mouse )
      sbatch --job-name=${i}.repeats --output ${i}-repeats.out --error  ${i}-repeats.error --export=IN=${i},REFERENCE=mm10,REPEATS=/home/cmb-06/as/bdecato/Decato-PMD-Analysis/rmsk/mm10_rmsk.bed,SIZE=2462745373 do-repeat-preprocessing.slurm; sleep 0.1 ;;
    Dog )
      sbatch --job-name=${i}.repeats --output ${i}-repeats.out --error  ${i}-repeats.error --export=IN=${i},REFERENCE=canFam3,REPEATS=/home/cmb-06/as/bdecato/Decato-PMD-Analysis/rmsk/canFam3_rmsk.bed,SIZE=2203764842 do-repeat-preprocessing.slurm; sleep 0.1 ;;
    Rhesus )
      sbatch --job-name=${i}.repeats --output ${i}-repeats.out --error  ${i}-repeats.error --export=IN=${i},REFERENCE=rheMac8,REPEATS=/home/cmb-06/as/bdecato/Decato-PMD-Analysis/rmsk/rheMac8_rmsk.bed,SIZE=2675059068 do-repeat-preprocessing.slurm; sleep 0.1 ;;
    SquirrelMonkey )
      sbatch --job-name=${i}.repeats --output ${i}-repeats.out --error  ${i}-repeats.error --export=IN=${i},REFERENCE=saiBol1,REPEATS=/home/cmb-06/as/bdecato/Decato-PMD-Analysis/rmsk/saiBol1_rmsk.bed,SIZE=2608572064 do-repeat-preprocessing.slurm; sleep 0.1 ;;
    Cow )
      sbatch --job-name=${i}.repeats --output ${i}-repeats.out --error  ${i}-repeats.error --export=IN=${i},REFERENCE=bosTau8,REPEATS=/home/cmb-06/as/bdecato/Decato-PMD-Analysis/rmsk/bosTau8_rmsk.bed,SIZE=2512082506 do-repeat-preprocessing.slurm; sleep 0.1 ;;
    Horse )
      sbatch --job-name=${i}.repeats --output ${i}-repeats.out --error  ${i}-repeats.error --export=IN=${i},REFERENCE=equCab2,REPEATS=/home/cmb-06/as/bdecato/Decato-PMD-Analysis/rmsk/equCab2_rmsk.bed,SIZE=2242939370 do-repeat-preprocessing.slurm; sleep 0.1 ;;
  esac
done

