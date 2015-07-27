#!/usr/bin/env python

from swift import *

print "Hello World!"
print "Swift module name:", swiftModuleName()
print "ObjectiveC header file:", objcHeaderFile()

configClassName = "Configuration"
outputClass = "MagicView"

attrs = configurationAttributes(configClassName)
#print "Found attributes:", attrs
#print "Done."

classTxt = generateConfigViewClass(attrs, configClassName, outputClass)
print "Generated class:\n", classTxt

newFile = writeClassToFile(classTxt, outputClass)
print "Wrote class to:", newFile