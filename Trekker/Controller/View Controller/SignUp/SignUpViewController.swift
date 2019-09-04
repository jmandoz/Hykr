//
//  SignUpViewController.swift
//  Trekker
//
//  Created by Jason Mandozzi on 8/19/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    //TextField Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    //Button Outlets
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }

    @IBAction func submitButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty, let firstName = firstNameTextField.text, !firstName.isEmpty, let lastName = lastNameTextField.text, !lastName.isEmpty else { return }
        DispatchQueue.main.async {
            self.presentSignUpDetailsVC(email: email, firstName: firstName, lastName: lastName)
        }
        
    }
    
    // MARK: - Navigation
    
    

    }

extension SignUpViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomePageViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func presentSignUpDetailsVC(email: String, firstName: String, lastName: String) {
        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "signUpDetailVC") as? SignUpInfoViewController else { return }
        viewController.emailLanding = email
        viewController.firstNameLanding = firstName
        viewController.lastNameLanding = lastName
        self.present(viewController, animated: true)
    }
    
}
