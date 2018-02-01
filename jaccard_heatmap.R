## One argument: a matrix of pairwise Jaccard index values produced by pairwise-jaccard.sh.
#!/usr/bin/Rscript

library(pheatmap)
args = commandArgs(trailingOnly=TRUE)
if (length(args)!=1) {
    stop(paste("Must specify <inputfile>",
                            sep=""), call.=FALSE)
}

data<-read.table(args[1],header=TRUE)

diag(data)<-NA;
output<-paste(args[1],"-heatmap.pdf",sep="")
pdf(output,onefile=FALSE)
pheatmap(data,fontsize=4)
dev.off()
