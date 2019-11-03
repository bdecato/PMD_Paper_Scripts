## Argument 1: methylseekr-formatted methcounts file with no sex chromosomes
## Output: Resulting PMD segmentation

#!/usr/bin/Rscript
args = commandArgs(trailingOnly=TRUE)
if (length(args)!=1) {
    stop(paste("Must specify <inputdata>",
                            sep=""), call.=FALSE)
}

library(BSgenome)
library("BSgenome.Hsapiens.UCSC.hg19")
#library("BSgenome.Mmusculus.UCSC.mm10")
library(MethylSeekR)

#sLengths=seqlengths(Mmusculus)
sLengths=seqlengths(Hsapiens)
meth.gr<-readMethylome(FileName=args[1],seqLengths=sLengths)
outputfile=paste(args[1],".methylseekR.pmd",sep="")
PMDsegments.gr<-segmentPMDs(m=meth.gr,chr.sel="chr19",seqLengths=sLengths)
savePMDSegments(PMDs=PMDsegments.gr, TableFilename=outputfile)
