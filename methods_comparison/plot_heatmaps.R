#!/usr/bin/Rscript

library(pheatmap)

normalize <- function(x){
  x <- as.matrix(x)
  diag(x) <- NA
  x <- (x-mean(x,na.rm=TRUE))/sd(x,na.rm=TRUE)
  return(x)
}

x<-read.table("oldpmd/tcga_oldpmd_jaccard",header=TRUE)
y<-read.table("newpmd/tcga_newpmd_jaccard",header=TRUE)
z<-read.table("methylseekr/tcga_methylseekr_jaccard",header=TRUE)

xScaled <- normalize(x)
yScaled <- normalize(y)
zScaled <- normalize(z)

pheatmap(xScaled,breaks=seq(from=-3.5,to=3.5,by=0.07),fontsize=5,cluster_rows=FALSE,cluster_cols=FALSE,cellwidth=5,cellheight=5)
pheatmap(yScaled,breaks=seq(from=-3.5,to=3.5,by=0.07),fontsize=5,cluster_rows=FALSE,cluster_cols=FALSE,cellwidth=5,cellheight=5)
pheatmap(zScaled,breaks=seq(from=-3.5,to=3.5,by=0.07),fontsize=5,cluster_rows=FALSE,cluster_cols=FALSE,cellwidth=5,cellheight=5)
