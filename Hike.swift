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
    
    var userPhotos: [UIImage?] {
        get {
            var foundPhotos: [UIImage?] = []
            print("User Photos Data: \(self.userPhotosData.count)")
            for photo in userPhotosData {
                guard let photo = photo else { return [] }
                foundPhotos.append(UIImage(data: photo))
            }
            return foundPhotos
        } set(photos) {
            print("User Photos: \(self.userPhotos.count)")
            
            for photo in photos {
                self.userPhotosData.append(photo?.jpegData(compressionQuality: 0.5))
            }
        }
    }
    
    var userPhotosData: [Data?] = []
    var userPhotosAsset: [CKAsset?] {
        get {
            var assets: [CKAsset] = []
            for item in self.userPhotosData {
                let tempDirectory = NSTemporaryDirectory()
                let tempDirectoryURL = URL(fileURLWithPath: tempDirectory)
                let fileURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
                do {
                    try item?.write(to: fileURL)
                    assets.append(CKAsset(fileURL: fileURL))
                } catch {
                    print ("Error writing to temporary url \(error.localizedDescription)")
                }
            }
            return assets
        }
    }
    
    var apiID: Int
    var hikeAscent: Int
    var hikeDifficulty: String
    var hikeDistance: Double
    var isCompleted: Bool
    var hikeApiImageData: Data?
    var wackyUUID: String {
        return "\(hikeName)_\(hikeRating)_\(hikeDistance)"
    }
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
    var hikePhotos: [UserPhoto]
    // Cloudkit Properties
    var recordID: CKRecord.ID
    var userReference: CKRecord.Reference? {
        guard let user = user else { return nil }
        return CKRecord.Reference(recordID: user.recordID, action: .deleteSelf)
    }
    
    init(longitude: Double, latitude: Double, hikeName: String, hikeRating: Double, numberOfRatings: Int = 0, userPhotos: [UIImage] = [],
         apiID: Int, hikeAscent: Int, hikeDifficulty: String, hikeDistance: Double, isCompleted: Bool = false, hikeApiImage: UIImage, user: User?, hikePhotos: [UserPhoto] = [], recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        
        self.longitude = longitude
        self.latitude = latitude
        self.hikeName = hikeName
        self.hikeRating = hikeRating
        self.numberOfRatings = numberOfRatings
        self.apiID = apiID
        self.hikeAscent = hikeAscent
        self.hikeDifficulty = hikeDifficulty
        self.hikeDistance = hikeDistance
        self.isCompleted = isCompleted
        self.user = user
        self.hikePhotos = hikePhotos
        self.recordID = recordID
        self.userPhotos = userPhotos
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
        
        var images: [UIImage] = []
        if let userPhotosAsset = record[HikeConstants.userPhotosKey] as? [CKAsset] {
            if userPhotosAsset.count != 0 {
                for asset in userPhotosAsset {
                    guard let photoData = try? Data(contentsOf: asset.fileURL!) else { return nil }
                    guard let userPhoto = UIImage(data: photoData) else { return nil }
                    images.append(userPhoto)
                }
            }
        }
        
        guard let hikeApiImageData = try? Data(contentsOf: hikeApiImageAsset.fileURL!) else { return nil }
        guard let photo = UIImage(data: hikeApiImageData) else { return nil }
        let hikePhotos = record[HikeConstants.hikePhotosKey] as? [UserPhoto] ?? []
        
        self.init(longitude: longitude, latitude: latitude, hikeName: hikeName, hikeRating: hikeRating, numberOfRatings: numberOfRatings, userPhotos: images, apiID: apiID, hikeAscent: hikeAscent, hikeDifficulty: hikeDifficulty, hikeDistance: hikeDistance, isCompleted: isCompleted, hikeApiImage: photo, user: user, hikePhotos: hikePhotos, recordID: record.recordID)
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
        // Checks if hike has any photos, if it doesn't then it's not initialized with the hikePhotos property
        if !hike.hikePhotos.isEmpty {
            self.setValue(hike.hikePhotos, forKey: HikeConstants.hikePhotosKey)
        }
        if hike.userPhotos.count >= 1 {
            self.setValue(hike.userPhotosAsset, forKey: HikeConstants.userPhotosKey)
        }
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
    fileprivate static let hikePhotosKey = "hikePhotos"
    fileprivate static let userReferenceKey = "userReference"
}
