//
//  StalkerAnnotation.swift
//  Stalker
//
//  Created by Elwin Stephan on 29/04/15.
//  Copyright (c) 2015 Elwin Inc. All rights reserved.
//

import UIKit
import MapKit

class StalkerAnnotation: NSObject, MKAnnotation {
   
    let title: String
    let coordinate: CLLocationCoordinate2D
    
    init(stalker: String, coordinate: CLLocationCoordinate2D) {
        self.title = stalker
        self.coordinate = coordinate
        super.init()
        
    }
    
}
