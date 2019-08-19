//
//  Hike.swift
//  Trekker
//
//  Created by Drew Seeholzer on 8/19/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import Foundation
import CloudKit
import MapKit

class Hike {
    let longitude: Double
    let latitude: Double
    let hikeName: String
    var hikeRating: Double
    let hikeRoute: [[Double]]
    var userPhotos: [UIImage]
    let apiID: Int
    // Cloudkit Properties
    let recordID: CKRecord.ID
    
    init(longitude: Double, latitude: Double, hikeName: String, hikeRating: Double, hikeRoute: [[Double]], userPhotos: [UIImage] = [],
         apiID: Int, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        
        self.longitude = longitude
        self.latitude = latitude
        self.hikeName = hikeName
        self.hikeRating = hikeRating
        self.hikeRoute = hikeRoute
        self.userPhotos = userPhotos
        self.apiID = apiID
        self.recordID = recordID
    }
}

extension Hike {
    convenience init?(record: CKRecord) {
        guard let longitude = record[HikeConstants.longitudeKey] as? Double,
        let latitude = record[HikeConstants.latitudeKey] as? Double,
        let hikeName = record[HikeConstants.hikeNameKey] as? String,
        let hikeRating = record[HikeConstants.hikeRatingKey] as? Double,
        let hikeRoute = record[HikeConstants.hikeRouteKey] as? [[Double]],
        let apiID = record[HikeConstants.apiIDKey] as? Int
            else { return nil }
        
        
        self.init(longitude: longitude, latitude: latitude, hikeName: hikeName, hikeRating: hikeRating, hikeRoute: hikeRoute, apiID: apiID, recordID: record.recordID)
    }
}

extension CKRecord {
    convenience init(hike: Hike) {
        self.init(recordType: HikeConstants.typeKey, recordID: hike.recordID)
        self.setValue(hike.longitude, forKey: HikeConstants.longitudeKey)
        self.setValue(hike.latitude, forKey: HikeConstants.latitudeKey)
        self.setValue(hike.hikeName, forKey: HikeConstants.hikeNameKey)
        self.setValue(hike.hikeRating, forKey: HikeConstants.hikeRatingKey)
        self.setValue(hike.hikeRoute, forKey: HikeConstants.hikeRouteKey)
        self.setValue(hike.apiID, forKey: HikeConstants.apiIDKey)
//        if !hike.userPhotos.isEmpty {
//            self.setValue(hike.userPhotos, forKey: HikeConstants.userPhotosKey)
//        }
    }
}

struct HikeConstants {
    static let typeKey = "Hike"
    fileprivate static let longitudeKey = "longitude"
    fileprivate static let latitudeKey = "latitude"
    fileprivate static let hikeNameKey = "hikeName"
    fileprivate static let hikeRatingKey = "hikeRating"
    fileprivate static let hikeRouteKey = "hikeRoute"
    fileprivate static let userPhotosKey = "userPhotos"
    fileprivate static let apiIDKey = "apiID"
}
