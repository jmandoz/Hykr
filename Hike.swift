//
//  Hike.swift
//  Trekker
//
//  Created by Drew Seeholzer on 8/19/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit
import CloudKit

//TODO: Figure out if hike is completed property
class Hike {
    let longitude: Double
    let latitude: Double
    let hikeName: String
    var hikeRating: Int
    var numberOfRatings: Int
    let hikeRoute: [[Double]]
    var userPhotos: [UIImage]
    let apiID: Int
    // Cloudkit Properties
    let recordID: CKRecord.ID
    var references: [CKRecord.Reference]
    
    init(longitude: Double, latitude: Double, hikeName: String, hikeRating: Int, numberOfRatings: Int = 0, hikeRoute: [[Double]], userPhotos: [UIImage] = [],
         apiID: Int, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), reference: [CKRecord.Reference]) {
        
        self.longitude = longitude
        self.latitude = latitude
        self.hikeName = hikeName
        self.hikeRating = hikeRating
        self.numberOfRatings = numberOfRatings
        self.hikeRoute = hikeRoute
        self.userPhotos = userPhotos
        self.apiID = apiID
        self.recordID = recordID
        self.references = reference
    }
}

extension Hike {
    convenience init?(record: CKRecord) {
        guard let longitude = record[HikeConstants.longitudeKey] as? Double,
        let latitude = record[HikeConstants.latitudeKey] as? Double,
        let hikeName = record[HikeConstants.hikeNameKey] as? String,
        let hikeRating = record[HikeConstants.hikeRatingKey] as? Int,
        let numberOfRatings = record[HikeConstants.numberOfRatingsKey] as? Int,
        let hikeRoute = record[HikeConstants.hikeRouteKey] as? [[Double]],
        let apiID = record[HikeConstants.apiIDKey] as? Int,
        let references = record[HikeConstants.referenceKey] as? [CKRecord.Reference]
            else { return nil }
        
        
        self.init(longitude: longitude, latitude: latitude, hikeName: hikeName, hikeRating: hikeRating, numberOfRatings: numberOfRatings, hikeRoute: hikeRoute, apiID: apiID, recordID: record.recordID, reference: references)
    }
}

extension Hike: Equatable {
    static func == (lhs: Hike, rhs: Hike) -> Bool {
        return lhs.recordID == rhs.recordID
    }
    
    
}

extension CKRecord {
    convenience init(hike: Hike) {
        self.init(recordType: HikeConstants.typeKey, recordID: hike.recordID)
        self.setValue(hike.longitude, forKey: HikeConstants.longitudeKey)
        self.setValue(hike.latitude, forKey: HikeConstants.latitudeKey)
        self.setValue(hike.hikeName, forKey: HikeConstants.hikeNameKey)
        self.setValue(hike.hikeRating, forKey: HikeConstants.hikeRatingKey)
        self.setValue(hike.numberOfRatings, forKey: HikeConstants.numberOfRatingsKey)
        self.setValue(hike.hikeRoute, forKey: HikeConstants.hikeRouteKey)
        self.setValue(hike.apiID, forKey: HikeConstants.apiIDKey)
        self.setValue(hike.references, forKey: HikeConstants.referenceKey)
        //TODO: Find out if we need userPhotos CKRecord
    }
}

struct HikeConstants {
    static let typeKey = "Hike"
    fileprivate static let longitudeKey = "longitude"
    fileprivate static let latitudeKey = "latitude"
    fileprivate static let hikeNameKey = "hikeName"
    fileprivate static let hikeRatingKey = "hikeRating"
    fileprivate static let numberOfRatingsKey = "numberOfRatings"
    fileprivate static let hikeRouteKey = "hikeRoute"
    fileprivate static let userPhotosKey = "userPhotos"
    fileprivate static let apiIDKey = "apiID"
    fileprivate static let referenceKey = "reference"
}
