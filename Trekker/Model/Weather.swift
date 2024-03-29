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
