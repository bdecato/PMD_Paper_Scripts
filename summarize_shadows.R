## Argument 1: the "pmd_shadow_Depths" output file from summarize_shadows.sh

#!/usr/bin/Rscript
args = commandArgs(trailingOnly=TRUE)
if (length(args)!=1) {
    stop(paste("Must specify <out-in-pmd-statistics>",
                            sep=""), call.=FALSE)
}

data<-read.table(args[1])

pdf("pmd_shadows.pdf")
barplot(data$V4,names.arg=data$V1,las=2,cex.names=0.5,ylab="%mCpG(in intersection - out of union)")
dev.off()


