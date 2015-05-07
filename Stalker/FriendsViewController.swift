//
//  FriendsViewController.swift
//  Stalker
//
//  Created by Elwin Stephan on 27/04/15.
//  Copyright (c) 2015 Elwin Inc. All rights reserved.
//

import UIKit
import Parse

class FriendsViewController: UITableViewController, UITableViewDelegate {
    
    var users: [PFUser]?
    
    override func viewDidLoad() {
        title = "Stalker"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "logout")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
    }
    
    override func viewDidAppear(animated: Bool) {
        refreshTableView()
    }
    
    func refreshTableView() {
        
        let query = PFQuery(className: "_User")
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                self.users = objects as? [PFUser]
                self.tableView.reloadData()
            }
        }
    }
    
    func logout() {
        PFUser.logOut()
        NSUserDefaults.standardUserDefaults().removeObjectForKey("objectID")
        let object = PFObject.new()
        object.objectId = "objectID"
        object.deleteInBackground()
        
        self.tabBarController?.selectedIndex = 0
        let tabBarController = TabBarController()
        
        let loginViewController = LoginViewController()
        self.presentViewController(loginViewController, animated: true, completion: nil)
    }
    
    //MARK: TableView Data Source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = users?.count {
            return count
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "friendsCell")
        cell.textLabel?.text = users?[indexPath.row].username
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
}
