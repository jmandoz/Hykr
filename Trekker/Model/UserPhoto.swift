//
//  UserPhoto.swift
//  Trekker
//
//  Created by Drew Seeholzer on 8/29/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit
import CloudKit

class UserPhoto {
    var userPhoto: UIImage? {
        get {
            guard let userPhotoData = userPhotoData else { return nil }
            return UIImage(data: userPhotoData)
        } set {
            userPhotoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    var userPhotoData: Data?
    var userPhotoAsset: CKAsset? {
        get {
            let tempDirectory = NSTemporaryDirectory()
            let tempDirectoryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathComponent("jpg")
            do {
                try userPhotoData?.write(to: fileURL)
            } catch {
                print ("Error writing to temporary url \(error.localizedDescription)")
            }
            return CKAsset(fileURL: fileURL)
        }
    }
   weak var hike: Hike?
    // CK Properties
    let recordID: CKRecord.ID
    var hikeReference: CKRecord.Reference? {
        guard let hike = hike else { return nil }
        return CKRecord.Reference(recordID: hike.recordID, action: .deleteSelf)
    }
    
    init(userPhoto: UIImage, hike: Hike?, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        
        self.hike = hike
        self.recordID = recordID
        self.userPhoto = userPhoto
        
    }
}

extension UserPhoto {
    convenience init?(record: CKRecord, hike: Hike) {
        guard let userPhotoAsset = record[UserPhotoConstants.userPhotoKey] as? CKAsset else { return nil }
        
        guard let userPhotoData = try? Data(contentsOf: userPhotoAsset.fileURL!),
        let photo = UIImage(data: userPhotoData) else { return nil }
        
        self.init(userPhoto: photo, hike: hike, recordID: record.recordID)
    }
}

extension UserPhoto: Equatable {
    static func == (lhs: UserPhoto, rhs: UserPhoto) -> Bool {
        return lhs.recordID == rhs.recordID
    }
    
    
}

extension CKRecord {
    convenience init(userPhoto: UserPhoto) {
        self.init(recordType: UserPhotoConstants.typeKey, recordID: userPhoto.recordID)
        self.setValue(userPhoto.userPhotoAsset, forKey: UserPhotoConstants.userPhotoKey)
        self.setValue(userPhoto.hikeReference, forKey: UserPhotoConstants.hikeReferenceKey)
    }
}

struct UserPhotoConstants {
    static let typeKey = "UserPhoto"
    fileprivate static let userPhotoKey = "userPhoto"
    fileprivate static let hikeReferenceKey = "hikeReference"
}
