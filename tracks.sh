#!/bin/bash
if [ $# == 2 ]
then
  NAME=$1
  GENOME=$2
  METH=${NAME}.meth
  PMD=${NAME}.pmd
  HMR=${NAME}.hmr
  EMISSIONS=${NAME}.emissions

  if [ ! -e $GENOME ]
  then
    echo "[Chromosome sizes file not found!] $GENOME"
    exit 1
  fi

  if [ ! -z $METH ]
  then
    echo "[$METH found.]"
    FORMAT=$(head -n 1 $METH | awk '{if($6=="+"||$6=="-")print 1;else print 0}')
    if [ $FORMAT -eq 1 ]
    then
      # 1 for BED format; 0 for methcounts format
      if [ ! -e $METH.bw ]
      then
        echo "Generating $METH.bw..."
        cut -f 1-3,5 ${METH} | awk 'BEGIN{pc=0;ps=0;pe=0}{if(!($1==pc&&$2==ps&&$3==pe)){print}pc=$1;ps=$2;pe=$3}' > temp$$
        bedGraphToBigWig temp$$ ${GENOME} ${METH}.bw
      fi

      if [ ! -e $NAME.read.bw ]
      then
        echo "Generating $NAME.read.bw..."
        awk -F "[\t,:]+" 'BEGIN{OFS="\t"}{print $1,$2,$3,$5}' ${METH} | awk 'BEGIN{pc=0;ps=0;pe=0}{if(!($1==pc&&$2==ps&&$3==pe)){print}pc=$1;ps=$2;pe=$3}' > temp$$
        bedGraphToBigWig temp$$ ${GENOME} ${NAME}.read.bw
      fi

    else
      if [ ! -e $METH.bw ]
      then
        echo "Generating $METH.bw..."
        awk 'BEGIN{OFS="\t"}{print $1,$2,$2+1,$5}' ${METH} | awk 'BEGIN{pc=0;ps=0;pe=0}{if(!($1==pc&&$2==ps&&$3==pe)){print}pc=$1;ps=$2;pe=$3}' > temp$$
        bedGraphToBigWig temp$$ ${GENOME} ${METH}.bw
      fi

      if [ ! -e $NAME.read.bw ]
      then
        echo "Generating $NAME.read.bw..."
        awk 'BEGIN{OFS="\t"}{print $1,$2,$2+1,$6}' ${METH} | awk 'BEGIN{pc=0;ps=0;pe=0}{if(!($1==pc&&$2==ps&&$3==pe)){print}pc=$1;ps=$2;pe=$3}' > temp$$
        bedGraphToBigWig temp$$ ${GENOME} ${NAME}.read.bw
      fi
    fi
  fi

  if [ ! -z $PMD ]
  then
    echo "[$PMD found.]"
    if [ ! -e $PMD.bb ]
    then
      echo "Generating $PMD.bb..."
      awk 'BEGIN{OFS="\t"}{print $1,$2,$3,$4,0,$6}' ${PMD} | sort -k 1,1 -k 2,2n > temp$$
      bedToBigBed temp$$ ${GENOME} ${PMD}.bb
      echo "Generating boundary tracks."
      awk '{split($4,a,":"); if(a[3]>39){print $1 "\t" $2 "\t" $2+1 "\t" a[2]}; if(a[5]>39){print $1 "\t" $3-1 "\t" $3 "\t" a[4]};}' ${PMD} > ${PMD}.goodbounds;
      bedGraphToBigWig ${PMD}.goodbounds ${GENOME} ${PMD}.goodbounds.bw
    fi
  fi

  if [ ! -z $EMISSIONS ]
  then
    echo "[$EMISSIONS found.]"
    if [ ! -e $EMISSIONS.bw ]
    then
      echo "Generating $EMISSIONS.bw..."
      bedGraphToBigWig $EMISSIONS ${GENOME} $EMISSIONS.bw
    fi
  fi

  if [ ! -z $HMR ]
  then
    echo "[$HMR found.]"
    if [ ! -e $HMR.bb ]
    then
      echo "Generating $HMR.bb..."
      awk 'BEGIN{OFS="\t"}{print $1,$2,$3,$4,0,$6}' ${HMR} | sort -k 1,1 -k 2,2n > temp$$
      bedToBigBed temp$$ ${GENOME} ${HMR}.bb
    fi
  fi

  rm temp$$

else
  echo "Usage: $0 <name> <reference genome> <path_to_chroms_size>"
  echo "Generate UCSC genome browser tracks from given data name."
  echo "Will search for <name>.meth and <name>.pmd."
  echo "Example: sh $0 Human_HSC hg19"
  echo " "
fi
