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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Parse.setApplicationId("LUVykUZI50P9A6muFnALaSxb9jsNpyRh8qzo89sV",
            clientKey: "OE3ew9T7oBbrH2jB0O8d9XdMybHwsfabzAE3sKTz")
        
        let tabBarController = TabBarController()
        let mapViewController = MapViewController()
        let mapNavigationController = UINavigationController(rootViewController: mapViewController)
        let friendsViewController = FriendsViewController()
        let friendsNavigationController = UINavigationController(rootViewController: friendsViewController)
        
        mapViewController.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.Search, tag: 0)
        friendsViewController.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.Favorites, tag: 1)
        tabBarController.viewControllers = [mapNavigationController, friendsNavigationController]
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = tabBarController
        window!.makeKeyAndVisible()
        window!.backgroundColor = UIColor.whiteColor()
        
        return true
    }


}

