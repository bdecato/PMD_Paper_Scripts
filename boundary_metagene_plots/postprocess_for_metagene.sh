#!/bin/bash

for i in $(find . -name "*.meth.roimethstat"); do awk '{split($4,a,":"); print a[3] "\t" $5}' ${i}; done > PMD_absolute_metagene
awk '{ switch(substr($1,1,2)) {
         case "lo":
           split($1,a,"lo"); 
           print a[2]-100 "\t" $2;
           break
         case "li":
           split($1,a,"li"); 
           print a[2]-50 "\t" $2;
           break
         case "ri":
           split($1,a,"ri"); 
           print a[2]+50 "\t" $2;
           break
         case "ro":
           split($1,a,"ro"); 
           print a[2]+100 "\t" $2;
           break
         default:
           print "default\t" substr($1,1,2);
           break
       }
}' PMD_absolute_metagene > PMD_absolute_metagene.forR;

for i in $(find . -name "*.meth.roimethstat"); do awk '{split($4,a,":"); print a[3] "\t" a[4]}' ${i}; done > PMD_absolute_metagene_density
awk '{ switch(substr($1,1,2)) {
         case "lo":
           split($1,a,"lo"); 
           print a[2]-100 "\t" $2;
           break
         case "li":
           split($1,a,"li"); 
           print a[2]-50 "\t" $2;
           break
         case "ri":
           split($1,a,"ri"); 
           print a[2]+50 "\t" $2;
           break
         case "ro":
           split($1,a,"ro"); 
           print a[2]+100 "\t" $2;
           break
         default:
           print "default\t" substr($1,1,2);
           break
       }
}' PMD_absolute_metagene_density > PMD_absolute_metagene_density.forR;

