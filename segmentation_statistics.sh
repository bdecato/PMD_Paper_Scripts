## Script to get summary statistics from PMD segmentations and methcounts
## files organized into folders by species with .error files that contain
## the verbose output of the PMD program for binsize information.
#!/bin/bash

for i in $(find . -name "*.pmd"); do 
  species=$(basename $(dirname ${i}));
  printf "%s\t%s\t" $(basename ${i} .pmd) ${species};
  awk -v species=${species} 'BEGIN{total=0; count=0}{total+=$3-$2;count++}END{
    switch(species) {
        case "Human":
		  print total/3095693983 "\t" total/count "\t" count
          break;
        case "Mouse":
		  print total/2730871774 "\t" total/count "\t" count
          break;
        case "Dog":
		  print total/2410976875 "\t" total/count "\t" count
          break;
        case "Rhesus":
		  print total/2835979954 "\t" total/count "\t" count
          break;
        case "SquirrelMonkey":
		  print total/2608572064 "\t" total/count "\t" count
          break;
        case "Cow":
		  print total/2660922743 "\t" total/count "\t" count
          break;
        case "Horse":
		  print total/2484532062 "\t" total/count "\t" count
          break;
      }
  }' ${i} | tr "\n" "\t";

  awk 'BEGIN{total=0; count_cpgs=0; total_cpgs=0;}{if($6>0){count_cpgs++}; total_cpgs++; total+=$6; }END{print count_cpgs/total_cpgs "\t" total/total_cpgs}' $(dirname ${i})/$(basename ${i} .pmd).meth | tr "\n" "\t";

  # Grab the binsize
  grep "READING IN AT" $(dirname ${i})/$(basename ${i} .pmd).meth.error | awk '{split($6,a,"]"); print a[1]}';
done
