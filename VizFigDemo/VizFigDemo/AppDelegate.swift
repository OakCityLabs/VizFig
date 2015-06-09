//
//  AppDelegate.swift
//  VizFigDemo
//
//  Created by Jay Lyerly on 6/9/15.
//  Copyright (c) 2015 Oak City Labs. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        let demoConfig = DemoConfig()
        VizFig.sharedManager.configSource = demoConfig
        
        let smallFont = VizFig.sharedManager.getFontForString("smallFont")
        println("smallFont: \(smallFont)")
        
        let redColor = VizFig.sharedManager.getColorForString("redColor")
        println("redColor: \(redColor)")
        
        return true
    }
}

