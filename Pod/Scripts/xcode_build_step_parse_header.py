#!/usr/bin/env python

import argparse
import sys
from swift import *

#
#  FIXME:  Don't parse the generated header, user the AST dump instead
#     env DEVELOPER_DIR=/Applications/Xcode7-beta5.app/Contents/Developer  xcrun -sdk iphonesimulator  swiftc -print-ast  Config.swift
#

# print "Hello World!"
# print "Swift module name:", swiftModuleName()
# print "ObjectiveC header file:", objcHeaderFile()

# inputClass = "Configuration"
# outputClass = "MagicView"
# 
# outputFile = generateConfigViewForClass(inputClass, outputClass)
# 
# print "Parsing header file:", objcHeaderFile()
# print "Wrote class to:", outputFile

parser = argparse.ArgumentParser(description='Script to call from Xcode build step in order to generate VizFig code from given configuration class.')
 
# parser.add_argument('-v', '--verbose',
#     action="store_true",
#     help="Print this help info." )

parser.add_argument('-f', '--inputFile', action='store', dest='inputFile',
                required=True,
                help='Name of class to parse for configuration info')
 
parser.add_argument('-i', '--inputClass', action='store', dest='inputClass',
                required=True,
                help='Name of class to parse for configuration info')
 
parser.add_argument('-o', '--outputFile', action='store', dest='outputFile',
                required=True,
                help='Prefix of output file for generated code -- <outputFile>.swift')
 
args = vars(parser.parse_args())

# print args
# print args["inputClass"]
# print args["outputFile"]
# print args
inputClass = args["inputClass"]
inputFile = args["inputFile"]
outputFile = args["outputFile"]

targetFile = targetFileName(outputFile)
print "Removing previous output file (if it exists):", targetFile
try:
    os.unlink(targetFile)
except OSError, e:
    # ignore error if file doesn't exist
    pass
    
outputFile = generateConfigViewForClass(inputClass, inputFile, outputFile)

print "Parsing input file:", inputFile
print "Wrote class to:", outputFile
