//
//  LandingViewController.swift
//  Trekker
//
//  Created by Jason Mandozzi on 8/19/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {
    
    //Button Outlet
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        UserController.sharedInstance.fetchUser { (success) in
            if success {
                DispatchQueue.main.async {
                    self.presentHomeView()
                }
            } else {
                DispatchQueue.main.async {
                    self.signUpButton.alpha = 1
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func presentHomeView() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "HomeVC")
        self.present(viewController, animated: true)
    }
}

extension LandingViewController {
    func setUpUI() {
        signUpButton.alpha = 0
    }
}
