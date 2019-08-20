//
//  HikeAPI.swift
//  Trekker
//
//  Created by Drew Seeholzer on 8/20/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import Foundation

// Primary hike JSON
struct HikeJSON: Decodable {
    let coordinates: Coordinates
    let hikeName: String
    let apiID: Int
    let hikeImages: [HikeImagesJSON?]
    
    enum CodingKeys: String, CodingKey {
        case coordinates = "starting_trailhead_id"
        case hikeName = "name"
        case apiID = "id"
        case hikeImages = "medium"
    }
}

struct Coordinates: Decodable {
    let latitude: Double
    let longitude: Double
}

// Route coordinates JSON
struct HikeRouteJSON: Decodable {
    let route: String
}

// Hike images JSON
struct HikeImagesJSON: Decodable {
    let imageURLAsString: String?
    
    enum CodingKeys: String, CodingKey {
        case imageURLAsString = "medium"
    }
}

struct HikeAPIStrings {
    static let baseURL = "https://api.transitandtrails.org/api/v1"
    static let tripsComponent = "trips"
   static let apiKey = "key"
   static let apiKeyValue = "2a4e49414c8400a3219a127e803e6f965684fdb6a777b0bf1dc7c5f3e2270093"
}
