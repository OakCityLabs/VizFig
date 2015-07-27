#!/usr/bin/env python

from swift import *

# print "Hello World!"
# print "Swift module name:", swiftModuleName()
# print "ObjectiveC header file:", objcHeaderFile()

inputClass = "Configuration"
outputClass = "MagicView"

outputFile = generateConfigViewForClass(inputClass, outputClass)

print "Wrote class to:", outputFile