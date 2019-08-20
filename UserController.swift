//
//  UserController.swift
//  Trekker
//
//  Created by Drew Seeholzer on 8/20/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import Foundation
import CloudKit

class UserController {
    
    static let sharedInstance = UserController()
    

    var currentUser: User?
    
    
    // Database instances
    let publicDB = CloudKitController.shared.publicDB
    
    // MARK: - CRUD
    
    //Create
    func createUserWith(email: String, firstName: String, lastName: String, gender: String, age: Int, hikeDistance: Int, completion: @escaping (User?) -> Void) {
        
        CloudKitController.shared.fetchAppleUserReference { (reference) in
            guard let appleUserReference = reference else { completion(nil) ; return }
            let newUser = User(email: email, firstName: firstName, lastName: lastName, gender: gender, age: age, hikeDistance: hikeDistance, appleUserReference: appleUserReference)
            let userRecord = CKRecord(user: newUser)
            let database = self.publicDB
            
            CloudKitController.shared.save(record: userRecord, database: database, completion: { (record) in
                guard let record = record,
                let user = User(record: record)
                    else { completion(nil) ; return }
                
                self.currentUser = user
                completion(user)
            })
        }
    }
    
    // Read
    
    func fetchUser(completion: @escaping (Bool) -> Void) {
        
        CloudKitController.shared.fetchAppleUserReference { (reference) in
            guard let appleUserReference = reference else { completion(false) ; return }
            
            let predicate = NSPredicate(format: "appleUserReference == %@", appleUserReference)
            let database = self.publicDB
            CloudKitController.shared.fetchRecords(ofType: UserConstants.typeKey, withPredicate: predicate, database: database, completion: { (records) in
                
                guard let records = records,
                let record = records.first
                    else { completion(false) ; return }
                
                self.currentUser = User(record: record)
                completion(true)
            })
        }
    }
    
    // Update
    
    // TODO: Grab user values to update outside of this function
    func updateUserInfo(user: User) {
        let recordToSave = CKRecord(user: user)
        let database = self.publicDB
        
        CloudKitController.shared.update(record: recordToSave, database: database) { (success) in
            if success {
                print("User updated succesfully")
            } else {
                print("User failed to update")
            }
        }
    }
    
    func saveHike(user: User, hike: Hike, completion: @escaping (Bool) -> Void) {
        
        user.savedHikes.append(hike)
        
        let recordToSave = CKRecord(user: user)
        let database = self.publicDB
        
        CloudKitController.shared.update(record: recordToSave, database: database) { (success) in
            if success {
                print("Hike saved succesfully")
            } else {
                print("Hike failed to save")
            }
        }
        
    }
    
    func addToHikeLog(user: User, hike: Hike, completion: @escaping (Bool) -> Void) {
        
        user.hikeLog.append(hike)
        
        let recordToSave = CKRecord(user: user)
        let database = self.publicDB
        
        CloudKitController.shared.update(record: recordToSave, database: database) { (success) in
            if success {
                print("Hike log updated succesfully")
            } else {
                print("Hike log failed to update")
            }
        }
    }
    
    // Delete
    
    func removeSavedHike(user: User, hike: Hike, completion: @escaping (Bool) -> Void) {
        guard let index = user.savedHikes.firstIndex(of: hike) else { return }
        user.savedHikes.remove(at: index)
        
        let database = self.publicDB
        CloudKitController.shared.delete(recordID: hike.recordID, database: database) { (success) in
            completion(success ? true : false)
        }
    }
    
    func removeHikeFromLog(user: User, hike: Hike, completion: @escaping (Bool) -> Void) {
        guard let index = user.hikeLog.firstIndex(of: hike) else { return }
        user.hikeLog.remove(at: index)
        
        let database = self.publicDB
        CloudKitController.shared.delete(recordID: hike.recordID, database: database) { (success) in
            completion(success ? true : false)
        }
    }
}
