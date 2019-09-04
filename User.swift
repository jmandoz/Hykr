//
//  User.swift
//  Trekker
//
//  Created by Drew Seeholzer on 8/19/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit
import CloudKit

class User {
    // Class Properties
    var email: String
    var firstName: String
    var lastName: String
    var gender: String
    var age: Int
    var hikeDistance: Int
    var savedHikes: [Hike]
    var hikeLog: [Hike]
    var unitsInMiles: Bool
    var profileImageData: Data?
    var profileImage: UIImage? {
        get {
            guard let profileImageData = profileImageData else { return nil }
            return UIImage(data: profileImageData)
        } set {
            profileImageData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    var profileImageAsset: CKAsset? {
        get {
            let tempDirectory = NSTemporaryDirectory()
            let tempDirectoryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
            do {
                try profileImageData?.write(to: fileURL)
            } catch {
                print ("Error writing to temporary url \(error.localizedDescription)")
            }
            return CKAsset(fileURL: fileURL)
        }
    }
    // Cloudkit Properties
    let recordID: CKRecord.ID
    let appleUserReference: CKRecord.Reference
    
    init(email: String, firstName: String, lastName: String, gender: String, age: Int, hikeDistance: Int, savedHikes: [Hike] = [], hikeLog: [Hike] = [], unitsInMiles: Bool = true, profileImage: UIImage, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), appleUserReference: CKRecord.Reference) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.gender = gender
        self.age = age
        self.hikeDistance = hikeDistance
        self.savedHikes = savedHikes
        self.hikeLog = hikeLog
        self.unitsInMiles = unitsInMiles
        self.recordID = recordID
        self.appleUserReference = appleUserReference
        self.profileImage = profileImage
    }
}

extension User {
    /// Initializes an existing User object from a CKRecord
    convenience init?(record: CKRecord) {
        guard let email = record[UserConstants.emailKey] as? String,
        let firstName = record[UserConstants.firstNameKey] as? String,
        let lastName = record[UserConstants.lastNameKey] as? String,
        let gender = record[UserConstants.genderKey] as? String,
        let age = record[UserConstants.ageKey] as? Int,
        let hikeDistance = record[UserConstants.hikeDistanceKey] as? Int,
        let unitsInMiles = record[UserConstants.unitsInMilesKey] as? Bool,
            let profileImageAsset = record[UserConstants.profileImageKey] as? CKAsset,
        let appleUserReference = record[UserConstants.appleUserReferenceKey] as? CKRecord.Reference
            else { return nil }
        
        guard let profileImageData = try? Data(contentsOf: profileImageAsset.fileURL!),
            let photo = UIImage(data: profileImageData) else { return nil }
        let savedHikes = record[UserConstants.savedHikesKey] as? [Hike] ?? []
        let hikeLog = record[UserConstants.hikeLogKey] as? [Hike] ?? []
        
        self.init(email: email, firstName: firstName, lastName: lastName, gender: gender, age: age, hikeDistance: hikeDistance, savedHikes: savedHikes, hikeLog: hikeLog, unitsInMiles: unitsInMiles, profileImage: photo, recordID: record.recordID, appleUserReference: appleUserReference)
    }
}

extension CKRecord {
    /// Initializes a CKRecord from an existing User object
    convenience init(user: User) {
        self.init(recordType: UserConstants.typeKey, recordID: user.recordID)
        
        self.setValue(user.email, forKey: UserConstants.emailKey)
        self.setValue(user.firstName, forKey: UserConstants.firstNameKey)
        self.setValue(user.lastName, forKey: UserConstants.lastNameKey)
        self.setValue(user.gender, forKey: UserConstants.genderKey)
        self.setValue(user.age, forKey: UserConstants.ageKey)
        self.setValue(user.hikeDistance, forKey: UserConstants.hikeDistanceKey)
        //self.setValue(user.savedHikes, forKey: UserConstants.savedHikesKey)
        //self.setValue(user.hikeLog, forKey: UserConstants.hikeLogKey)
        self.setValue(user.unitsInMiles, forKey: UserConstants.unitsInMilesKey)
        self.setValue(user.profileImageAsset, forKey: UserConstants.profileImageKey)
        self.setValue(user.appleUserReference, forKey: UserConstants.appleUserReferenceKey)
        // Checks if user has any hikes, if not, user record is not initialized with the savedHikes and hikeLog properties
        if !user.savedHikes.isEmpty {
            self.setValue(user.savedHikes, forKey: UserConstants.savedHikesKey)
        }
        if !user.hikeLog.isEmpty {
            self.setValue(user.hikeLog, forKey: UserConstants.hikeLogKey)
        }
    }
}

struct UserConstants {
    static let typeKey = "User"
    fileprivate static let emailKey = "email"
    fileprivate static let firstNameKey = "firstName"
    fileprivate static let lastNameKey = "lastName"
    fileprivate static let genderKey = "gender"
    fileprivate static let ageKey = "age"
    fileprivate static let hikeDistanceKey = "hikeDistance"
    fileprivate static let savedHikesKey = "savedHikes"
    fileprivate static let hikeLogKey = "hikeLog"
    fileprivate static let unitsInMilesKey = "unitsInMiles"
    fileprivate static let profileImageDataKey = "profileImageData"
    fileprivate static let profileImageKey = "profileImage"
    fileprivate static let appleUserReferenceKey = "appleUserReference"
}
