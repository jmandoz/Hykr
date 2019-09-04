//
//  Weather.swift
//  Trekker
//
//  Created by Drew Seeholzer on 8/19/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//
//f33676465250529f194d06f3183a648b
import Foundation


struct Weather: Decodable {
    var conditions: [WeatherDetails]
    var temperature: Temp
    var windSpeed: WindSpeed
    
    enum CodingKeys: String, CodingKey {
        case conditions = "weather"
        case temperature = "main"
        case windSpeed = "wind"
    }
}

struct WeatherDetails: Decodable {
    let conditions: String
    let conditionsDescription: String
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case conditions = "main"
        case conditionsDescription = "description"
        case icon
    }
}

struct Temp: Decodable {
    let temp: Double
}

struct WindSpeed: Decodable {
    let speed: Double
}

struct WeatherAPIStrings {
    static let baseURL = "https://api.openweathermap.org/data/2.5"
    static let components = "weather"
    static let latitudeQuery = "lat"
    static let longitudeQuery = "lon"
    static let unitsQuery = "units"
    static let unitsQueryValue = "imperial"
    static let apiKey = "APPID"
    static let apiKeyValue = "f33676465250529f194d06f3183a648b"
}
