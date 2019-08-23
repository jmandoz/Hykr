//
//  HikeDetailsViewController.swift
//  Trekker
//
//  Created by Jason Mandozzi on 8/19/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class HikeDetailsViewController: UIViewController {
    
    var hike: HikeJSON?
    
    var hikeImage: UIImage?
    
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
        displayHikeInfo()
        fetchWeatherInfo()
    }
    
    func fetchWeatherInfo() {
        guard let hike = hike else { return }
        let queryItems = [WeatherAPIStrings.latitudeQuery : "\(hike.latitude ?? 0)", WeatherAPIStrings.longitudeQuery : "\(hike.longitude ?? 0)", WeatherAPIStrings.unitsQuery : WeatherAPIStrings.unitsQueryValue, WeatherAPIStrings.apiKey : WeatherAPIStrings.apiKeyValue]
        guard let url = NetworkController.sharedInstance.buildURL(baseURL: WeatherAPIStrings.baseURL, components: [WeatherAPIStrings.components], queryItems: queryItems) else { return }
        print (url)
        NetworkController.sharedInstance.getDataFromURL(url: url) { (data) in
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let topLevelJSON = try decoder.decode(Weather.self, from: data)
                let weatherConditions = topLevelJSON.conditions
                
                DispatchQueue.main.async {
                    self.currentWeatherLabel.text = weatherConditions[0].conditionsDescription
                }
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
    
    func displayHikeInfo() {
        guard let hike = hike else { return }
        fetchHikeImage(hike: hike) { (image) in
            if image != nil{
                DispatchQueue.main.async {
                    self.hikeImage = image
                    self.imageView.image = image
                }
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
        print("debug step")
    }
    
    @IBAction func hikeMapButtonTapped(_ sender: Any) {
    }
    
    @IBAction func completeButtonTapped(_ sender: Any) {
    }
    
    @IBAction func heartButtonTapped(_ sender: Any) {
        guard let hikeImage = hikeImage else { return }
        guard let user = UserController.sharedInstance.currentUser,
            let hike = hike else { return }
        guard let longitude = hike.longitude,
            let latitude = hike.latitude,
            let hikeRating = hike.hikeRating else { return }
        HikeController.sharedInstance.createHikeWith(longitude: longitude, latitude: latitude, hikeName: hike.hikeName, hikeRating: hikeRating, apiID: hike.apiID, hikeAscent: hike.ascent, hikeDifficulty: hike.difficulty, hikeDistance: hike.distance, hikeApiImage: hikeImage, user: user) { (hike) in
            if let hike = hike {
              //  user.savedHikes.append(hike)
                //UserController.sharedInstance.updateUserInfo(user: user)
                print ("Succesfully created hike")
            }
        }

        
//        HikeController.sharedInstance.checkHikeStatus(apiID: hike.apiID) { (success) in
//            if success {
//                UserController.sharedInstance.updateUserInfo(user: user)
//            } else {
//                guard let longitude = hike.longitude,
//                    let latitude = hike.latitude,
//                    let hikeRating = hike.hikeRating else { return }
//                HikeController.sharedInstance.createHikeWith(longitude: longitude, latitude: latitude, hikeName: hike.hikeName, hikeRating: hikeRating, apiID: hike.apiID, hikeAscent: hike.ascent, hikeDifficulty: hike.difficulty, hikeDistance: hike.distance, hikeApiImage: hikeImage, completion: { (hike) in
//                    if let hike = hike {
//                        user.savedHikes.append(hike)
//                        UserController.sharedInstance.updateUserInfo(user: user)
//                    }
//                })
//            }
//        }
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

