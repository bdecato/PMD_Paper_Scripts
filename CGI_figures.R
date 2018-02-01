## Argument 1: the "island_summary" output file (joined to manifest) from CGI_summarize.sh

#!/usr/bin/Rscript
library(ggplot2)
args = commandArgs(trailingOnly=TRUE)
if (length(args)!=2) {
    stop(paste("Must specify <island_summary> <output_prefix>",
                            sep=""), call.=FALSE)
}

data<-read.table(args[1])

data$combo<-paste(data$V3,data$V4,sep="+")

outputfile<-paste(args[2],"-cgidensities.pdf",sep="");
pdf(outputfile,useDingbats=FALSE);
ggplot(data=data,aes(x=V10,group=V9,colour=V9))+geom_density()+facet_wrap(~combo,ncol=4)+theme(text = element_text(size=10), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_line(colour="black"),strip.background=element_rect(fill="white"))
dev.off();

median(data[data$combo=="Healthy+Primary",]$V10)
median(data[data$combo=="Healthy+Cultured",]$V10)
median(data[data$combo=="Cancer+Primary",]$V10)
median(data[data$combo=="Cancer+Cultured",]$V10)
median(data[data$combo=="Healthy+Primary"&data$V9=="in",]$V10)
median(data[data$combo=="Healthy+Cultured"&data$V9=="in",]$V10)
median(data[data$combo=="Cancer+Primary"&data$V9=="in",]$V10)
median(data[data$combo=="Cancer+Cultured"&data$V9=="in",]$V10)
median(data[data$combo=="Healthy+Primary"&data$V9=="out",]$V10)
median(data[data$combo=="Healthy+Cultured"&data$V9=="out",]$V10)
median(data[data$combo=="Cancer+Primary"&data$V9=="out",]$V10)
median(data[data$combo=="Cancer+Cultured"&data$V9=="out",]$V10)
library(pheatmap)

# I manually entered the median values into this matrix.
x<-matrix(c(1.1,5.7,16.6,17.9,3.9,12.4,49.2,46.1,1.0,3.9,9.9,11.7),nrow=3,ncol=4,byrow=TRUE)
pdf("~/Dropbox/BenDecato/PMD-identification/figures/CGI_median_methylation.pdf",onefile=FALSE,useDingbats=FALSE)
pheatmap(x,cluster_rows=FALSE,cluster_cols=FALSE,display_numbers=TRUE,fontsize_number=24)
dev.off()



