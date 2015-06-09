//
//  VizFig.swift
//  VizFigDemo
//
//  Created by Jay Lyerly on 6/9/15.
//  Copyright (c) 2015 Oak City Labs. All rights reserved.
//

import UIKit

class VizFig {
    static let sharedManager = VizFig()
    var configSource: Any? = nil
    
    func getPropertyValueForString(propertyName:String) -> Any? {
        println("Getting value for property: \(propertyName)")
        
        if let source = configSource {
            let configMirror = reflect(source)

            var propertyValue: Any? = nil
            for i in 0 ..< configMirror.count {
                let (name, subMirror) = configMirror[i]
                if propertyName == name {
                    propertyValue = subMirror.value
                }
            }
            println("Found value:\(propertyValue)")
            return propertyValue
        } else {
            return nil
        }
    }

    func getColorForString(propertyName: String) -> UIColor? {
        return getPropertyValueForString(propertyName) as? UIColor
    }

    func getFontForString(propertyName: String) -> UIFont? {
        return getPropertyValueForString(propertyName) as? UIFont
    }

}