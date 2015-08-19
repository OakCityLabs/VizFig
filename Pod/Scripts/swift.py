import os
import re
import datetime
import subprocess
import sys

# Are we building for MacOSX as opposed to iOS
def isMacOSX():
    platform = os.environ.get("PLATFORM_NAME", "Unknown")
    if platform.find("mac") > -1:     # valid platforms are: iphonesimulator macosx iphoneos
        return True
    else:
        return False

if isMacOSX():
    attributeClasses = {
        'NSFont': ['fonterize'],
        'NSString': ['stringify'],
        'NSColor': ['colorize', 'bgColorize'],
    }
else: 
    attributeClasses = {
        'UIFont': ['fonterize'],
        'NSString': ['stringify'],
        'UIColor': ['colorize', 'bgColorize'],
    }
        
def swiftModuleName():
    return os.environ.get("PRODUCT_MODULE_NAME","UnknownModule")
    
def swiftHeaderFilename():
    return "%s-Swift.h" % swiftModuleName()
    
def derivedSourcesDir():
    return os.environ.get("DERIVED_SOURCES_DIR","Unknown")
    
def objcHeaderFile():
    return os.path.join(derivedSourcesDir(), swiftHeaderFilename())

def sourceFileDir():
    try:
        plistPath = os.environ["PRODUCT_SETTINGS_PATH"]
        (srcDir, plist) = os.path.split(plistPath)
        return srcDir
    except:
        return "/tmp"

def doCmd(cmd, extraEnv=None):
    print "Executing cmd:", cmd
    e = None
    if extraEnv:
        print "Adding env variables:", extraEnv
        e = os.environ
        e.update(extraEnv)
    try:
        proc = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, env=e)
        output, err = proc.communicate()
    except subprocess.CalledProcessError, e:
        print "Error output:", e.output
        raise(e)
    if err != "":
        print "Standard Error:", err
    return output.strip()

def getAstLines(className, swiftPrefix):
    shortFile = "%s.swift" % swiftPrefix
    swiftFile = os.path.join(sourceFileDir(), shortFile)

    cmd = "env DEVELOPER_DIR=/Applications/Xcode-beta.app/Contents/Developer xcrun -sdk iphonesimulator swiftc -print-ast %s" % swiftFile
    lines = doCmd(cmd)
    
    return lines.split('\n')

def headerLines(className):
    moduleName = swiftModuleName()
    configClassHeaderLines = []

    with open(objcHeaderFile()) as f:
        data = f.read()
        foundClass = False
        
        # Class declarations look like: SWIFT_CLASS("_TtC14VizFig_Example13Configuration")
        pattern = re.compile("""SWIFT_CLASS\(.*%s.*%s.*\)""" % (moduleName, className))
        
        for line in data.split('\n'):
            if foundClass and line.startswith("SWIFT_CLASS("):
                foundClass = False        

            if foundClass and line.startswith("+"):
                configClassHeaderLines.append(line)
        
            if pattern.match(line):
                foundClass = True

    return configClassHeaderLines            
    
def configurationAttributes(className, classFile):
    #lines = headerLines(className)
    lines = getAstLines(className, classFile)
    print "foo:", len(lines)
    #print "Found header %s header lines", len(lines)
    #print "Found header block:\n"
    #for line in lines:
    #    print "\t", line

    configAttrs = {}
    for aClass in attributeClasses.keys():
        configAttrs[aClass] = []
        for line in lines:
            print "parse line:", line
            if not line.startswith("  class"): continue
            if line.find(": %s" % aClass) > -1:
                (dummy, attrName) = line.split("let")
                print "attrName:", attrName
                attrName = attrName.replace(aClass,"")
                attrName = attrName.replace(":","")
                attrName = attrName.replace(" ","")
                print "attrName: <%s>" % attrName
                configAttrs[aClass].append(attrName)
        
    return configAttrs
        
def generateConfigViewClass(configAttributes, className, generatedClassName = "ConfigView"):

    classInfoDict = {
        "className": generatedClassName,
        "inputClass": className,
        "date": datetime.datetime.now().strftime("%m/%d/%Y at %I:%M %p")
    }

    txt = ""
    txt += classHeaderTemplate % classInfoDict
    txt += "\n"

    for aClass in attributeClasses:
        for funcName in attributeClasses[aClass]:
            attrs = configAttributes[aClass]
            for attr in attrs:
                tmpAttr = attr[0].upper() + attr[1:]
                collectionName = "%s%s" % (funcName, tmpAttr)
                if isMacOSX():
                    baseViewClass = "NSView"
                else:
                    baseViewClass = "UIView"
                
                infoDict = {
                    "collectionName": collectionName,
                    "funcName": funcName,
                    "attrName": attr,  
                    "configClass": className,
                    "baseViewClass": baseViewClass,
                }
                txt += collectionTemplate % infoDict
                txt += "\n\n"

    txt += classFooterTemplate
    txt += "\n"
    return txt

classHeaderTemplate = """//
// Generated by VizFig available at https://github.com/OakCityLabs/VizFig
// Generated on %(date)s based on class attributes of the '%(inputClass)s' class.

import VizFig

class %(className)s: BaseConfigView {"""

classFooterTemplate = "}"

#    @IBOutlet var backgroundWhite:       [UIView]? { didSet { bgColorize(Configuration.whiteColor,     items: backgroundWhite) } }
collectionTemplate = """    @IBOutlet var %(collectionName)s: [%(baseViewClass)s]? { 
        didSet { 
            %(funcName)s(%(configClass)s.%(attrName)s, items: %(collectionName)s)
        } 
    }"""

def targetFileName(targetClassName):
    filename = "%s.swift" % targetClassName
    return os.path.join(sourceFileDir(), filename)

def writeClassToFile(classTxt, className):
    fullpath = targetFileName(className)
    
    with open(fullpath,'w') as f:
        f.write(classTxt)
    
    return fullpath    
    
def generateConfigViewForClass(inputClass, inputFile, outputClass = "ConfigView"):
    attrs = configurationAttributes(inputClass, inputFile)
    classTxt = generateConfigViewClass(attrs, inputClass, outputClass)
    newFile = writeClassToFile(classTxt, outputClass)
    return newFile