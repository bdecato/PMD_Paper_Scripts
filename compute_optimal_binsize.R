# Copyright (C) 2017 University of Southern California
#                     Benjamin E Decato
#
# Author: Benjamin E Decato
#
# This is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
###########################################################################
#
# compute_optimal_binsize.R
#
# Script to fit a spline to the number of bp segmented into PMDs
# by bin size, and then identify the inflection point at which the
# number of bp segmented starts to decrease, thereby identifying
# a bin size that is mostly stable.
#
#

#! /usr/bin/env Rscript


###########################################################################
args = commandArgs(trailingOnly=TRUE)
if (length(args)!=1) {
  stop(paste("Must specify <inputfile>",
             sep=""), call.=FALSE)
}

data<-read.table(args[1],header=FALSE)
spline<-smooth.spline(data$V2,data$V3)

d1<-function(x) predict(spline,x,deriv=1)$y

z<-seq(500,30000,length=3000)
roots<-uniroot(f=d1,interval=c(0,30000))
cat(round(roots$root))
cat("\n")
