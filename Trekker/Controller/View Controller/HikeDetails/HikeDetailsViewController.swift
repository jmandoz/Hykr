//
//  HikeDetailsViewController.swift
//  Trekker
//
//  Created by Jason Mandozzi on 8/19/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class HikeDetailsViewController: UIViewController {
    

    
    //Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var directionsButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var hikeMapButton: UIButton!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var hikeNameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var currentWeatherLabel: UILabel!
    
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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

