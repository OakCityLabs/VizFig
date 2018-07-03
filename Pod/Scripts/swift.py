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
        'String': ['stringify'],
        'NSColor': ['colorize', 'bgColorize'],
    }
else: 
    attributeClasses = {
        'UIFont': ['fonterize'],
        'NSString': ['stringify'],
        'String': ['stringify'],
        'UIColor': ['colorize', 'bgColorize'],
    }
    
def sourceFileDir():
    try:
        plistPath = os.environ["PRODUCT_SETTINGS_PATH"]
        (srcDir, plist) = os.path.split(plistPath)
        return srcDir
    except:
        return "/tmp"

def doCmd(cmd, extraEnv=None, error_processor=None):
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
        if error_processor:
            err = error_processor(err)
        print "Standard Error:", err
    return output.strip()

def getAstLines(className, swiftPrefix):
    shortFile = "%s.swift" % swiftPrefix
    swiftFile = os.path.join(sourceFileDir(), shortFile)

    sdk = os.environ.get("PLATFORM_NAME", "Unknown")                        # iphoneos
    deploy_target = os.environ.get("IPHONEOS_DEPLOYMENT_TARGET", "0.0")     # 9.2
    arch = os.environ.get("arch", "unknown_arch")                           # arm64
    prefix = os.environ.get("SWIFT_PLATFORM_TARGET_PREFIX", "no_prefix")    # ios
    swift_version = os.environ.get("SWIFT_VERSION", "0.0")                  # 3.0
    other_flags = os.environ.get("OTHER_SWIFT_FLAGS","")
  
    # fix swift_version (compiler wants 3 or 4, not 3.2, 4.1)
    swift_version = swift_version.split(".")[0] 
 
    # targets look like "arm64-apple-ios9.2"
    target = "%s-apple-%s%s" % (arch, prefix, deploy_target)
    
    print "Setting TARGET to", target
    
    #cmd = "env DEVELOPER_DIR=/Applications/Xcode-beta.app/Contents/Developer xcrun -sdk %s swiftc -print-ast %s" % (sdk, swiftFile)
    cmd = "xcrun -sdk %s swiftc -swift-version %s -sdk `xcrun --show-sdk-path --sdk %s` -target %s -print-ast %s %s" % \
        (sdk, swift_version, sdk, target, swiftFile, other_flags)
    
    def strip_error(txt):
        # futz with the output so Xcode doesn't freak about unimportant errors
        return txt.replace(":", ";")

    header = doCmd(cmd, error_processor=strip_error)
    
#    print "Header:\n", header
    
    return header
    
def configurationAttributes(className, classFile):
    header = getAstLines(className, classFile)
    
    #  Super hacky way of remove getter/setter info that interferes with parsing
    #  TODO: Parse headers better
    header = header.replace("{ get }", "")
    header = header.replace("{ set }", "")
    header = header.replace("{ get set }", "")
    
    classes = header.split("}")
    configClass = None
    for c in classes:
        try:
            (prefix, classtxt) = c.split("{")
        except ValueError,e:
            prefix = ""
            classtxt = ""
        prefix = prefix.replace(" ","")
        print "prefix to test:", prefix
        if prefix.endswith( "enum%s" % className):
            configClass = classtxt
        
    if configClass == None:
        raise(Exception("Can't find config class"))
        
        
    lines = configClass.split("\n")
    
#    print "Found header %s header lines", len(lines)
#    print "Found header block:\n"
#    for line in lines:
#        print "\t", line

    configAttrs = {}
    for aClass in attributeClasses.keys():
        configAttrs[aClass] = []
        for line in lines:
            if not (("static let" in line) or ("static var" in line)): continue
            if line.find(": %s" % aClass) > -1:
                if " let " in line:
                    (dummy, attrName) = line.split("let")
                else:
                    (dummy, attrName) = line.split("var")
                #print "attrName:", attrName
                attrName = attrName.strip()
                attrName = attrName[:-1 * len(aClass)]  # strip class name off end of line
                attrName = attrName.replace(":","")
                attrName = attrName.replace(" ","")
                #print "attrName: <%s>" % attrName
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
// Generated on class attributes of the '%(inputClass)s' class.
// Do not edit.  This file will be overwritten.

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