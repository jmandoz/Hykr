//
//  SlidingDetailsViewController.swift
//  Trekker
//
//  Created by Jason Mandozzi on 8/22/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class SlidingDetailsViewController: UIViewController {
    
    var selectedHikeLanding: HikeJSON? {
        didSet {
            guard let hike = selectedHikeLanding else {return}
            hikeNameLabel.text = hike.hikeName
            hikeRatingLabel.text = "\(String(describing: hike.hikeRating))"
            hikeDistanceLabel.text = "Need to get distance"
        }
    }
    
    weak var delegate: HikeDetailsViewControllerDelegate?
    
    @IBOutlet weak var hikeNameLabel: UILabel!
    @IBOutlet weak var hikeRatingLabel: UILabel!
    @IBOutlet weak var hikeDistanceLabel: UILabel!
    @IBOutlet weak var directionsButton: UIButton!
    @IBOutlet weak var hikeDetailsButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func directionsButtonTapped(_ sender: Any) {
       
    }
    
    @IBAction func hikeDetailsButtonTapped(_ sender: Any) {

    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
    }
    
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHikeDetailsVC" {
            let destinationsVC = segue.destination as? HikeDetailsViewController
            destinationsVC?.hike = selectedHikeLanding
        }
    }

}

protocol HikeDetailsViewControllerDelegate: class {
}
