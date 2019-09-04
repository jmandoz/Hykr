//
//  HikeLogViewController.swift
//  Trekker
//
//  Created by Jason Mandozzi on 8/19/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class HikeLogViewController: UIViewController {

    @IBOutlet weak var hikeLogTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hikeLogTableView.delegate = self
        self.hikeLogTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.hikeLogTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let user = UserController.sharedInstance.currentUser else {return}
        if segue.identifier == "toHikeDetailsVC" {
            guard let index = hikeLogTableView.indexPathForSelectedRow?.row else {return}
            let destinationVC = segue.destination as? HikeDetailsViewController
            let selectedHike = user.hikeLog[index]
            destinationVC?.hike = selectedHike
        }
    }
}

extension HikeLogViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let user = UserController.sharedInstance.currentUser else {return 0}
        return user.hikeLog.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "hikeLogCell", for: indexPath) as? HikeLogTableViewCell else {return UITableViewCell()}
        let hikeFromLog = UserController.sharedInstance.currentUser?.hikeLog[indexPath.row]
        cell.hikeNameLabel.text = hikeFromLog?.hikeName
        cell.hikeImageView.image = hikeFromLog?.hikeApiImage
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let loggedHike = UserController.sharedInstance.currentUser?.hikeLog[indexPath.row] else { return }
            HikeController.sharedInstance.deleteHikeLogHike(hike: loggedHike) { (success) in
                if success {
                    //UserController.sharedInstance.currentUser?.hikeLog.remove(at: indexPath.row)
                    print("Successfully deleted hike")
                } else {
                    print ("Failed to delete hike")
                }
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
