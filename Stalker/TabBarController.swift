//
//  TabBarController.swift
//  Stalker
//
//  Created by Elwin Stephan on 27/04/15.
//  Copyright (c) 2015 Elwin Inc. All rights reserved.
//

import UIKit
import Parse

class TabBarController: UITabBarController {
    
    override func viewDidAppear(animated: Bool) {
        
        let currentUser = PFUser.currentUser()
        if (currentUser != nil) {
            println("Current User: \(currentUser!.username!)")
        } else {
            let loginViewController = LoginViewController()
            self.presentViewController(loginViewController, animated: true, completion: nil)
        }
        
    }
    
}
