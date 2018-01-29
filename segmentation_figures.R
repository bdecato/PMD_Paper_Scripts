#!/usr/bin/Rscript

args = commandArgs(trailingOnly=TRUE)
if (length(args)!=1) {
    stop(paste("Must specify <inputfile>",
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

