//
//  SignUpInfoViewController.swift
//  Trekker
//
//  Created by Jason Mandozzi on 8/19/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class SignUpInfoViewController: UIViewController {
    
    //User Info Landing
    var emailLanding: String?
    var firstNameLanding: String?
    var lastNameLanding: String?
    
    //TextField Outlet
    @IBOutlet weak var ageTextField: UITextField!
    
    //Button Outlets
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    @IBOutlet weak var oneMileButton: UIButton!
    @IBOutlet weak var twoMileButton: UIButton!
    @IBOutlet weak var fiveMileButton: UIButton!
    @IBOutlet weak var tenMileButton: UIButton!
    @IBOutlet weak var fifteenMileButton: UIButton!
    @IBOutlet weak var twentyPlusMileButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //Actions
    @IBAction func submitButtonTapped(_ sender: Any) {
        presentHomePageView()
    }
    
    
    func presentHomePageView() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "HomeVC")
            self.present(viewController, animated: true)
        }
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
