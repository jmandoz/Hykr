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
    var longitude: Double
    var latitude: Double
    var hikeName: String
    var hikeRating: Double
    var numberOfRatings: Int
    var userPhotos: [UIImage]
    var apiID: Int
    var hikeAscent: Int
    var hikeDifficulty: String
    var hikeDistance: Double
    var isCompleted: Bool
    var hikeApiImageData: Data?
    var hikeApiImage: UIImage? {
        get {
            guard let hikeApiImageData = hikeApiImageData else { return nil }
            return UIImage(data: hikeApiImageData)
        } set {
            hikeApiImageData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    var hikeApiImageAsset: CKAsset? {
        get {
            let tempDirectory = NSTemporaryDirectory()
            let tempDirectoryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
            do {
                try hikeApiImageData?.write(to: fileURL)
            } catch {
                print ("Error writing to temporary url \(error.localizedDescription)")
            }
            return CKAsset(fileURL: fileURL)
        }
    }
    weak var user: User?
    // Cloudkit Properties
    var recordID: CKRecord.ID
    var userReference: CKRecord.Reference? {
        guard let user = user else { return nil }
        return CKRecord.Reference(recordID: user.recordID, action: .deleteSelf)
    }
    
    init(longitude: Double, latitude: Double, hikeName: String, hikeRating: Double, numberOfRatings: Int = 0, userPhotos: [UIImage] = [],
         apiID: Int, hikeAscent: Int, hikeDifficulty: String, hikeDistance: Double, isCompleted: Bool = false, hikeApiImage: UIImage, user: User?, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        
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
        self.isCompleted = isCompleted
        self.user = user
        self.recordID = recordID
        self.hikeApiImage = hikeApiImage
    }
    
//    var userReference: CKRecord.Reference? {
//        guard let user = user else { return nil }
//        return CKRecord.Reference(recordID: user.recordID, action: .deleteSelf)
//    }

}

extension Hike {
    convenience init?(record: CKRecord, user: User) {
        guard let longitude = record[HikeConstants.longitudeKey] as? Double,
        let latitude = record[HikeConstants.latitudeKey] as? Double,
        let hikeName = record[HikeConstants.hikeNameKey] as? String,
        let hikeRating = record[HikeConstants.hikeRatingKey] as? Double,
        let numberOfRatings = record[HikeConstants.numberOfRatingsKey] as? Int,
        let apiID = record[HikeConstants.apiIDKey] as? Int,
        let hikeAscent = record[HikeConstants.hikeAscentKey] as? Int,
        let hikeDifficulty = record[HikeConstants.hikeDifficultyKey] as? String,
        let hikeDistance = record[HikeConstants.hikeDistanceKey] as? Double,
            let isCompleted = record[HikeConstants.isCompletedKey] as? Bool,
        let hikeApiImageAsset = record[HikeConstants.hikeApiImageKey] as? CKAsset
            else { return nil }
        
        guard let hikeApiImageData = try? Data(contentsOf: hikeApiImageAsset.fileURL!) else { return nil }
        guard let photo = UIImage(data: hikeApiImageData) else { return nil }
        
        self.init(longitude: longitude, latitude: latitude, hikeName: hikeName, hikeRating: hikeRating, numberOfRatings: numberOfRatings, apiID: apiID, hikeAscent: hikeAscent, hikeDifficulty: hikeDifficulty, hikeDistance: hikeDistance, isCompleted: isCompleted, hikeApiImage: photo, user: user, recordID: record.recordID)
//        self.longitude = longitude
//        self.latitude = latitude
//        self.hikeName = hikeName
//        self.hikeRating = hikeRating
//        self.numberOfRatings = numberOfRatings
        
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
        self.setValue(hike.isCompleted, forKey: HikeConstants.isCompletedKey)
        self.setValue(hike.hikeApiImageAsset, forKey: HikeConstants.hikeApiImageKey)
        self.setValue(hike.userReference, forKey: HikeConstants.userReferenceKey)
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
    fileprivate static let isCompletedKey = "isCompleted"
    fileprivate static let hikeApiImageDataKey = "hikeApiImageData"
    fileprivate static let hikeApiImageKey = "hikeApiImage"
    fileprivate static let userReferenceKey = "userReference"
}
