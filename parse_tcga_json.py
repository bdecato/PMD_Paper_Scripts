#!/usr/bin/env python
# parse_tcga_json: Quick script to retrieve cancer type, tumor stage,
# and age of patient from TCGA-supplied JSON metadata file.
# 
# Copyright (C) 2018 University of Southern California and
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

"""This script is used to parse tumor stage and age of patient from TCGA.
"""

import sys, os, random, getopt, json
import subprocess, tempfile

def main(argv):
  inputfile = ''
  outputfile = ''
  coverage = 0
  try:
      opts, args = getopt.getopt(argv,"h:i:o:",["ifile=","ofile="])
  except getopt.GetoptError:
    print('parse_tcga_json.py -i <inputfile> -o <outputfile>')
    sys.exit(2)
  for opt, arg in opts:
    if opt == '-h':
      print('parse_tcga_json.py -i <inputfile> -o <outputfile>')
      sys.exit()
    elif opt in ("-i", "--ifile"):
      inputfile = arg
    elif opt in ("-o", "--ofile"):
      outputfile = arg

  with open(inputfile) as data_file:
    data = json.load(data_file)

  ofile = open(outputfile, 'w')
  print(len(data))
  for x in range (0,len(data)):
    ofile.write(data[x]["file_name"] + "\t")
    try:
      ofile.write(str(data[x]["cases"][0]["samples"][0]["submitter_id"]) + "\t")
    except KeyError:
      ofile.write("no_age_listed\t")
    try:
      ofile.write(str(data[x]["cases"][0]["diagnoses"][0]["tumor_stage"]) + "\t")
    except KeyError:
      ofile.write("no_stage_listed\t")
    
    try:
      ofile.write(str(data[x]["cases"][0]["disease_type"]) + "\n")
    except KeyError:
      ofile.write("no filename listed\n")

if __name__ == '__main__':
  main(sys.argv[1:])

