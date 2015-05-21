//
//  MapViewController.swift
//  Stalker
//
//  Created by Elwin Stephan on 27/04/15.
//  Copyright (c) 2015 Elwin Inc. All rights reserved.
//

import UIKit
import MapKit
import Parse

let kLocationClass = "locations"
let kUserClass = "_User"
let kObjectID = "objectID"
let kLocation = "location"
let kUser = "user"

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var locationManager = CLLocationManager()
    var map: MKMapView! = nil
    var userLocationSet = false
    
    override func viewDidLoad() {
        
        self.title = "Stalker"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.Refresh,
            target: self,
            action: "refresh")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Logout",
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: "logout")
        
        map = MKMapView()
        map.delegate = self
        view.addSubview(map)
        
        // Add constrains to stretch & pin the Map to its Superview
        map.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[map]|",
            options: NSLayoutFormatOptions(0),
            metrics: nil,
            views: ["map": map]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[map]|",
            options: NSLayoutFormatOptions(0),
            metrics: nil,
            views: ["map": map]))
        
        requestAuthorization()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let currentUser = PFUser.currentUser()
        if (currentUser != nil) {
            println("Current User: \(currentUser!.username!)")
        } else {
            // Present LoginViewController
            let loginViewController = LoginViewController()
            self.presentViewController(loginViewController, animated: true, completion: nil)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            map.showsUserLocation = true
            retrieveStalkerLocation()
        }
    }
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        
        // Only update the UserLocation if it didn't happen already
        if userLocationSet {
            return
        }
        
        let locationDistance: CLLocationDistance = 10000
        let region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, locationDistance, locationDistance)
        map.setRegion(region, animated: true)
        userLocationSet = true
        refresh()
    }
    
    func requestAuthorization() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func refresh() {
        
        let location = PFGeoPoint(location: map.userLocation.location)
        updateLocation(location)
        
        retrieveStalkerLocation()
    }
    
    func updateLocation(location: PFGeoPoint) {
        
        let query = PFQuery(className: kLocationClass)
        query.whereKey(kUser, equalTo: PFUser.currentUser()!.username!)
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil && objects?.count > 0 {
                
                // Location is already stored in Parse
                // Just update the same Object and store it back
                let object = objects?[0] as! PFObject
                object[kLocation] = location
                object.saveInBackground()
                
            } else {
                
                // No Location found
                // Create new Object and store it
                let object = PFObject(className: kLocationClass)
                object[kUser] = PFUser.currentUser()?.username
                object[kLocation] = location
                object.saveInBackground()
                
            }
        }
    }
    
    func retrieveStalkerLocation() {
        
        let query = PFQuery(className: kLocationClass)
        let username = PFUser.currentUser()?.username
        
        if let user = username {
            
            // Find all Userlocations in Backend; Exclude CurrentUser
            query.whereKey(kUser, notEqualTo: user)
            
            query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil && objects != nil {
                    if let objects = objects as? [PFObject] {
                        self.map.removeAnnotations(self.map.annotations)
                        for object in objects {
                            let location = object[kLocation] as! PFGeoPoint
                            let username = object[kUser] as! String
                            let time = object.createdAt!
                            self.setStalkerLocation(location, username: username, timeStamp: time)
                        }
                    }
                }
            })
        }
        
    }
    
    func setStalkerLocation(geoPoint: PFGeoPoint, username: String, timeStamp: NSDate) {
        
        let location = CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
        let annotation = StalkerAnnotation(stalker: username, coordinate: location) as MKAnnotation
        map.addAnnotation(annotation)
        
    }
    
    func logout() {
        
        // Remove Location from Backend
        let query = PFQuery(className: kLocationClass)
        query.whereKey(kUser, equalTo: PFUser.currentUser()!.username!)
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                if objects?.count > 0 {
                    let object = objects?[0] as! PFObject
                    object.deleteInBackground()
                }
                
                PFUser.logOutInBackground()
                
                // Present LoginViewController
                let loginViewController = LoginViewController()
                self.presentViewController(loginViewController, animated: true, completion: nil)
            } else {
                println(error?.description)
            }
            
        }
        
    }
}
