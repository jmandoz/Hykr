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
        // Do any additional setup after loading the view.
        // Post notification that will pass hike apiID back to the map view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.savedHikesTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let savedHike = UserController.sharedInstance.currentUser?.savedHikes[indexPath.row] else { return }
            UserController.sharedInstance.currentUser?.savedHikes.remove(at: indexPath.row)
            HikeController.sharedInstance.deleteSavedHike(hike: savedHike) { (success) in
                if success {
                    print ("Succesfully deleted hike")
                } else {
                    print ("Failed to delete hike")
                }
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let user = UserController.sharedInstance.currentUser else {return}
        if segue.identifier == "toHikeDetailsVC" {
            guard let index = savedHikesTableView.indexPathForSelectedRow?.row else {return}
            let destinationVC = segue.destination as? HikeDetailsViewController
            let selectedHike = user.savedHikes[index]
            destinationVC?.hike = selectedHike
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}

