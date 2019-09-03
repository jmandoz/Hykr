//
//  HikeDetailsViewController.swift
//  Trekker
//
//  Created by Jason Mandozzi on 8/19/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class HikeDetailsViewController: UIViewController {
    
    var hike: Hike?
    var savedHikesTempArray: [Hike]?
    var hikeImage: UIImage?
    
    //Non Data Label Outlets
    
    @IBOutlet weak var difficultyTitleLabel: HykrSubHeaderBoldLabel!
    @IBOutlet weak var ascentTitleLabel: HykrSubHeaderBoldLabel!
    @IBOutlet weak var distanceTitleLabel: HykrSubHeaderBoldLabel!
    @IBOutlet weak var currentWeatherTitleLabel: HykrSubHeaderBoldLabel!
    @IBOutlet weak var photosButtonLabel: HykrSubHeaderLabel!
    @IBOutlet weak var completeButtonLabel: HykrSubHeaderLabel!
    
    // Button Views and images
    @IBOutlet weak var photosButtonView: HykrDetailButtonView!
    @IBOutlet weak var completeButtonView: HykrDetailButtonView!
    @IBOutlet weak var completeButtonImageView: UIImageView!
    
    //Data Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var hikeNameLabel: HykrSubHeaderLabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var ascentLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var currentWeatherLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: HykrSubHeaderBoldLabel!
    
    // Star Rating Outlet
    @IBOutlet weak var ratingImageView: UIImageView!
    
    // Button Outlets
    
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var photosButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayHikeInfo()
        fetchWeatherInfo()
        guard let user = UserController.sharedInstance.currentUser else {return}
        checkSavedHikes(Hikes: user.savedHikes)
        checkHikeLog(Hikes: user.hikeLog)
    }
    
    func fetchWeatherInfo() {
        guard let hike = hike else { return }
        let queryItems = [WeatherAPIStrings.latitudeQuery : "\(hike.latitude)", WeatherAPIStrings.longitudeQuery : "\(hike.longitude)", WeatherAPIStrings.unitsQuery : WeatherAPIStrings.unitsQueryValue, WeatherAPIStrings.apiKey : WeatherAPIStrings.apiKeyValue]
        guard let url = NetworkController.sharedInstance.buildURL(baseURL: WeatherAPIStrings.baseURL, components: [WeatherAPIStrings.components], queryItems: queryItems) else { return }
        print (url)
        NetworkController.sharedInstance.getDataFromURL(url: url) { (data) in
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let topLevelJSON = try decoder.decode(Weather.self, from: data)
                let weatherConditions = topLevelJSON.conditions
                let temp = topLevelJSON.temperature.temp.rounded()
    
                DispatchQueue.main.async {
                    self.currentWeatherLabel.text = "\(temp) F"
                    self.weatherDescriptionLabel.text = weatherConditions[0].conditionsDescription
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
        hikeNameLabel.text = hike.hikeName
        ratingLabel.text = "\(hike.hikeRating)"
        difficultyLabel.text = hike.hikeDifficulty
        distanceLabel.text = "\(hike.hikeDistance)"
        ascentLabel.text = "\(hike.hikeAscent)"
        imageView.image = hike.hikeApiImage

        DispatchQueue.main.async {
            self.convertRatingNumberToStars(rating: hike.hikeRating)
        }
    }
    
    func checkSavedHikes(Hikes: [Hike]) {
        guard let hike = self.hike else {return}
        for savedHike in Hikes {
            if savedHike.wackyUUID == hike.wackyUUID {
                DispatchQueue.main.async {
                    self.heartButton.setImage(UIImage(named: "saved hike icon"), for: .normal)
                   // self.heartButton.alpha = 0
                }
            }
        }
    }
    
    func checkHikeLog(Hikes: [Hike]) {
        guard let hike = self.hike else {return}
        for loggedHikes in Hikes {
            if loggedHikes.wackyUUID == hike.wackyUUID {
                hike.isCompleted = true
                DispatchQueue.main.async {
                    self.completeButtonLabel.text = "Completed"
                   // self.completeButton.setTitle("Completed", for: .normal)
//                    self.completeButton.setImage(UIImage(named: "completed hike button"), for: .normal)
//                    self.completeButton.imageView?.sizeToFit()
//                    self.completeButton.backgroundColor = Colors.green.color()
                    self.completeButtonImageView.image = UIImage(named: "checkmark")?.resizeImage(targetSize: CGSize(width: self.completeButtonView.frame.width / 4, height: self.completeButtonView.frame.width / 4))
                    self.heartButton.alpha = 0
                }
            }
        }
    }
    
    //Actions
    @IBAction func directionsButtonTapped(_ sender: Any) {
        let name = Notification.Name(rawValue: notificationKey)
        NotificationCenter.default.post(name: name, object: hike?.apiID)
        presentMapView()
    }
    
    @IBAction func hikeMapButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func completeButtonTapped(_ sender: Any) {
        guard let hike = hike else { return }
        if hike.isCompleted == false {
            checkUserHikes()
            //presentMapView()
        } else {
            print ("It worked")
        }
    }
    
    func presentMapView() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "HomeVC")
        self.present(viewController, animated: true)
    }
    
    func checkUserHikes() {
        guard let user = UserController.sharedInstance.currentUser,
            let hike = hike
            else { return }
        let uuids = user.savedHikes.map({ $0.wackyUUID })
        if uuids.contains(hike.wackyUUID) {
            moveSavedHike(user: user, hikeJSON: hike)
        } else {
            createAndSaveCompletedHike(user: user, hike: hike)
        }
    }
    
    func moveSavedHike(user: User, hikeJSON: Hike) {
        for hike in user.savedHikes {
            if hike.wackyUUID == hikeJSON.wackyUUID {
                if let index = user.savedHikes.firstIndex(of: hike) {
                    user.savedHikes.remove(at: index)
                }
                hike.isCompleted = true
                user.hikeLog.append(hike)
                HikeController.sharedInstance.update(hike: hike) { (success) in
                    if success {
                        DispatchQueue.main.async {
                            self.completeButtonLabel.text = "Completed"
                         //   self.completeButton.setTitle("Completed", for: .normal)
//                            self.completeButton.setBackgroundImage(UIImage(named: "completed hike button")?.resizeImage(targetSize: self.completeButton.frame.size), for: .normal)
//                            self.completeButton.backgroundColor = Colors.green.color()
                            self.completeButtonImageView.image = UIImage(named: "checkmark")?.resizeImage(targetSize: CGSize(width: self.completeButtonView.frame.width / 4, height: self.completeButtonView.frame.width / 4))
                        }
                    }
                }
            }
        }
    }
    
    func createAndSaveCompletedHike(user: User, hike: Hike) {
        guard let hikeImage = hike.hikeApiImage else {return}
        HikeController.sharedInstance.createHikeWith(longitude: hike.longitude, latitude: hike.latitude, hikeName: hike.hikeName, hikeRating: hike.hikeRating, apiID: hike.apiID, hikeAscent: hike.hikeAscent, hikeDifficulty: hike.hikeDifficulty, hikeDistance: hike.hikeDistance, isCompleted: true, hikeApiImage: hikeImage, user: user) { (hike) in
            if let hike = hike {
                self.hike?.isCompleted = true
                user.hikeLog.append(hike)
                DispatchQueue.main.async {
                    self.completeButtonLabel.text = "Completed"
                   // self.completeButton.setTitle("Completed", for: .normal)
//                    self.completeButton.setImage(UIImage(named: "completed hike button"), for: .normal)
//                    self.completeButton.backgroundColor = Colors.green.color()
                    self.completeButtonImageView.image = UIImage(named: "checkmark")?.resizeImage(targetSize: CGSize(width: self.completeButtonView.frame.width / 4, height: self.completeButtonView.frame.width / 4))
                }
            }
        }
    }
    
    @IBAction func heartButtonTapped(_ sender: Any) {
        guard let hike = hike,
            let user = UserController.sharedInstance.currentUser, let hikeImage = hike.hikeApiImage else {return}
        HikeController.sharedInstance.createHikeWith(longitude: hike.longitude, latitude: hike.latitude, hikeName: hike.hikeName, hikeRating: hike.hikeRating, apiID: hike.apiID, hikeAscent: hike.hikeAscent, hikeDifficulty: hike.hikeDifficulty, hikeDistance: hike.hikeDistance, isCompleted: false, hikeApiImage: hikeImage, user: user) { (hike) in
            if let hike = hike {
                user.savedHikes.append(hike)
                DispatchQueue.main.async {
                    self.heartButton.setImage(UIImage(named: "saved hike icon"), for: .normal)
                    self.heartButton.setTitle("Saved", for: .normal)
                    self.heartButton.isEnabled = false
                }
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotosVC" {
            let destinationVC = segue.destination as? PhotosTableViewController
            destinationVC?.hike = hike
        }
    }
}

