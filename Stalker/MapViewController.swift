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
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        
        locationManager.stopUpdatingLocation()
        updateLocation(newLocation)

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
        locationManager.startUpdatingLocation()
    }
    
    func updateLocation(location: CLLocation) {
        
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
                    data["latitude"] = location.coordinate.latitude
                    data["longitude"] = location.coordinate.longitude
                    data.saveInBackground()
                    println("Updated")
                }
            }
        } else {
            let data = PFObject(className: "locations")
            data["user"] = PFUser.currentUser()?.username
            data["latitude"] = location.coordinate.latitude
            data["longitude"] = location.coordinate.longitude
            data.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                userDefaults.setValue(data.objectId!, forKey: "objectID")
            })
        }
    }
}
