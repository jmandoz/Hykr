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
    var hikeRating: Double
    var numberOfRatings: Int
    var userPhotos: [UIImage]
    let apiID: Int
    let hikeAscent: Int
    let hikeDifficulty: String
    let hikeDistance: Double
    let hikeApiImage: UIImage
    // Cloudkit Properties
    let recordID: CKRecord.ID
    var references: [CKRecord.Reference]
    
    init(longitude: Double, latitude: Double, hikeName: String, hikeRating: Double, numberOfRatings: Int = 0, userPhotos: [UIImage] = [],
         apiID: Int, hikeAscent: Int, hikeDifficulty: String, hikeDistance: Double, hikeApiImage: UIImage, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), reference: [CKRecord.Reference]) {
        
        self.longitude = longitude
        self.latitude = latitude
        self.hikeName = hikeName
        self.hikeRating = hikeRating
        self.numberOfRatings = numberOfRatings
        self.userPhotos = userPhotos
        self.apiID = apiID
        self.hikeAscent = hikeAscent
        self.hikeDifficulty = hikeDifficulty
        self.hikeDistance = hikeDistance
        self.hikeApiImage = hikeApiImage
        self.recordID = recordID
        self.references = reference
    }
}

extension Hike {
    convenience init?(record: CKRecord) {
        guard let longitude = record[HikeConstants.longitudeKey] as? Double,
        let latitude = record[HikeConstants.latitudeKey] as? Double,
        let hikeName = record[HikeConstants.hikeNameKey] as? String,
        let hikeRating = record[HikeConstants.hikeRatingKey] as? Double,
        let numberOfRatings = record[HikeConstants.numberOfRatingsKey] as? Int,
        let apiID = record[HikeConstants.apiIDKey] as? Int,
        let hikeAscent = record[HikeConstants.hikeAscentKey] as? Int,
        let hikeDifficulty = record[HikeConstants.hikeDifficultyKey] as? String,
        let hikeDistance = record[HikeConstants.hikeDistanceKey] as? Double,
        let hikeApiImage = record[HikeConstants.hikeApiImageKey] as? UIImage,
        let references = record[HikeConstants.referenceKey] as? [CKRecord.Reference]
            else { return nil }
        
        
        self.init(longitude: longitude, latitude: latitude, hikeName: hikeName, hikeRating: hikeRating, numberOfRatings: numberOfRatings, apiID: apiID, hikeAscent: hikeAscent, hikeDifficulty: hikeDifficulty, hikeDistance: hikeDistance, hikeApiImage: hikeApiImage, recordID: record.recordID, reference: references)
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
        self.setValue(hike.apiID, forKey: HikeConstants.apiIDKey)
        self.setValue(hike.hikeAscent, forKey: HikeConstants.hikeAscentKey)
        self.setValue(hike.hikeDifficulty, forKey: HikeConstants.hikeDifficultyKey)
        self.setValue(hike.hikeDistance, forKey: HikeConstants.hikeDistanceKey)
        self.setValue(hike.hikeApiImage, forKey: HikeConstants.hikeApiImageKey)
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
    fileprivate static let userPhotosKey = "userPhotos"
    fileprivate static let apiIDKey = "apiID"
    fileprivate static let hikeAscentKey = "hikeAscent"
    fileprivate static let hikeDifficultyKey = "hikeDifficulty"
    fileprivate static let hikeDistanceKey = "hikeDistance"
    fileprivate static let hikeApiImageKey = "hikeApiImage"
    fileprivate static let referenceKey = "reference"
}
