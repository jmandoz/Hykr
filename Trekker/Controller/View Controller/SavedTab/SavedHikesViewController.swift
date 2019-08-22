//
//  SavedHikesViewController.swift
//  Trekker
//
//  Created by Jason Mandozzi on 8/19/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class SavedHikesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //TODO: Remove this var after bot extension is moved over to HikeDetailVC
    var hike: HikeJSON?
    
    @IBOutlet weak var savedHikesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savedHikesTableView.dataSource = self
        savedHikesTableView.delegate = self
        guard let user = UserController.sharedInstance.currentUser else { return }
        let userPredicate = NSPredicate(format: "reference == %@", user.recordID)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [userPredicate])
        HikeController.sharedInstance.fetchHikes(predicate: compoundPredicate) { (hikes) in
            guard let userHikeArray = hikes else { return }
            UserController.sharedInstance.currentUser?.savedHikes = userHikeArray
        }
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let user = UserController.sharedInstance.currentUser else { return 1 }
        return user.savedHikes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedHikeCell", for: indexPath) as? SavedHikesTableViewCell
        
        let savedHike = UserController.sharedInstance.currentUser?.savedHikes[indexPath.row]
        
        cell?.hikeNameLabel.text = savedHike?.hikeName
        cell?.hikeImageView.image = savedHike?.hikeApiImage
        
        return cell ?? UITableViewCell()
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

// TODO: Move this code over to HikeDetailsViewController under saveButtonTapped func
extension SavedHikesViewController {
    
    
    func saveButtonTapped() {
        
        // Set image from fetch image func here
        guard let image: UIImage = UIImage(named: "pic1") else { return }
        guard let user = UserController.sharedInstance.currentUser,
        let hike = hike else { return }
        
        HikeController.sharedInstance.checkHikeStatus(apiID: hike.apiID) { (success) in
            if success {
                UserController.sharedInstance.updateUserInfo(user: user)
            } else {
                guard let longitude = hike.longitude,
                    let latitude = hike.latitude,
                let hikeRating = hike.hikeRating else { return }
                HikeController.sharedInstance.createHikeWith(longitude: longitude, latitude: latitude, hikeName: hike.hikeName, hikeRating: hikeRating, apiID: hike.apiID, hikeAscent: hike.ascent, hikeDifficulty: hike.difficulty, hikeDistance: hike.distance, hikeApiImage: image, completion: { (hike) in
                    if let hike = hike {
                        user.savedHikes.append(hike)
                        UserController.sharedInstance.updateUserInfo(user: user)
                    }
                })
            }
        }
    }
}
