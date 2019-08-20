//
//  NetworkController.swift
//  Trekker
//
//  Created by Drew Seeholzer on 8/20/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import Foundation

struct NetworkController {
    
    let baseURL = HikeAPIStrings.baseURL
    let components = [HikeAPIStrings.tripsComponent]
    let queryItems = [HikeAPIStrings.apiKey: HikeAPIStrings.apiKeyValue]
    
    func buildURL(baseURL: String, components: [String], queryItems: [String : String], completion: @escaping (URL?) -> Void) {
        guard var url = URL(string: baseURL) else { completion(nil); return }
        for component in components {
            url.appendPathComponent(component)
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let query: [URLQueryItem] = queryItems.compactMap {URLQueryItem(name: $0.key, value: $0.value)}
        components?.queryItems = query
        
        guard let finalURL = components?.url else { completion(nil); return }
        completion(finalURL)
    }
}
