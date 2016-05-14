//
//  Config.swift
//  VizFig
//
//  Created by Jay Lyerly on 7/27/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit

enum BogusConfiguration {
    
    static let bogusRedColor = UIColor.redColor()
    static let bogusBlueColor = Configuration.colorForHexValue(0x1122ee)
    static let bogusFont = Configuration.fontWithSize(15)
    static let bogusString = "Bogus"
}

enum Configuration {
    
    static let redColor = UIColor.redColor()
    static let blueColor = Configuration.colorForHexValue(0x1122ee)
    static let imgColor: UIColor = {
        // Awesome image of The Tick from http://emucoupons.deviantart.com/art/The-Tick-16629827
        if let img = UIImage(named: "TheTick") {
            return UIColor(patternImage: img)
        } else {
            return UIColor.blueColor()
        }
    }()
    
    static let mediumFont = Configuration.fontWithSize(15)
    static let bigFont = Configuration.fontWithSize(22)
    static let boringFont = UIFont.systemFontOfSize(19)
    static let fooFont = UIFont.systemFontOfSize(19)
    
    static let catchPhraseString = "Spoon!"
    static let versionString: String = {
        let appVersion = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String ?? "99.99"
        let appRevision = NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as? String ?? "99"
        return "\(appVersion)(\(appRevision))"
    }()
    
    
    private static func fontWithSize(size: Int) -> UIFont {
        return UIFont(name: "ChalkboardSE-Regular", size: CGFloat(size))!
    }
    
    private static func colorForHexValue(colorHex: Int) -> UIColor {
        let red =   (colorHex & 0xff0000) >> 16
        let green = (colorHex & 0x00ff00) >> 8
        let blue  = colorHex & 0x0000ff
        let color = UIColor(red: CGFloat(red)/256.0, green: CGFloat(green)/256.0, blue: CGFloat(blue)/256.0, alpha: CGFloat(1.0))
        return color
    }
}

enum AlsoBogusConfiguration {
    
    static let alsoBogusRedColor = UIColor.redColor()
    static let alsoBogusBlueColor = Configuration.colorForHexValue(0x1122ee)
    static let alsoBogusFont = Configuration.fontWithSize(15)
    static let alsoBogusString = "Bogus"
}
