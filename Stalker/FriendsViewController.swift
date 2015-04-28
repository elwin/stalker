//
//  FriendsViewController.swift
//  Stalker
//
//  Created by Elwin Stephan on 27/04/15.
//  Copyright (c) 2015 Elwin Inc. All rights reserved.
//

import UIKit
import Parse

class FriendsViewController: UITableViewController {
    
    override func viewDidLoad() {
        title = "Stalker"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "logout")
        
    }
    
    func logout() {
        PFUser.logOut()
        self.tabBarController?.selectedIndex = 0
        let tabBarController = TabBarController()
        
        let loginViewController = LoginViewController()
        self.presentViewController(loginViewController, animated: true, completion: nil)
    }
    
}
