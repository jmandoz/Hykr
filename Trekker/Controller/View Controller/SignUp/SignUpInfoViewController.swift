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
    var gender: String?
    var hikeDistance: Int?
    
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
    
    //Button Action
    @IBAction func genderButtonTapped(sender: UIButton) {
        sender.isSelected = true
        setGenderValue(buttonTag: sender.tag)
    }
    
    @IBAction func hikeDistanceButtonTaooed(sender: UIButton) {
        sender.isSelected = true
        setHikeDistanceValue(buttonTag: sender.tag)
    }
    
    
    //Actions
    @IBAction func submitButtonTapped(_ sender: Any) {
        guard let email = emailLanding,
            let firstName = firstNameLanding,
            let lastName = lastNameLanding,
            let age = ageTextField.text, !age.isEmpty, let ageAsInt = Int(age),
            let genderValue = gender,
            let hikeDist = hikeDistance
            else {return}
        
        UserController.sharedInstance.createUserWith(email: email, firstName: firstName, lastName: lastName, gender: genderValue, age: ageAsInt, hikeDistance: hikeDist) { (user) in
            if user != nil {
                self.presentHomePageView()
            }
        }
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

extension SignUpInfoViewController {
    func setGenderValue(buttonTag: Int) {
        switch buttonTag {
        //Male Button
        case 0:
            maleButton.setTitleColor(.green, for: .selected)
            gender = "Male"
            femaleButton.isSelected = false
            otherButton.isSelected = false
        //Female Button
        case 1:
            femaleButton.setTitleColor(.green, for: .selected)
            gender = "Female"
            maleButton.isSelected = false
            otherButton.isSelected = false
        //Other Button
        case 2:
            otherButton.setTitleColor(.green, for: .selected)
            gender = "other"
            maleButton.isSelected = false
            femaleButton.isSelected = false
        default:
            print("Error with buttons")
            
        }
    }
    
    func setHikeDistanceValue(buttonTag: Int) {
        switch buttonTag {
        case 0:
            oneMileButton.setTitleColor(.green, for: .selected)
            hikeDistance = 1
            twoMileButton.isSelected = false
            fiveMileButton.isSelected = false
            tenMileButton.isSelected = false
            fifteenMileButton.isSelected = false
            twentyPlusMileButton.isSelected = false
        case 1:
            twoMileButton.setTitleColor(.green, for: .selected)
            hikeDistance = 2
            oneMileButton.isSelected = false
            fiveMileButton.isSelected = false
            tenMileButton.isSelected = false
            fifteenMileButton.isSelected = false
            twentyPlusMileButton.isSelected = false
        case 2:
            fiveMileButton.setTitleColor(.green, for: .selected)
            hikeDistance = 5
            oneMileButton.isSelected = false
            twoMileButton.isSelected = false
            tenMileButton.isSelected = false
            fifteenMileButton.isSelected = false
            twentyPlusMileButton.isSelected = false
        case 3:
            tenMileButton.setTitleColor(.green, for: .selected)
            hikeDistance = 10
            oneMileButton.isSelected = false
            twoMileButton.isSelected = false
            fiveMileButton.isSelected = false
            fifteenMileButton.isSelected = false
            twentyPlusMileButton.isSelected = false
        case 4:
            fifteenMileButton.setTitleColor(.green, for: .selected)
            hikeDistance = 15
            oneMileButton.isSelected = false
            twoMileButton.isSelected = false
            fiveMileButton.isSelected = false
            tenMileButton.isSelected = false
            twentyPlusMileButton.isSelected = false
        case 5:
            twentyPlusMileButton.setTitleColor(.green, for: .selected)
            hikeDistance = 25
            oneMileButton.isSelected = false
            twoMileButton.isSelected = false
            fiveMileButton.isSelected = false
            tenMileButton.isSelected = false
            fifteenMileButton.isSelected = false
        default:
            print("Error with Distance buttons")
        }
    }
}
