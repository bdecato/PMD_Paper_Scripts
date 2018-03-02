## Argument 1: output from gene_transcription_direction.sh 
#!/usr/bin/Rscript

args = commandArgs(trailingOnly=TRUE)
if (length(args)!=1) {
    stop(paste("Must specify <transcription_direction_info>",
                            sep=""), call.=FALSE)
}

data<-read.table(args[1])

library(ggplot2)
y<-data[abs(data$V1)<500000,]
y$V1<-abs(y$V1)
pdf("gene_transcription_direction.pdf",useDingbats=FALSE)
ggplot(y,aes(x=V1,fill=V3))+geom_histogram(bins=200)+theme(text = element_text(size=10), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_line(colour="black"),strip.background=element_rect(fill="white"))
dev.off()
