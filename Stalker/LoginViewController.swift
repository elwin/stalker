//
//  LoginViewController.swift
//  Stalker
//
//  Created by Elwin Stephan on 27/04/15.
//  Copyright (c) 2015 Elwin Inc. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    let usernameField = UITextField()
    
    override func viewDidLoad() {
        
        view.backgroundColor = UIColor.whiteColor()
        
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 30)
        titleLabel.text = "Welcome to \n Stalker"
        titleLabel.sizeToFit()
        titleLabel.center.x = view.center.x
        titleLabel.center.y = view.frame.height * 0.15
        view.addSubview(titleLabel)
        
        usernameField.placeholder = "Some fancy Username"
        usernameField.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        usernameField.sizeToFit()
        usernameField.frame.size.width = view.frame.size.width - 50
        usernameField.frame.size.height += 20
        usernameField.center.x = view.center.x
        usernameField.center.y = view.frame.height * 0.3
        
        var border = CALayer()
        var width = CGFloat(0.5)
        border.borderColor = UIColor.lightGrayColor().CGColor
        border.frame = CGRect(x: 0, y: usernameField.frame.size.height - width, width: usernameField.frame.size.width, height: usernameField.frame.size.height)
        border.borderWidth = width
        usernameField.layer.addSublayer(border)
        usernameField.layer.masksToBounds = true
        
        view.addSubview(usernameField)
        usernameField.becomeFirstResponder()
        
        let loginButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        loginButton.titleLabel?.textAlignment = NSTextAlignment.Center
        loginButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        loginButton.setTitle("Continue", forState: UIControlState.Normal)
        loginButton.sizeToFit()
        loginButton.center.x = view.center.x
        loginButton.center.y = view.frame.height * 0.4
        loginButton.addTarget(nil, action: "login", forControlEvents: .TouchUpInside)
        view.addSubview(loginButton)
    }
    
    
    func login() {
        let username = usernameField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let password = "stalker"
        
        PFUser.logInWithUsernameInBackground(username, password: password) {
            (success, error) -> Void in
            if (error == nil) {
                println("Signed in User: \(username)")
            } else {
                let newUser = PFUser.new()
                newUser.username = username
                newUser.password = password
                newUser.signUpInBackgroundWithBlock({
                    (success, error) -> Void in
                    println("Signed up User: \(password)")
                })
            }
            
        }
    }
    
    
    
    
    
    
    
    
}
