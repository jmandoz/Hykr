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
    
    // User data/SOTs
    var currentUser: User?
    var currentHike: Hike?
    
    // Database instances
    let publicDB = "insert CK database instance here"
    let privateDB = "insert CK database instance here"
    
    // MARK: - CRUD
    
    //Create
    func createUserWith(email: String, firstName: String, lastName: String, gender: String, age: Int, hikeDistance: Int, completion: @escaping (User?) -> Void) {
        
    }
    
    // Read
    
    func fetchUser(completion: @escaping (Bool) -> Void) {
        
    }
    
    // Update
    
    func updateUserInfo(user: User, email: String?, firstName: String?, lastName: String?, gender: String?, age: Int?, hikeDistance: Int?) {
        
    }
    
    func saveHike(user: User, hike: Hike, completion: @escaping (Bool) -> Void) {
        
    }
    
    func addToHikeLog(user: User, hike: Hike, completion: @escaping (Bool) -> Void) {
        
    }
    
    // Delete
    
    func removeSavedHike(user: User, hike: Hike, completion: @escaping (Bool) -> Void) {
        guard let index = user.savedHikes.firstIndex(of: hike) else { return }
        user.savedHikes.remove(at: index)
        //TODO: Insert CK Functions
    }
    
    func removeHikeFromLog(user: User, hike: Hike, completion: @escaping (Bool) -> Void) {
        guard let index = user.hikeLog.firstIndex(of: hike) else { return }
        user.hikeLog.remove(at: index)
        
    }
}
