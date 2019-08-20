//
//  AccountViewController.swift
//  Trekker
//
//  Created by Jason Mandozzi on 8/20/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var proPicImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var changeUnitsButton: UIButton!
    @IBOutlet weak var milesButton: UIButton!
    @IBOutlet weak var kiloButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //Actions
    @IBAction func changeUnitsButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func milesButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func kiloButtonTapped(_ sender: Any) {
        
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
