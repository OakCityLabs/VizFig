import os
import re

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
    
def configurationAttributes(className):
    lines = headerLines(className)
    #print "Found header %s header lines", len(lines)
    #print "Found header block:\n"
    #for line in lines:
    #    print "\t", line

    configAttrs = {}
    for aClass in attributeClasses.keys():
        configAttrs[aClass] = []
        for line in lines:
            if line.find("+ (%s *" % aClass) > -1:
                (dummy, attrName) = line.split(")")
                attrName = attrName.replace(";","")
                configAttrs[aClass].append(attrName)
        
    return configAttrs
        
def generateConfigViewClass(configAttributes, className, generatedClassName = "ConfigView"):
    txt = ""
    txt += classHeaderTemplate % { "className": generatedClassName }
    txt += "\n"

    for aClass in attributeClasses:
        for funcName in attributeClasses[aClass]:
            attrs = configAttributes[aClass]
            for attr in attrs:
                tmpAttr = attr[0].upper() + attr[1:]
                collectionName = "%s%s" % (funcName, tmpAttr)
                infoDict = {
                    "collectionName": collectionName,
                    "funcName": funcName,
                    "attrName": attr,  
                    "configClass": className,
                }
                txt += collectionTemplate % infoDict
                txt += "\n"

    txt += classFooterTemplate
    txt += "\n"
    return txt

classHeaderTemplate = """class %(className)s: BaseConfigView {"""

classFooterTemplate = "}"

#    @IBOutlet var backgroundWhite:       [UIView]? { didSet { bgColorize(Configuration.whiteColor,     items: backgroundWhite) } }
collectionTemplate = """    @IBOutlet var %(collectionName)s: [UIView]? { didSet { %(funcName)s(%(configClass)s.%(attrName)s, items: %(collectionName)s) } }"""


def writeClassToFile(classTxt, className):
    filename = "%s.swift" % className
    fullpath = os.path.join(sourceFileDir(), filename)
    
    with open(fullpath,'w') as f:
        f.write(classTxt)
    
    return fullpath    