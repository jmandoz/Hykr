//
//  Hike.swift
//  Trekker
//
//  Created by Drew Seeholzer on 8/19/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit
import CloudKit

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
    
    init(longitude: Double, latitude: Double, hikeName: String, hikeRating: Int, numberOfRatings: Int = 0, hikeRoute: [[Double]], userPhotos: [UIImage] = [],
         apiID: Int, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        
        self.longitude = longitude
        self.latitude = latitude
        self.hikeName = hikeName
        self.hikeRating = hikeRating
        self.numberOfRatings = numberOfRatings
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
        let hikeRating = record[HikeConstants.hikeRatingKey] as? Int,
        let numberOfRatings = record[HikeConstants.numberOfRatingsKey] as? Int,
        let hikeRoute = record[HikeConstants.hikeRouteKey] as? [[Double]],
        let apiID = record[HikeConstants.apiIDKey] as? Int
            else { return nil }
        
        
        self.init(longitude: longitude, latitude: latitude, hikeName: hikeName, hikeRating: hikeRating, numberOfRatings: numberOfRatings, hikeRoute: hikeRoute, apiID: apiID, recordID: record.recordID)
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
}


// MARK: - API Structs


// Primary hike JSON
struct HikeJSON: Decodable {
    let coordinates: Coordinates
    let hikeName: String
    let apiID: Int
    let hikeImages: [HikeImagesJSON?]
    
    enum CodingKeys: String, CodingKey {
        case coordinates = "starting_trailhead_id"
        case hikeName = "name"
        case apiID = "id"
        case hikeImages = "medium"
    }
}

struct Coordinates: Decodable {
    let latitude: Double
    let longitude: Double
}

// Route coordinates JSON
struct HikeRouteJSON: Decodable {
    let route: String
}

// Hike images JSON
struct HikeImagesJSON: Decodable {
    let imageURLAsString: String?
    
    enum CodingKeys: String, CodingKey {
        case imageURLAsString = "medium"
    }
}
