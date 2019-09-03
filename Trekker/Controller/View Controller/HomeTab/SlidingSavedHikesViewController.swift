//
//  SlidingSavedHikesViewController.swift
//  Trekker
//
//  Created by Jason Mandozzi on 9/2/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class SlidingSavedHikesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var selectedSavedHike: Hike?
    
    @IBOutlet weak var slidingSavedHikesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slidingSavedHikesTableView.delegate = self
        slidingSavedHikesTableView.dataSource = self
        slidingSavedHikesTableView.reloadData()
        slidingSavedHikesTableView.backgroundColor = .clear
        self.view.backgroundColor = .clear
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        slidingSavedHikesTableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let user = UserController.sharedInstance.currentUser else {return 0}
        
        return user.savedHikes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "slideSavedHikesCell", for: indexPath) as? SlidingSavedHikesTableViewCell else {return UITableViewCell()}
        
        let savedHike = UserController.sharedInstance.currentUser?.savedHikes[indexPath.row]
        
        cell.hikeNameLabel.text = savedHike?.hikeName
        cell.hikeImageView.image = savedHike?.hikeApiImage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = Notification.Name(rawValue: notificationKey)
        
        let savedHike = UserController.sharedInstance.currentUser?.savedHikes[indexPath.row]
        
        NotificationCenter.default.post(name: name, object: savedHike?.apiID)
        
        
    }
}
