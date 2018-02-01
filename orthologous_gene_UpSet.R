## Argument 1: the "UpSet-matrix" input file, with proper headers manually annotated

#!/usr/bin/Rscript
library(UpSetR)
args = commandArgs(trailingOnly=TRUE)
if (length(args)!=1) {
    stop(paste("Must specify <UpSet matrix>",
                            sep=""), call.=FALSE)
}

data<-read.table(args[1],header=TRUE)

pdf("UpSet-placenta-orthologous-genes.pdf",useDingbats=FALSE, onefile=FALSE)
upset(data,sets = c("Human","Rhesus","SquirrelMonkey","Mouse","Cow","Horse","Dog"),sets.bar.color = "#56B4E9", order.by = "freq", empty.intersections = "on",point.size=1,line.size=0.3,show.numbers=FALSE)
dev.off()


