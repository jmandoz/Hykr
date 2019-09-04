//
//  MKAnnotationExtension.swift
//  Trekker
//
//  Created by Jason Mandozzi on 8/22/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import Foundation
import MapKit

class HikeAnnotation: MKPointAnnotation {
    
    var hike: HikeJSON
    
    var location: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: hike.latitude!, longitude: hike.longitude!)
    }
    
    var name: String {
        return hike.hikeName
    }
    
    init(hike: HikeJSON) {
        self.hike = hike
    }
}
