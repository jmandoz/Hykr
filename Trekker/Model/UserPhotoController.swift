//
//  UserPhotoController.swift
//  Trekker
//
//  Created by Drew Seeholzer on 8/29/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit
import CloudKit

class UserPhotoController {
    
    static let sharedInstance = UserPhotoController()
    
    let publicDB = CloudKitController.shared.publicDB
    
    //CRUD
    
    //Create
    
    func createUserPhotoWith(userPhoto: UIImage, hike: Hike, completion: @escaping (UserPhoto?) -> Void) {
        let userPhoto = UserPhoto(userPhoto: userPhoto, hike: hike)
        let record = CKRecord(userPhoto: userPhoto)
        let database = self.publicDB
        
        CloudKitController.shared.save(record: record, database: database) { (record) in
            if let record = record {
                guard let savedPhoto = UserPhoto(record: record, hike: hike) else { completion(nil) ; return }
                completion(savedPhoto)
            } else {
                completion(nil)
                return
            }
        }
    }
    
    // Read
    
    func fetchUserPhotos(hike: Hike, predicate: NSCompoundPredicate, completion: @escaping ([UserPhoto]?) -> Void) {
        
        CloudKitController.shared.fetchRecords(ofType: UserPhotoConstants.typeKey, withPredicate: predicate, database: self.publicDB) { (foundRecords) in
            guard let foundRecords = foundRecords else { completion(nil) ; return }
            let photos = foundRecords.compactMap({ UserPhoto(record: $0, hike: hike) })
            completion(photos)
        }
    }
    
    // Update
    
    // Delete
    
    func deleteUserPhoto(userPhoto: UserPhoto, hike: Hike, completion: @escaping (Bool) -> Void) {
        guard let index = hike.hikePhotos.firstIndex(of: userPhoto) else { completion(false) ; return }
        hike.hikePhotos.remove(at: index)
        
        let database = self.publicDB
        CloudKitController.shared.delete(recordID: userPhoto.recordID, database: database) { (success) in
            completion(success ? true : false)
        }
    }
}
