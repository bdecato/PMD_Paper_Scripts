###################################################################
## gridsearch_EPIC_PMDs.sh <array_methcounts> <wgbs_PMDs>  ##
###################################################################
# For a given array methcounts file (doesn't need to be padded)
# make a desert_sizes and bin_sizes file with the desired entries
# for a gridsearch and segment the sample into PMDs using those
# parameters.
# Afterward, make a jaccard index table with the analogous WGBS sample

for i in $(cat desert_sizes); do
  for j in $(cat bin_sizes); do
    /home/cmb-panasas2/decato/bin/methpipe-pmd-dev/bin/pmd -v -p $(dirname $1)/$(basename $1 .meth)_${i}_${j}.params -f -i 1000 -d ${i} -b ${j} -o $(dirname $1)/$(basename $1 .meth)_${i}_${j}.pmd $1
  done
done

for i in $(cat desert_sizes); do
  printf "%s\t" ${i};
done > $1_jaccard_heatmap;
printf "\n" >> $1_jaccard_heatmap;
for i in $(cat bin_sizes); do
  printf "%s\t" ${i};
  for j in $(cat desert_sizes); do
    if [ -f $(basename $1 .meth)_${j}_${i}.pmd ]; then
      x=$(/home/cmb-panasas2/decato/bin/bedtools2/bin/bedtools jaccard -a $(dirname $1)/$(basename $1 .meth)_${j}_${i}.pmd -b $2 | tail -1 | awk '{print $3}');
      printf "%s\t" ${x};
    else
      printf "0\t";
    fi
  done
  printf "\n";
done >> $1_jaccard_heatmap




