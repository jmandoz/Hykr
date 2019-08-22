//
//  HikeDetailsViewController.swift
//  Trekker
//
//  Created by Jason Mandozzi on 8/19/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class HikeDetailsViewController: UIViewController {
    
    let hike = HikeJSON(longitude: -105.2979, latitude: 40.02, hikeName: "Sunshine Lion's Lair Loop", apiID: 7004226, hikeImageURLAsString: "https://cdn-files.apstatic.com/hike/7039883_smallMed_1555092747.jpg", hikeRating: 4.5, ascent: 1261, difficulty: "blue", distance: 5.3)
    
    
    // Rename this back to hike
    var temphike: HikeJSON?
    
    //Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var directionsButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var hikeMapButton: UIButton!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var hikeNameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var ascentLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var currentWeatherLabel: UILabel!
    
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        displayHikeInfo(hike: hike)
        fetchWeatherInfo(hike: hike)
    }
    
    func fetchWeatherInfo(hike: HikeJSON) {
       // guard let hike = hike else { return }
        let queryItems = [WeatherAPIStrings.latitudeQuery : "\(hike.latitude)", WeatherAPIStrings.longitudeQuery : "\(hike.longitude)", WeatherAPIStrings.unitsQuery : WeatherAPIStrings.unitsQueryValue, WeatherAPIStrings.apiKey : WeatherAPIStrings.apiKeyValue]
        guard let url = NetworkController.sharedInstance.buildURL(baseURL: WeatherAPIStrings.baseURL, components: [WeatherAPIStrings.components], queryItems: queryItems) else { return }
        NetworkController.sharedInstance.getDataFromURL(url: url) { (data) in
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let topLevelJSON = try decoder.decode(Weather.self, from: data)
                let weatherConditions = topLevelJSON.conditions
                
                self.currentWeatherLabel.text = weatherConditions[0].conditionsDescription
            } catch {
                print ("Error decoding data: \(error.localizedDescription)")
                return
            }
        }
    }
    
    func fetchHikeImage(hike: HikeJSON, completion: @escaping (UIImage?) -> Void) {
        
        guard let imageURLAsString = hike.hikeImageURLAsString,
        let url = URL(string: imageURLAsString)
            else { completion(nil); return }
        
        NetworkController.sharedInstance.getDataFromURL(url: url) { (data) in
            
            if let data = data {
                guard let postImage = UIImage(data: data) else { completion (nil); return }
                completion(postImage)
            }
        }
    }
    
    func displayHikeInfo(hike: HikeJSON) {
        //guard let hike = hike else { return }
        fetchHikeImage(hike: hike) { (image) in
            if image != nil{
                self.imageView.image = image
            }
        }
        hikeNameLabel.text = hike.hikeName
        // TODO: Figure out way to make rating not default to zero if rating is absent
        ratingLabel.text = "\(hike.hikeRating ?? 0)"
        difficultyLabel.text = hike.difficulty
        distanceLabel.text = "\(hike.distance)"
        ascentLabel.text = "\(hike.ascent)"
    }
    
    //Actions
    @IBAction func directionsButtonTapped(_ sender: Any) {
    }
    
    @IBAction func hikeMapButtonTapped(_ sender: Any) {
    }
    
    @IBAction func completeButtonTapped(_ sender: Any) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

