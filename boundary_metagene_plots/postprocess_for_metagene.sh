#!/bin/bash

for i in $(find . -name "*.binnedroi"); do awk '{split($4,a,":"); split(a[1],b,"/"); print b[1] "\t" b[2] "\t" a[3] "\t" a[4] "\t" $5}' ${i}; done > PMD_absolute_metagene
awk '{ switch(substr($3,1,2)) {
         case "lo":
           split($3,a,"lo"); 
           print a[2]-100 "\t" $0;
           break
         case "li":
           split($3,a,"li"); 
           print a[2]-50 "\t" $0;
           break
         case "ri":
           split($3,a,"ri"); 
           print a[2]+50 "\t" $0;
           break
         case "ro":
           split($3,a,"ro"); 
           print a[2]+100 "\t" $0;
           break
         default:
           print "default\t" substr($3,1,2);
           break
       }
}' PMD_absolute_metagene > PMD_absolute_metagene.forR;
grep "lacenta" PMD_absolute_metagene.forR > PMD_absolute_metagene_placenta.forR
