//
//  NetworkController.swift
//  Trekker
//
//  Created by Drew Seeholzer on 8/20/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import Foundation

struct NetworkController {
    
    static let sharedInstance = NetworkController()
    
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
    
    func getDataFromURL(url: URL, completion: @escaping (Data?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print ("Error in \(#function) : \(error.localizedDescription) /n---/n \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else { completion(nil); return }
            completion(data)
            
        }.resume()
    }
}
