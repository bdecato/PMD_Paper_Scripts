#!/usr/bin/Rscript
library(ggplot2)
library(hexbin)

data<-read.table("~/Desktop/Decato-PMD-revision-analysis/F3D_depth_by_conservation.txt",header=TRUE)

smoothScatter(data$meanMeth~data$numSamples)

model <- lm(data=data, meanMeth~numSamples)
summary(model)

# Figure 3D.
smoothScatter(data$numSamples,data$meanMeth)

#ggplot(data,aes(x=numSamples,y=meanMeth)) + 
#  geom_hex() + 
#  stat_smooth(method=lm) +
#  theme_bw() +
#  theme(legend.position = "right", text = element_text(size=14), axis.text = element_text(size = 10),
#        axis.text.x = element_text(angle = 45, hjust = 1), strip.background = element_blank(),
#        strip.placement = "outside")
