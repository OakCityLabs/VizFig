//
//  Config.swift
//  VizFig
//
//  Created by Jay Lyerly on 8/11/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Cocoa

// Config class must be derive from NSObject so that Xcode generates a parseable header file

class Configuration: NSObject {
    
    static let redColor = NSColor.redColor()
    static let blueColor = Configuration.colorForHexValue(0x1122ee)
    
    static let boringFont = NSFont.systemFontOfSize(19)
    static let macFont = NSFont.systemFontOfSize(19)
    
    static let catchPhraseString = "Spoon!"

    private class func colorForHexValue(colorHex: Int) -> NSColor {
        let red =   (colorHex & 0xff0000) >> 16
        let green = (colorHex & 0x00ff00) >> 8
        let blue  = colorHex & 0x0000ff
        let color = NSColor(red: CGFloat(red)/256.0, green: CGFloat(green)/256.0, blue: CGFloat(blue)/256.0, alpha: CGFloat(1.0))
        return color
    }

}