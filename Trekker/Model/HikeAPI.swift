//
//  HikeAPI.swift
//  Trekker
//
//  Created by Drew Seeholzer on 8/20/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import Foundation

// Primary hike JSON

struct TopLevelJSON: Decodable {
    
    let trails: [HikeJSON]
}

struct HikeJSON: Decodable {
    let longitude: Double
    let latitude: Double
    let hikeName: String
    let apiID: Int
    let hikeImageURLAsString: String
    let hikeRating: Double
    
    enum CodingKeys: String, CodingKey {
        case longitude
        case latitude
        case hikeName = "name"
        case apiID = "id"
        case hikeImageURLAsString = "imgSmallMed"
        case hikeRating = "stars"
    }
}

struct HikeAPIStrings {
    static let baseURL = "https://www.hikingproject.com/data/get-trails"
    static let latitudeQuery = "lat"
    static let longitudeQuery = "lon"
   static let apiKey = "key"
   static let apiKeyValue = "200558723-bb50c93f3346f8a98fefed60f3a8b2dc"
}
