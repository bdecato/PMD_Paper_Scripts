
## Argument 1: PMD_absolute_metagene.forR
## Argument 2: PMD_absolute_metagene_placenta.forR

#!/usr/bin/Rscript
library(dplyr)
library(ggplot2)

args = commandArgs(trailingOnly=TRUE)
if (length(args)!=2) {
    stop(paste("Must specify 2 input files",
                            sep=""), call.=FALSE)
}

data<-read.table(args[1])
data$V7<-paste(data$V1,data$V2,sep="")
pdf("boundary_metagene_species.pdf")
x %>% group_by(V7) %>% mutate(mean_density=mean(V5)) %>% ggplot(aes(factor(V1),V6))+geom_boxplot(aes(fill=mean_density,color=mean_density),outlier.size=0.5)+scale_fill_gradient(low="blue",high="red")+facet_wrap(~V2,ncol=1) + theme(axis.text.x=element_text(angle=90,hjust=1), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_line(colour="black"))
dev.off()

data<-read.table(args[2])
pdf("boundary_metagene_all.pdf")
data %>% group_by(V1) %>% mutate(mean_density=mean(V5)) %>% ggplot(aes(factor(V1),V6))+geom_boxplot(aes(fill=mean_density,color=mean_density),outlier.size=0.5)+scale_fill_gradient(low="blue",high="red") + theme(axis.text.x=element_text(angle=90,hjust=1), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_line(colour="black"))
dev.off()

# Note: these plots need some cleaning up via mirroring.
