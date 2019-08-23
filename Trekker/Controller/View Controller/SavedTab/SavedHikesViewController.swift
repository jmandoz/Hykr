//
//  SavedHikesViewController.swift
//  Trekker
//
//  Created by Jason Mandozzi on 8/19/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class SavedHikesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var savedHikesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savedHikesTableView.dataSource = self
        savedHikesTableView.delegate = self
        guard let user = UserController.sharedInstance.currentUser else { return }
        let userPredicate = NSPredicate(format: "userReference == %@", user.recordID)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [userPredicate])
        HikeController.sharedInstance.fetchHikes(user: user, predicate: compoundPredicate) { (hikes) in
            guard let userHikeArray = hikes else { return }
            UserController.sharedInstance.currentUser?.savedHikes = userHikeArray
            DispatchQueue.main.async {
                self.savedHikesTableView.reloadData()
            }
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

