# Needs updating, but I ran this on each subdirectory of a trackhub to get its trackDb.txt file. It assumes a pmd.bb file for each parent directory that can be empty and adds its corresponding methylation, coverage, HMR, boundary, and posterior tracks to the trackDb file.
#!/bin/bash

minimum_size=345;
priority=0;
for i in *.pmd.bb; do
  echo ${i} | awk -F'[-_]' '{print $1 "-" $2}'
done | sort | uniq > unique_parent_names;

for i in $(cat unique_parent_names); do
  printf "track %s\nsuperTrack on\nshortLabel %s\nlongLabel %s\npriority %s\ngroup %s\nvisibility full\n\n" ${i} ${i} ${i} ${priority} ${i};
  let priority="${priority}+1";

  for j in ${i}*.pmd.bb; do
    if [[ $actualsize -ge $minimumsize ]]; then
      printf "  track %s\n  parent %s\n  visibility dense\n  priority %s\n  longLabel %s\n  shortLabel %s\n  type bigBed\n  color 0,0,0\n  bigDataUrl %s\n\n" $(basename ${j} .pmd.bb) ${i} ${priority} $(basename ${j} .pmd.bb) $(basename ${j} .pmd.bb) ${j};
      let priority="${priority}+1";
    fi

    if [ -f $(basename ${j} .pmd.bb).hmr.bb ]; then
      printf "  track %s\n  parent %s\n  visibility dense\n  priority %s\n  longLabel %s\n  shortLabel %s\n  type bigBed\n  color 200,0,200\n  bigDataUrl %s\n\n" $(basename ${j} .pmd.bb).hmr.bb ${i} ${priority}  $(basename ${j} .pmd.bb).hmr.bb $(basename ${j} .pmd.bb).hmr.bb $(basename ${j} .pmd.bb).hmr.bb;
      let priority="${priority}+1";
    fi

    if [ -f $(basename ${j} .pmd.bb).emissions.bw ]; then
      printf "  track %s\n  parent %s\n  visibility hide\n  priority %s\n  longLabel %s\n  shortLabel %s\n  type bigWig\n  color 200,50,100\n  autoScale off\n  viewLimits 0:1\n  yLineOnOff on\n  gridDefault on\n  windowingFunction mean\n  maxHeightPixels 24:24:24\n  bigDataUrl %s\n\n" $(basename ${j} .pmd.bb).emissions.bw ${i} ${priority}  $(basename ${j} .pmd.bb).emissions.bw $(basename ${j} .pmd.bb).emissions.bw $(basename ${j} .pmd.bb).emissions.bw;
      let priority="${priority}+1";
    fi

    if [ -f $(basename ${j} .pmd.bb).goodboundaries.bw ]; then
      printf "  track %s\n  parent %s\n  visibility hide\n  priority %s\n  longLabel %s\n  shortLabel %s\n  type bigWig\n  color 50,200,50\n  autoScale off\n  viewLimits 0:1\n  yLineOnOff on\n  gridDefault on\n  windowingFunction maximum\n  maxHeightPixels 24:24:24\n  bigDataUrl %s\n\n" $(basename ${j} .pmd.bb).goodboundaries.bw ${i} ${priority}  $(basename ${j} .pmd.bb).goodboundaries.bw $(basename ${j} .pmd.bb).goodboundaries.bw $(basename ${j} .pmd.bb).goodboundaries.bw;
      let priority="${priority}+1";
    fi

    if [ -f $(basename ${j} .pmd.bb).meth.bw ]; then
      printf "  track %s\n  parent %s\n  visibility full\n  priority %s\n  longLabel %s\n  shortLabel %s\n  type bigWig\n  color 197,172,24\n  autoScale off\n  viewLimits 0:1\n  yLineOnOff on\n  gridDefault on\n  windowingFunction mean\n  maxHeightPixels 24:24:24\n  bigDataUrl %s\n\n" $(basename ${j} .pmd.bb).meth.bw ${i} ${priority}  $(basename ${j} .pmd.bb).meth.bw $(basename ${j} .pmd.bb).meth.bw $(basename ${j} .pmd.bb).meth.bw;
      let priority="${priority}+1";
    fi

    if [ -f $(basename ${j} .pmd.bb).read.bw ]; then
      printf "  track %s\n  parent %s\n  visibility hide\n  priority %s\n  longLabel %s\n  shortLabel %s\n  type bigWig\n  color 0,0,0\n  autoScale off\n  viewLimits 0:1\n  yLineOnOff on\n  gridDefault on\n  windowingFunction mean\n  maxHeightPixels 24:24:24\n  bigDataUrl %s\n\n" $(basename ${j} .pmd.bb).read.bw ${i} ${priority}  $(basename ${j} .pmd.bb).read.bw $(basename ${j} .pmd.bb).read.bw $(basename ${j} .pmd.bb).read.bw;
      let priority="${priority}+1";
    fi
  done
done > trackDb.txt

