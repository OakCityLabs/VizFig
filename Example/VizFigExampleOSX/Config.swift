//
//  Config.swift
//  VizFig
//
//  Created by Jay Lyerly on 8/11/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Cocoa

class BogusConfiguration {
    
    static let bogusRedColor = NSColor.red
    static let bogusBlueColor = Configuration.colorForHexValue(colorHex: 0x1122ee)
    static let bogusFont = NSFont.systemFont(ofSize: 15)
    static let bogusString = "Bogus"
}

class Configuration {
    
    static let redColor = NSColor.red
    static let blueColor = Configuration.colorForHexValue(colorHex: 0x1122ee)
    
    static let boringFont = NSFont.systemFont(ofSize: 19)
    static let macFont = NSFont.systemFont(ofSize: 19)
    
    static let catchPhraseString = "Spoon!"

    class func colorForHexValue(colorHex: Int) -> NSColor {
        let red =   (colorHex & 0xff0000) >> 16
        let green = (colorHex & 0x00ff00) >> 8
        let blue  = colorHex & 0x0000ff
        let color = NSColor(red: CGFloat(red)/256.0, green: CGFloat(green)/256.0, blue: CGFloat(blue)/256.0, alpha: CGFloat(1.0))
        return color
    }

}

class AlsoBogusConfiguration {
    
    static let bogusRedColor = NSColor.red
    static let bogusBlueColor = Configuration.colorForHexValue(colorHex: 0x1122ee)
    static let bogusFont = NSFont.systemFont(ofSize: 15)
    static let bogusString = "Bogus"
}