// MARK: - Star ratings

extension HikeDetailsViewController {
    
    // TODO: Update func with correct images
    func convertRatingNumberToStars(rating: Double) {
        switch rating {
        case _ where rating <= 0.24:
            self.ratingImageView.image = UIImage(named: "stars0")
            
        case _ where rating >= 0.25 && rating < 1:
            self.ratingImageView.image = UIImage(named: "starshalf")
            
        case _ where rating <= 1.24:
            self.ratingImageView.image = UIImage(named: "stars1")
            
        case _ where rating >= 1.25 && rating < 1.75:
            self.ratingImageView.image = UIImage(named: "stars1half")
            
        case _ where rating <= 2.24:
            self.ratingImageView.image = UIImage(named: "stars2")
            
        case _ where rating >= 2.25 && rating < 2.75:
            self.ratingImageView.image = UIImage(named: "stars2half")
            
        case _ where rating <= 3.24:
            self.ratingImageView.image = UIImage(named: "stars3")
            
        case _ where rating >= 3.25 && rating < 3.75:
            self.ratingImageView.image = UIImage(named: "stars3half")
            
        case _ where rating <= 4.24:
            self.ratingImageView.image = UIImage(named: "stars4")
            
        case _ where rating >= 4.25 && rating < 4.75:
               self.ratingImageView.image = UIImage(named: "stars4half")
            
        default:
            self.ratingImageView.image = UIImage(named: "stars5")
        }
    }
    //    func convertRatingNumberToStars(rating: Double) {
    //        switch rating {
    //        case _ where rating == 0:
    //            self.ratingImageView.image = UIImage(named: "stars0")
    //        case _ where rating < 1:
    //            self.ratingImageView.image = UIImage(named: "stars0.5")
    //        case _ where rating < 1.5:
    //            self.ratingImageView.image = UIImage(named: "stars1")
    //        case _ where rating < 2:
    //            self.ratingImageView.image = UIImage(named: "stars1.5")
    //
    //        case _ where rating < 2.5:
    //            self.ratingImageView.image = UIImage(named: "stars2")
    //
    //        case _ where rating < 3:
    //            self.ratingImageView.image = UIImage(named: "stars2.5")
    //
    //        case _ where rating < 3.5:
    //            self.ratingImageView.image = UIImage(named: "stars3")
    //
    //        case _ where rating < 4:
    //            self.ratingImageView.image = UIImage(named: "stars3.5")
    //
    //        case _ where rating < 4.5:
    //            self.ratingImageView.image = UIImage(named: "stars4")
    //
    //        case _ where rating < 5:
    //            self.ratingImageView.image = UIImage(named: "stars4.5")
    //
    //        default:
    //            self.ratingImageView.image = UIImage(named: "full star icon")
    //        }
    //    }
}
