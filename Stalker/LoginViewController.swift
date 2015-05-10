//
//  LoginViewController.swift
//  Stalker
//
//  Created by Elwin Stephan on 27/04/15.
//  Copyright (c) 2015 Elwin Inc. All rights reserved.
//

import UIKit
import Parse

let kPassword = "stalker"

class LoginViewController: UIViewController {
    
    let usernameField = UITextField()
    let titleLabel = UILabel()
    let loginButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
    var visibleView: CGRect = CGRectMake(0, 0, 0, 0)
    
    override func viewDidLoad() {
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "keyboardWasShown:",
            name: UIKeyboardWillShowNotification,
            object: nil)
        visibleView = view.frame
        
        view.backgroundColor = UIColor.clearColor()
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        
        blurView.frame = view.frame
        view.addSubview(blurView)
        
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 30)
        titleLabel.text = "Welcome to \n Stalker"
        titleLabel.sizeToFit()
        view.addSubview(titleLabel)
        
        usernameField.placeholder = "Some fancy Username"
        usernameField.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        usernameField.sizeToFit()
        usernameField.frame.size.width = visibleView.width - 60
        
        var border = CALayer()
        var width = CGFloat(0.5)
        border.borderColor = UIColor.lightGrayColor().CGColor
        border.frame = CGRect(x: 0, y: usernameField.frame.size.height - width, width: usernameField.frame.size.width, height: usernameField.frame.size.height)
        border.borderWidth = width
        usernameField.layer.addSublayer(border)
        usernameField.layer.masksToBounds = true
        
        view.addSubview(usernameField)
        usernameField.becomeFirstResponder()
        
        loginButton.titleLabel?.textAlignment = NSTextAlignment.Center
        loginButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        loginButton.setTitle("Continue", forState: UIControlState.Normal)
        loginButton.sizeToFit()
        loginButton.addTarget(nil, action: "login", forControlEvents: .TouchUpInside)
        view.addSubview(loginButton)
        
        allignObjectsInView()
    }
    
    func allignObjectsInView() {
        
        titleLabel.center.x = visibleView.width / 2
        titleLabel.center.y = visibleView.height * 0.35
        
        usernameField.center.x = visibleView.width / 2
        usernameField.center.y = visibleView.height * 0.65
        
        loginButton.center.x = visibleView.width / 2
        loginButton.center.y = visibleView.height * 0.85
        
    }
    
    func keyboardWasShown(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        visibleView.size.height = view.frame.size.height - keyboardFrame.size.height
        allignObjectsInView()
    }
    
    
    func login() {
        let username = usernameField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let password = kPassword
        
        PFUser.logInWithUsernameInBackground(username, password: password) {
            (success, error) -> Void in
            if (error == nil) {
                println("Signed in User: \(username)")
                self.finishLogin()
            } else {
                self.signup()
            }
            
        }
    }
    
    func signup() {
        let username = usernameField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let password = kPassword
        
        let newUser = PFUser.new()
        newUser.username = username
        newUser.password = password
        
        newUser.signUpInBackgroundWithBlock { (success, error) -> Void in
            if (error == nil) {
                println("Signed up User: \(username)")
                self.finishLogin()
            } else {
                UIAlertView(title: "Oops!", message: "Some Error occured. Please try again later!", delegate: nil, cancelButtonTitle: "Okay").show()
            }
        }
    }
    
    func finishLogin() {
        self.usernameField.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            MapViewController().viewDidAppear(true)
        })
    }
}
