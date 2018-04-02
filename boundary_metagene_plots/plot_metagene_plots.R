
## Argument 1: PMD_absolute_metagene.forR
## Argument 2: PMD_absolute_metagene_density.forR

#!/usr/bin/Rscript

args = commandArgs(trailingOnly=TRUE)
if (length(args)!=2) {
    stop(paste("Must specify 2 input files",
                            sep=""), call.=FALSE)
}

data<-read.table(args[1])

pdf("methylation_metagene.pdf")
boxplot(data$V2~data$V1,outline=FALSE)
dev.off()

data<-read.table(args[2])

pdf("cpgdensity_metagene.pdf")
boxplot(data$V2~data$V1,outline=FALSE)
dev.off()

# Note: these plots need some cleaning up via mirroring.
