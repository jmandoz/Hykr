//
//  HikeController.swift
//  Trekker
//
//  Created by Drew Seeholzer on 8/20/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import Foundation
import CloudKit

class HikeController {
    
    static let sharedInstance = HikeController()
    
    var currentHike: Hike?
    
    let publicDB = "Insert CK database here"
    
    //CRUD
    
    //Create
    
    func createHikeWith(longitude: Double, latitude: Double, hikeName: String, hikeRating: Double, hikeRoute: [[Double]], apiID: Int, completion: @escaping (Hike?) -> Void) {
        
    }
    
    // Read
    
    func fetchHike(completion: @escaping (Bool) -> Void) {
        
    }
    
    // Update
    
    // Currently only set to work for the user, not global rating
    func updateRating(hike: Hike, hikeRating: Int) {
        hike.hikeRating = hikeRating
        hike.numberOfRatings += 1
        
        let recordToSave = CKRecord(hike: hike)
        
    }
    
    // Delete
}
