
## Argument 1: the "segmentation_statistics" output file from segmentation_statistics.sh
## Argument 2: the "segmentation_size_dtns" output file from segmentation_statistics.sh
## Argument 3: the "pmd_size_dtns" output file from segmentation_statistics.sh

#!/usr/bin/Rscript

args = commandArgs(trailingOnly=TRUE)
if (length(args)!=3) {
    stop(paste("Must specify <segmentation_table> <segmentation_size_dtn> <pmd_size_dtn>",
                            sep=""), call.=FALSE)
}

data<-read.table(args[1])

pdf("binsize_by_coverage.pdf")
plot(data$V8~data$V7,col=data$V2,xlab="Mean CpG coverage depth",ylab="Bin size")
legend("topright",legend=levels(factor(data$V2)),text.col=seq_along(levels(factor(data$V2))))
dev.off()

pdf("sorted_frac.pdf",useDingbats=FALSE)
barplot(data$V3,col=data$V2)
abline(h=0.05,lty=2,col="red")
legend("topleft",legend=levels(factor(data$V2)),text.col=seq_along(levels(factor(data$V2))))
dev.off()
pdf("sorted_mean.pdf",useDingbats=FALSE)
barplot(data$V4,col=data$V2)
abline(h=100000,lty=2,col="red")
legend("topleft",legend=levels(factor(data$V2)),text.col=seq_along(levels(factor(data$V2))))
dev.off()

data<-read.table(args[2])
ordered<-reorder(data$V1,data$V3,median)
pdf("segmentation_size_dtns_with_outliers.pdf",useDingbats=FALSE)
boxplot(data$V3~ordered,las=2,xlab="Sample",ylab="Segment size")
dev.off()

pdf("segmentation_size_dtns_no_outliers.pdf",useDingbats=FALSE)
boxplot(data$V3~ordered,las=2,outline=FALSE,xlab="Sample",ylab="Segment size")
dev.off()

data<-read.table(args[3])
ordered<-reorder(data$V1,data$V3,median)
pdf("pmd_size_dtns_with_outliers.pdf",useDingbats=FALSE)
boxplot(data$V3~ordered,las=2,xlab="Sample",ylab="PMD size")
dev.off()

pdf("pmd_size_dtns_no_outliers.pdf",useDingbats=FALSE)
boxplot(data$V3~ordered,outline=FALSE,las=2,xlab="Sample",ylab="PMD size")
dev.off()



