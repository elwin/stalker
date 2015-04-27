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
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        map = MKMapView(frame: view.frame)
        view.addSubview(map)
        
    }
    
    func checkLocationAuthorizationStatus(mapView: MKMapView) {
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        let currentUser = PFUser.currentUser()
        if (currentUser != nil) {
            println(currentUser?.username)
        } else {
            let loginViewController = LoginViewController()
            self.presentViewController(loginViewController, animated: true, completion: nil)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .NotDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .AuthorizedWhenInUse:
            map.showsUserLocation = true
        default:
            break
        }
    }
}
