## Argument 1: the "dNdS_summary" output file from mutation_rates.sh

#!/usr/bin/Rscript
library(ggplot2)
args = commandArgs(trailingOnly=TRUE)
if (length(args)!=1) {
    stop(paste("Must specify <dNdS_summary>",
                            sep=""), call.=FALSE)
}

data<-read.table(args[1])
data$dNdS<-data$V3/data$V4;
pdf("mutation_rates.pdf")
ggplot(data=data,aes(x=dNdS,group=V5,col=V5))+geom_density()+facet_wrap(~V4)+xlab("log(dN/dS)")+theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_line(colour="black"))
dev.off()
