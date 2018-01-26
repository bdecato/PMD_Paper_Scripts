
# Script to downsample a methcounts file by some percentage.
# 
# Copyright (C) 2017 University of Southern California and
#                          Benjamin Decato
# 
# Authors: Benjamin Decato
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#!/usr/bin/env python

"""This script is used to downsample methcounts files by a desired percentage. It makes no assumptions about linkage introduced by reads covered by multiple CpG sites. """
import sys, os, random, getopt
import subprocess, tempfile
from random import *

def main(argv):
  inputfile = ''
  outputfile = ''
  downsample_percent = 0.0
  try:
      opts, args = getopt.getopt(argv,"h:i:o:d:",["ifile=","ofile=","dsample="])
  except getopt.GetoptError:
    print('downsample_methcounts.py -i <inputfile> -o <outputfile> -d <downsamplepercent>')
    sys.exit(2)
  for opt, arg in opts:
    if opt == '-h':
      print('downsample_methcounts.py -i <inputfile> -o <outputfile> -d <downsamplepercent>')
      sys.exit()
    elif opt in ("-i", "--ifile"):
      inputfile = arg
    elif opt in ("-o", "--ofile"):
      outputfile = arg
    elif opt in ("-d", "--dsample"):
      downsample_percent = float(arg)
  ifile = open(inputfile,'r')
  ofile = open(outputfile, 'w')
  for l in ifile:
    fields = l.split()
    chrom = fields[0];
    start = fields[1];
    strand = fields[2];
    name = fields[3];
    meth = float(fields[4]);
    coverage = int(fields[5]);
    meth_reads = int(round(coverage * meth));
    original_meth_coverage = meth_reads;
    unmeth_reads = coverage - meth_reads;
    original_unmeth_coverage = unmeth_reads;
    #print chrom + "\t" + start + "\t" + str(meth) + "\t" + str(coverage) + "\t" + str(meth_reads) + "\t" + str(unmeth_reads)
    for x in range(0,original_meth_coverage):
      #print uniform(0,100) > downsample_percent
      if(uniform(0,100) > downsample_percent):
        meth_reads=meth_reads-1;
    for x in range(0,original_unmeth_coverage):
      if(uniform(0,100) > downsample_percent):
        unmeth_reads=unmeth_reads-1;

    newmeth=0;
    newcov=0;
    if(meth_reads+unmeth_reads>0):
      newmeth = float(meth_reads)/(meth_reads+unmeth_reads)
      newcov = int(meth_reads+unmeth_reads)

    ofile.write(chrom + "\t" + start + "\t" + strand + "\t" + name + "\t" + str(newmeth) + "\t" + str(newcov) + "\n");    

  ifile.close()
  ofile.close()

if __name__ == '__main__':
  main(sys.argv[1:])

