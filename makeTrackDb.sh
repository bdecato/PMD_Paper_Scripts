#!/bin/bash

priority=0;
minimumsize=345;
for i in *.pmd.bb; do
  actualsize=$(wc -c <"$i")
  
  if [[ $actualsize -ge $minimumsize ]]; then
    printf "  track %s\n  visibility dense\n  priority %s\n  longLabel %s\n  shortLabel %s\n  type bigBed\n  color 0,0,0\n  bigDataUrl %s\n\n" $(basename ${i} .pmd.bb) ${priority}  $(basename ${i} .pmd.bb) $(basename ${i} .pmd.bb) ${i};
    let priority="${priority}+1";
  fi

  if [ -f $(basename ${i} .pmd.bb).meth.bw ]; then
    printf "  track %s\n  visibility full\n  priority %s\n  longLabel %s\n  shortLabel %s\n  type bigWig\n  color 197,172,24\n  autoScale off\n  viewLimits 0:1\n  yLineOnOff on\n  gridDefault on\n  windowingFunction mean\n  maxHeightPixels 24:24:24\n  bigDataUrl %s\n\n" $(basename ${i} .pmd.bb).meth.bw ${priority}  $(basename ${i} .pmd.bb).meth.bw $(basename ${i} .pmd.bb).meth.bw $(basename ${i} .pmd.bb).meth.bw;
    let priority="${priority}+1";
  fi

  if [ -f $(basename ${i} .pmd.bb).read.bw ]; then
    printf "  track %s\n  visibility full\n  priority %s\n  longLabel %s\n  shortLabel %s\n  type bigWig\n  color 0,0,0\n  autoScale off\n  viewLimits 0:1\n  yLineOnOff on\n  gridDefault on\n  windowingFunction mean\n  maxHeightPixels 24:24:24\n  bigDataUrl %s\n\n" $(basename ${i} .pmd.bb).read.bw ${priority}  $(basename ${i} .pmd.bb).read.bw $(basename ${i} .pmd.bb).read.bw $(basename ${i} .pmd.bb).meth.bw;
    let priority="${priority}+1";
  fi
done > trackDb.txt

