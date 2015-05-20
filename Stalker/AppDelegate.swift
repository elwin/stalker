//
//  AppDelegate.swift
//  Stalker
//
//  Created by Elwin Stephan on 27/04/15.
//  Copyright (c) 2015 Elwin Inc. All rights reserved.
//

import UIKit
import Parse
import Bolts

let applicationID = "LUVykUZI50P9A6muFnALaSxb9jsNpyRh8qzo89sV"
let clientKey = "OE3ew9T7oBbrH2jB0O8d9XdMybHwsfabzAE3sKTz"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Parse.setApplicationId(applicationID, clientKey: clientKey)
        
        let mapViewController = MapViewController()
        let mapNavigationController = UINavigationController(rootViewController: mapViewController)
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = mapNavigationController
        window!.makeKeyAndVisible()
        window!.backgroundColor = UIColor.whiteColor()
        
        return true
    }


}

