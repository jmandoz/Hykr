//
//  HikeController.swift
//  Trekker
//
//  Created by Drew Seeholzer on 8/20/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit
import CloudKit

class HikeController {
    
    static let sharedInstance = HikeController()
    
    var currentHike: Hike?
    
    let publicDB = CloudKitController.shared.publicDB
    
    //CRUD
    
    //Create
    
    // After completion, append that hike to User's hike array
    func createHikeWith(longitude: Double, latitude: Double, hikeName: String, hikeRating: Double, apiID: Int, hikeAscent: Int, hikeDifficulty: String, hikeDistance: Double, hikeApiImage: UIImage, user: User, completion: @escaping (Hike?) -> Void) {
        
        guard let user = UserController.sharedInstance.currentUser else { completion(nil) ; return }
        let hike = Hike(longitude: longitude, latitude: latitude, hikeName: hikeName, hikeRating: hikeRating, apiID: apiID, hikeAscent: hikeAscent, hikeDifficulty: hikeDifficulty, hikeDistance: hikeDistance, hikeApiImage: hikeApiImage, user: user)
        let record = CKRecord(hike: hike)
        let database = self.publicDB
        
        CloudKitController.shared.save(record: record, database: database) { (record) in
            if let record = record {
                let savedHike = Hike(record: record, user: user)
                completion(savedHike)
            } else {
                completion(nil)
                return
            }
        }
    }
    
//    func checkHikeStatus(apiID: Int, completion: @escaping (Bool) -> Void) {
//        guard let user = UserController.sharedInstance.currentUser else { completion(false) ; return }
//       // let predicate = NSPredicate(format: "apiID == %@", apiID)
//        let predicate = NSPredicate(value: true)
//        CloudKitController.shared.fetchRecords(ofType: HikeConstants.typeKey, withPredicate: predicate, database: self.publicDB) { (records) in
//            if let records = records {
//                let hike = Hike(record: records.first!)
//                if let hike = hike {
//                    let reference = CKRecord.Reference(recordID: user.recordID, action: .none)
//                    hike.references.append(reference)
//                    user.savedHikes.append(hike)
//                    // Update the hike here
//                    self.update(hike: hike, completion: { (success) in
//                        if success {
//                            completion(true)
//                        }
//                    })
//                }
//            } else {
//                completion(false)
//                return
//                // if completion false call the save function
//            }
//        }
//    }
    
    // Read
    
    func fetchHikes(user: User, predicate: NSCompoundPredicate, completion: @escaping ([Hike]?) -> Void) {
        
        CloudKitController.shared.fetchRecords(ofType: HikeConstants.typeKey, withPredicate: predicate, database: self.publicDB) { (foundRecords) in
            guard let foundRecords = foundRecords else { completion(nil) ; return }
            // Loops through array of records and inits a hike from each, appends it to the temp array.
//            var hikeRecords: [Hike] = []
//            for record in foundRecords {
//                guard let hike = Hike(record: record) else { continue }
//                hikeRecords.append(hike)
//            }
            // Same as above just using .compactMap
            let hikes = foundRecords.compactMap({ Hike(record: $0, user: user) })
            completion(hikes)
        }
    }
    
    // Update
    
    // Currently only set to work for the user, not global rating
    func updateRating(hike: Hike, hikeRating: Double) {
        hike.hikeRating = hikeRating
        hike.numberOfRatings += 1
        
        let recordToSave = CKRecord(hike: hike)
        let database = self.publicDB
        
        CloudKitController.shared.update(record: recordToSave, database: database) { (success) in
            if success {
                print("Rating updated successfully")
            } else {
                print ("Rating failed to update")
            }
        }
        
    }
    
    func update(hike: Hike, completion: @escaping (Bool) -> Void) {
        let recordToSave = CKRecord(hike: hike)
        let database = self.publicDB
        
        CloudKitController.shared.update(record: recordToSave, database: database) { (success) in
            if success {
                print("Hike updated succesfully")
                completion(true)
            } else {
                print("Hike failed to update")
                completion(false)
                return
            }
        }
    }
    
    // Delete
    
    func deleteSavedHike(hike: Hike, completion: @escaping (Bool) -> Void) {
        guard let index = UserController.sharedInstance.currentUser?.savedHikes.firstIndex(of: hike) else { return }
        UserController.sharedInstance.currentUser?.savedHikes.remove(at: index)
        
        let database = self.publicDB
        CloudKitController.shared.delete(recordID: hike.recordID, database: database) { (success) in
            completion(success ? true : false)
        }
    }
    
    func removeSavedHike(user: User, hike: Hike, completion: @escaping (Bool) -> Void) {
        guard let index = user.savedHikes.firstIndex(of: hike) else { return }
        user.savedHikes.remove(at: index)
        
        let recordToSave = CKRecord(user: user)
        let database = self.publicDB
        
        CloudKitController.shared.update(record: recordToSave, database: database) { (success) in
            if success {
                print("Saved hike removed succesfully")
                completion(true)
            } else {
                print("Saved hike was not removed")
                completion(false)
            }
        }
    }
    
    func removeHikeFromLog(user: User, hike: Hike, completion: @escaping (Bool) -> Void) {
        guard let index = user.hikeLog.firstIndex(of: hike) else { return }
        user.hikeLog.remove(at: index)
        
        let recordToSave = CKRecord(user: user)
        let database = self.publicDB
        
        CloudKitController.shared.update(record: recordToSave, database: database) { (success) in
            if success {
                print("Hike log hike removed succesfully")
                completion(true)
            } else {
                print("Hike log hike was not removed")
                completion(false)
            }
        }
    }
}
