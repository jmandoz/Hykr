//
//  CoreLocationController.swift
//  Trekker
//
//  Created by Jason Mandozzi on 8/21/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import Foundation
import CoreLocation

class CoreLocationController {
    
    static let shared = CoreLocationController()
    
    let locationManager: CLLocationManager = CLLocationManager()
    
    func activateLocationServices() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}
