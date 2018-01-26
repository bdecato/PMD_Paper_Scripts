#!/usr/bin/Rscript

library(pheatmap)
args = commandArgs(trailingOnly=TRUE)
if (length(args)!=1) {
    stop(paste("Must specify <inputfile>",
                            sep=""), call.=FALSE)
}

data<-read.table(args[1],header=TRUE)

diag(data)<-NA;
output<-paste("~/Dropbox/BenDecato/PMD-identification/figures/",args[1],"-heatmap.pdf",sep="")
pdf(output,onefile=FALSE)
pheatmap(data,fontsize=4)
dev.off()
