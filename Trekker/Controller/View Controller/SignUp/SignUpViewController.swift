//
//  SignUpViewController.swift
//  Trekker
//
//  Created by Jason Mandozzi on 8/19/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit
import CloudKit

class SignUpViewController: UIViewController {
    
    //TextField Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    //Button Outlets
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkForiCloudUser()
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }

    @IBAction func submitButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty, let firstName = firstNameTextField.text, !firstName.isEmpty, let lastName = lastNameTextField.text, !lastName.isEmpty else { return }
        DispatchQueue.main.async {
            self.presentSignUpDetailsVC(email: email, firstName: firstName, lastName: lastName)
        }
        
    }
    
    func checkForiCloudUser() {
        CKContainer.default().accountStatus { (status, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                switch status {
                case .available : print("available")
                case .restricted : print("restricted")
                case .noAccount : self.presentNoIcloudView()
                case .couldNotDetermine : print("Account could not be determined")
                @unknown default:
                    fatalError()
                }
            }
        }
    }
    func presentNoIcloudView() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
            guard let viewController = storyboard.instantiateViewController(withIdentifier: "noIcloudVC") as? NoIcloudViewController else { return }
            self.present(viewController, animated: true)
        }
    }
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
