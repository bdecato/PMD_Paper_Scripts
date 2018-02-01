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


