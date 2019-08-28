//
//  SlidingDetailsViewController.swift
//  Trekker
//
//  Created by Jason Mandozzi on 8/22/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit
import CoreLocation

class SlidingDetailsViewController: UIViewController {
    
    var selectedHikeLanding: HikeJSON? {
        didSet {
            guard let hike = selectedHikeLanding, let user = UserController.sharedInstance.currentUser else {return}
            hikeNameLabel.text = hike.hikeName
            hikeRatingLabel.text = "\(String(describing: hike.hikeRating))"
            hikeDistanceLabel.alpha = 0
            checkHikeArrays(savedArray: user.savedHikes, hikeLogArray: user.hikeLog, hike: hike)
            fetchHikeImage(hike: hike) { (image) in
                if let image = image {
                    self.hikeImage = image
                }
            }
        }
    }
    
    var hikeImage: UIImage?
    
    weak var delegate: HikeDetailsViewControllerDelegate?
    
    @IBOutlet weak var hikeNameLabel: UILabel!
    @IBOutlet weak var hikeRatingLabel: UILabel!
    @IBOutlet weak var hikeDistanceLabel: UILabel!
    @IBOutlet weak var directionsButton: UIButton!
    @IBOutlet weak var hikeDetailsButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func directionsButtonTapped(_ sender: Any) {
        delegate?.directionsButtonTapped(view: self)
    }
    
    @IBAction func hikeDetailsButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let user = UserController.sharedInstance.currentUser, let selectedHike = selectedHikeLanding, let hikeLong = selectedHikeLanding?.longitude, let hikeLat = selectedHikeLanding?.latitude, let rating = selectedHikeLanding?.hikeRating else {return}
        fetchHikeImage(hike: selectedHike) { (image) in
            if let image = image {
                HikeController.sharedInstance.createHikeWith(longitude: hikeLong, latitude: hikeLat, hikeName: selectedHike.hikeName, hikeRating: rating, apiID: selectedHike.apiID, hikeAscent: selectedHike.ascent, hikeDifficulty: selectedHike.difficulty, hikeDistance: selectedHike.distance, hikeApiImage: image, user: user, completion: { (hike) in
                    if let hike = hike {
                        user.savedHikes.append(hike)
                        DispatchQueue.main.async {
                            self.saveButton.setTitle("Saved", for: .normal)
                            self.saveButton.backgroundColor = .green
                            self.saveButton.isEnabled = false
                        }
                        print("succesfully create hike")
                    }
                })
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
    
    func checkHikeArrays(savedArray: [Hike], hikeLogArray: [Hike], hike: HikeJSON) {
        let savedUuids = savedArray.map({ $0.wackyUUID })
        let logsUuids = hikeLogArray.map({ $0.wackyUUID })
        if logsUuids.contains(hike.wackyUUID) {
            DispatchQueue.main.async {
                self.saveButton.setTitle("Completed", for: .normal)
                self.saveButton.backgroundColor = .red
                self.saveButton.isEnabled = false
            }
        } else if savedUuids.contains(hike.wackyUUID) {
            DispatchQueue.main.async {
                self.saveButton.setTitle("Saved", for: .normal)
                self.saveButton.backgroundColor = .green
                self.saveButton.isEnabled = false
            }
        } else {
            DispatchQueue.main.async {
                self.saveButton.setTitle("Save", for: .normal)
                self.saveButton.backgroundColor = .white
                self.saveButton.isEnabled = true
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHikeDetailsVC" {
            guard let hikelat = selectedHikeLanding?.latitude, let hikeLong = selectedHikeLanding?.longitude, let user = UserController.sharedInstance.currentUser, let hikeName = selectedHikeLanding?.hikeName, let hikeRating = selectedHikeLanding?.hikeRating, let apiID = selectedHikeLanding?.apiID, let ascent = selectedHikeLanding?.ascent, let diff = selectedHikeLanding?.difficulty, let dist = selectedHikeLanding?.distance, let image = hikeImage else {return}
            let destinationsVC = segue.destination as? HikeDetailsViewController
            destinationsVC?.hike = Hike(longitude: hikeLong, latitude: hikelat, hikeName: hikeName, hikeRating: hikeRating, apiID: apiID, hikeAscent: ascent, hikeDifficulty: diff, hikeDistance: dist, hikeApiImage: image, user: user)
        }
    }
}

protocol HikeDetailsViewControllerDelegate: class {
    func directionsButtonTapped(view: SlidingDetailsViewController)
}
