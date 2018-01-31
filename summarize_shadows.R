## Argument 1: the "pmd_shadow_depths" output file from summarize_shadows.sh
## Argument 2: The output species name

#!/usr/bin/Rscript
args = commandArgs(trailingOnly=TRUE)
if (length(args)!=2) {
    stop(paste("Must specify <Shadow_statistics> <Species>",
                            sep=""), call.=FALSE)
}

data<-read.table(args[1])

pdf(paste(args[2],"pmd_shadows.pdf",sep="_"))
barplot(data$V4,names.arg=data$V1,las=2,cex.names=0.5,ylab="%mCpG(in intersection - out of union)")
dev.off()


