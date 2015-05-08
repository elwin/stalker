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

let kLocationClass = "location"
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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refresh")
        
        map = MKMapView()
        map.delegate = self
        view.addSubview(map)
        
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
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            map.showsUserLocation = true
            retrieveStalkerLocation()
        }
    }
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        
        if userLocationSet {
            return
        }
        
        let locationDistance: CLLocationDistance = 10000
        let region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, locationDistance, locationDistance)
        map.setRegion(region, animated: true)
        userLocationSet = true
        retrieveStalkerLocation()
        
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
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let savedObjectID = userDefaults.valueForKey(kObjectID) as? String
        
        if let objectID = savedObjectID {
            let query = PFQuery(className: kLocationClass)
            
            query.getObjectInBackgroundWithId(objectID) {
                (data: PFObject?, error: NSError?) -> Void in
                if error != nil {
                    println(error)
                } else if let data = data {
                    data[kUser] = PFUser.currentUser()?.username
                    data[kLocation] = location
                    data.saveInBackground()
                }
            }
        } else {
            let data = PFObject(className: kLocationClass)
            data[kUser] = PFUser.currentUser()?.username
            data[kLocation] = location
            data.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                userDefaults.setValue(data.objectId!, forKey: kObjectID)
            })
        }
    }
    
    func retrieveStalkerLocation() {
        let query = PFQuery(className: kLocationClass)
        let username = PFUser.currentUser()?.username
        if let user = username {
            query.whereKey(kUser, notEqualTo: user)
            query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
                if error == nil {
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
}
