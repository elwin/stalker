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

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var map: MKMapView! = nil
    
    override func viewDidLoad() {
        
        self.title = "Stalker"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refresh")
        
        map = MKMapView(frame: view.frame)
        view.addSubview(map)
        
        requestAuthorization()
    }
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            map.showsUserLocation = true
        }
    }
    
    func requestAuthorization() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func refresh() {
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            self.updateLocation(geoPoint!)
        }
        retrieveStalkerLocation()
    }
    
    func updateLocation(location: PFGeoPoint) {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let savedObjectID = userDefaults.valueForKey("objectID") as? String
        
        if let objectID = savedObjectID {
            let query = PFQuery(className: "locations")
            
            query.getObjectInBackgroundWithId(objectID) {
                (data: PFObject?, error: NSError?) -> Void in
                if error != nil {
                    println(error)
                } else if let data = data {
                    data["user"] = PFUser.currentUser()?.username
                    data["location"] = location
                    data.saveInBackground()
                }
            }
        } else {
            let data = PFObject(className: "locations")
            data["user"] = PFUser.currentUser()?.username
            data["location"] = location
            data.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                userDefaults.setValue(data.objectId!, forKey: "objectID")
            })
        }
    }
    
    func retrieveStalkerLocation() {
        let query = PFQuery(className: "locations")
        let username = PFUser.currentUser()?.username
        if let user = username {
            query.whereKey("user", notEqualTo: user)
            query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
                    if let objects = objects as? [PFObject] {
                        for object in objects {
                            let location = object["location"] as! PFGeoPoint
                            let username = object["user"] as! String
                            let time = object.createdAt!
                            self.setStalkerLocation(location, username: username, timeStamp: time)
                        }
                    }
                }
            })
        }
        
    }
    
    func setStalkerLocation(geoPoint: PFGeoPoint, username: String, timeStamp: NSDate) {
        let location = CLLocation(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
        println("\(location.coordinate.latitude) \(location.coordinate.longitude)")
        println(username)
        println(timeStamp)
        
    }
}
