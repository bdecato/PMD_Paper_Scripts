## Argument 1: the "Out_In_PMD_Statistics.joined" output file from methylation_in_out.sh

#!/usr/bin/Rscript
library(ggplot2)
args = commandArgs(trailingOnly=TRUE)
if (length(args)!=1) {
    stop(paste("Must specify <out-in-pmd-statistics>",
                            sep=""), call.=FALSE)
}

data<-read.table(args[1])

pdf("meth_in_out_vioplots_allsamples.pdf")
ggplot(data=data,aes(x=V8,y=V12,group=V8,fill=V11/V12))+facet_wrap(~V1)+geom_violin(draw_quantiles=c(0.25,0.5,0.75))+xlab("Sample")+ylab("%mCpG")+theme(text = element_text(size=5), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_line(colour="black"),strip.background=element_rect(fill="white"))
dev.off()

pdf("pmd_depth_by_culturing_and_health.pdf")
ggplot(data=data,aes(x=V8,y=V12,group=V8))+facet_grid(V3~V4)+geom_violin(draw_quantiles=c(0.25,0.5,0.75))+ylab("%mCpG")+theme(text = element_text(size=10), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_line(colour="black"),strip.background=element_rect(fill="white"))
dev.off()

