## Argument 1: region	meth1	meth2
## Output: a single scalar value that is the Pearson correlation between V2 and V3

#!/usr/bin/Rscript
#library(ggplot2)
args = commandArgs(trailingOnly=TRUE)
if (length(args)!=1) {
    stop(paste("Must specify <inputdata>",
                            sep=""), call.=FALSE)
}

data<-read.table(args[1])

cor(data$V2,data$V3)

