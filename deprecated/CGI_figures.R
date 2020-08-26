## Argument 1: the "island_summary" output file (joined to manifest) from CGI_summarize.sh

#!/usr/bin/Rscript
library(ggplot2)
args = commandArgs(trailingOnly=TRUE)
if (length(args)!=1) {
    stop(paste("Must specify <island_summary>",
                            sep=""), call.=FALSE)
}

data<-read.table(args[1])

data$combo<-paste(data$V3,data$V4,sep="+")

outputfile<-"Context_cgidensities.pdf";
pdf(outputfile,useDingbats=FALSE);
ggplot(data=data,aes(x=V10,group=V9,colour=V9))+geom_density()+facet_wrap(~combo,ncol=4)+theme(text = element_text(size=10), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_line(colour="black"),strip.background=element_rect(fill="white"))
dev.off();

hpa<-median(data[data$combo=="Healthy+Primary",]$V10)
hca<-median(data[data$combo=="Healthy+Cultured",]$V10)
cpa<-median(data[data$combo=="Cancer+Primary",]$V10)
cca<-median(data[data$combo=="Cancer+Cultured",]$V10)
hpi<-median(data[data$combo=="Healthy+Primary"&data$V9=="in",]$V10)
hci<-median(data[data$combo=="Healthy+Cultured"&data$V9=="in",]$V10)
cpi<-median(data[data$combo=="Cancer+Primary"&data$V9=="in",]$V10)
cci<-median(data[data$combo=="Cancer+Cultured"&data$V9=="in",]$V10)
hpo<-median(data[data$combo=="Healthy+Primary"&data$V9=="out",]$V10)
hco<-median(data[data$combo=="Healthy+Cultured"&data$V9=="out",]$V10)
cpo<-median(data[data$combo=="Cancer+Primary"&data$V9=="out",]$V10)
cco<-median(data[data$combo=="Cancer+Cultured"&data$V9=="out",]$V10)
library(pheatmap)

# I manually entered the median values into this matrix.
x<-matrix(c(hpa,hca,cpa,cca,hpi,hci,cpi,cci,hpo,hco,cpo,cco),nrow=3,ncol=4,byrow=TRUE)
pdf("CGI_median_methylation.pdf",onefile=FALSE,useDingbats=FALSE)
pheatmap(x,cluster_rows=FALSE,cluster_cols=FALSE,display_numbers=TRUE,fontsize_number=24)
dev.off()



