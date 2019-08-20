//
//  CloudKitController.swift
//  Trekker
//
//  Created by Jason Mandozzi on 8/20/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitController {
    
    //Shared Instance
    static let shared = CloudKitController()
    
    //Database
    let publicDB = CKContainer.default().publicCloudDatabase
    
    //CRUD
    
    //Create
    func save(record: CKRecord, database: CKDatabase, completion: @escaping (CKRecord?) -> Void) {
        database.save(record) { (record, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) /n---/n \(error)")
                completion(nil)
            }
            completion(record)
        }
    }
    
    //Read
    func fetchAppleUserReference(completion: @escaping (CKRecord.Reference?) -> Void) {
        CKContainer.default().fetchUserRecordID { (appleUserReferenceID, error) in
            if let error = error {
                print("\(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let referenceID = appleUserReferenceID else {completion(nil); return}
            let appleUserReference = CKRecord.Reference(recordID: referenceID, action: .deleteSelf)
            completion(appleUserReference)
        }
    }
    
    func fetchRecords(ofType type: String, withPredicate predicate: NSPredicate, database: CKDatabase, completion: @escaping ([CKRecord]?) -> Void) {
        let query = CKQuery(recordType: type, predicate: predicate)
        database.perform(query, inZoneWith: nil) { (record, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) /n---/n \(error)")
                completion(nil)
            }
            guard let record = record else {completion(nil); return}
            completion(record)
        }
    }
    
    //Update
    func update(record: CKRecord, database: CKDatabase, completion: @escaping (Bool) -> Void) {
        //Declare the operation
        let operation = CKModifyRecordsOperation()
        //Override the operation attributes
        operation.recordsToSave = [record]
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.queuePriority = .high
        operation.completionBlock = {
            completion(true)
        }
        //To edit a record, it requires an operation
        database.add(operation)
    }
    
    //Delete
    func delete(recordID: CKRecord.ID, database: CKDatabase, completion: @escaping (Bool) -> Void) {
        database.delete(withRecordID: recordID) { (_, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) /n---/n \(error)")
                completion(false)
            }
            completion(true)
        }
    }
}
