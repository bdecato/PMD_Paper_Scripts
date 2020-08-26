#!/bin/bash

for i in $(find . -maxdepth 3 -name "*.hmr"); do
  bedtools intersect -wa -a ${i} -b /home/cmb-panasas2/decato/regions_of_interest/hg19/hg19_TSS_with_CGIs.bed | awk '{print $1 "\t" int($2+(($3-$2)/2)) "\t" int($2+(($3-$2)/2)+1)}' > /staging/as/decato/roadmap_out/$(basename ${i}).tss_w_cgi;
  bedtools intersect -v -wa -a ${i} -b /home/cmb-panasas2/decato/regions_of_interest/hg19/hg19_TSS_with_CGIs.bed > temp;

  sbatch --job-name=${i}-tsswcgi --output=/staging/as/decato/roadmap_out/$(basename ${i}).tss_w_cgi.out --error=/staging/as/decato/roadmap_out/$(basename ${i}).tss_w_cgi.error --export=TSS=/staging/as/decato/roadmap_out/$(basename ${i}).tss_w_cgi,CPG=$(dirname ${i})/$(basename ${i} .hmr).meth /home/cmb-panasas2/decato/slurmbin/do-tsscpgplot.slurm ; sleep 0.1;

  bedtools intersect -wa -a temp -b /home/cmb-panasas2/decato/regions_of_interest/hg19/hg19_TSS_without_CGIs.bed | awk '{print $1 "\t" int($2+(($3-$2)/2)) "\t" int($2+(($3-$2)/2)+1)}' > /staging/as/decato/roadmap_out/$(basename ${i}).tss_without_cgi;
  bedtools intersect -v -wa -a temp -b /home/cmb-panasas2/decato/regions_of_interest/hg19/hg19_TSS_without_CGIs.bed > temp2;
  mv temp2 temp;

  sbatch --job-name=${i}-tsswocgi --output=/staging/as/decato/roadmap_out/$(basename ${i}).tss_wo_cgi.out --error=/staging/as/decato/roadmap_out/$(basename ${i}).tss_wo_cgi.error --export=TSS=/staging/as/decato/roadmap_out/$(basename ${i}).tss_without_cgi,CPG=$(dirname ${i})/$(basename ${i} .hmr).meth /home/cmb-panasas2/decato/slurmbin/do-tsscpgplot.slurm ; sleep 0.1;

  bedtools intersect -wa -a temp -b /home/cmb-panasas2/decato/regions_of_interest/hg19/hg19_TES.bed | awk '{print $1 "\t" int($2+(($3-$2)/2)) "\t" int($2+(($3-$2)/2)+1)}' > /staging/as/decato/roadmap_out/$(basename ${i}).tes;
  bedtools intersect -v -wa -a temp -b /home/cmb-panasas2/decato/regions_of_interest/hg19/hg19_TES.bed > temp2;
  mv temp2 temp;

  sbatch --job-name=${i}-tes --output=/staging/as/decato/roadmap_out/$(basename ${i}).tes.out --error=/staging/as/decato/roadmap_out/$(basename ${i}).tes.error --export=TSS=/staging/as/decato/roadmap_out/$(basename ${i}).tes,CPG=$(dirname ${i})/$(basename ${i} .hmr).meth /home/cmb-panasas2/decato/slurmbin/do-tsscpgplot.slurm ; sleep 0.1;

  bedtools intersect -wa -a temp -b /home/cmb-panasas2/decato/regions_of_interest/hg19/hg19_CDS.bed | awk '{print $1 "\t" int($2+(($3-$2)/2)) "\t" int($2+(($3-$2)/2)+1)}' > /staging/as/decato/roadmap_out/$(basename ${i}).cds;
  bedtools intersect -v -wa -a temp -b /home/cmb-panasas2/decato/regions_of_interest/hg19/hg19_CDS.bed > temp2;
  mv temp2 temp;

  sbatch --job-name=${i}-cds --output=/staging/as/decato/roadmap_out/$(basename ${i}).cds.out --error=/staging/as/decato/roadmap_out/$(basename ${i}).cds.error --export=TSS=/staging/as/decato/roadmap_out/$(basename ${i}).cds,CPG=$(dirname ${i})/$(basename ${i} .hmr).meth /home/cmb-panasas2/decato/slurmbin/do-tsscpgplot.slurm ; sleep 0.1;

  bedtools intersect -wa -a temp -b /home/cmb-panasas2/decato/regions_of_interest/hg19/hg19_cpgislands.bed | awk '{print $1 "\t" int($2+(($3-$2)/2)) "\t" int($2+(($3-$2)/2)+1)}' > /staging/as/decato/roadmap_out/$(basename ${i}).islands;
  bedtools intersect -v -wa -a temp -b /home/cmb-panasas2/decato/regions_of_interest/hg19/hg19_cpgislands.bed > temp2;
  mv temp2 temp;

  sbatch --job-name=${i}-islands --output=/staging/as/decato/roadmap_out/$(basename ${i}).islands.out --error=/staging/as/decato/roadmap_out/$(basename ${i}).islands.error --export=TSS=/staging/as/decato/roadmap_out/$(basename ${i}).islands,CPG=$(dirname ${i})/$(basename ${i} .hmr).meth /home/cmb-panasas2/decato/slurmbin/do-tsscpgplot.slurm ; sleep 0.1;

  bedtools intersect -wa -a temp -b /home/cmb-panasas2/decato/regions_of_interest/hg19/hg19_LINESINELTR.bed | awk '{print $1 "\t" int($2+(($3-$2)/2)) "\t" int($2+(($3-$2)/2)+1)}' > /staging/as/decato/roadmap_out/$(basename ${i}).repeats;
  bedtools intersect -v -wa -a temp -b /home/cmb-panasas2/decato/regions_of_interest/hg19/hg19_LINESINELTR.bed > temp2;
  mv temp2 temp;

  sbatch --job-name=${i}-repeats --output=/staging/as/decato/roadmap_out/$(basename ${i}).repeats.out --error=/staging/as/decato/roadmap_out/$(basename ${i}).repeats.error --export=TSS=/staging/as/decato/roadmap_out/$(basename ${i}).repeats,CPG=$(dirname ${i})/$(basename ${i} .hmr).meth /home/cmb-panasas2/decato/slurmbin/do-tsscpgplot.slurm ; sleep 0.1;

  mv temp /staging/as/decato/roadmap_out/$(basename ${i}).intergenic;

  sbatch --job-name=${i}-intergenic --output=/staging/as/decato/roadmap_out/$(basename ${i}).intergenic.out --error=/staging/as/decato/roadmap_out/$(basename ${i}).intergenic.error --export=TSS=/staging/as/decato/roadmap_out/$(basename ${i}).intergenic,CPG=$(dirname ${i})/$(basename ${i} .hmr).meth /home/cmb-panasas2/decato/slurmbin/do-tsscpgplot.slurm ; sleep 0.1;

done;
