//
//  EditAccountViewController.swift
//  Trekker
//
//  Created by Jason Mandozzi on 8/20/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class EditAccountViewController: UIViewController {
    
    

    //Outlets
    @IBOutlet weak var changeEmailTextField: UITextField!
    @IBOutlet weak var editNameTextField: UITextField!
    @IBOutlet weak var editLastNameTextField: UITextField!
    @IBOutlet weak var editAgeTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var deleteAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
//        self.changeEmailTextField.delegate = self
//        self.editNameTextField.delegate = self
//        self.editLastNameTextField.delegate = self
//        self.editAgeTextField.delegate = self

        // Do any additional setup after loading the view.
    }
    
    //Actions
    @IBAction func submitButtonTapped(_ sender: Any) {
        
        guard let user = UserController.sharedInstance.currentUser else { return }
        
        if let email = changeEmailTextField.text, let firstName = editNameTextField.text, let lastName = editLastNameTextField.text, let age = editAgeTextField.text {
            if email.isEmpty && firstName.isEmpty && lastName.isEmpty && age.isEmpty == true {
                DispatchQueue.main.async {
                    
                    let alertController = UIAlertController(title: "All fields were empty", message: "Please edit a field to save changes.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default)
                    alertController.addAction(okAction)
                    
                    self.present(alertController, animated: true)
                }
                return
                
            }
            
            if email != "" {
                user.email = email
            }
            if firstName != "" {
                user.firstName = firstName
            }
            if lastName != "" {
                user.lastName = lastName
            }
            if age != "" {
                user.age = Int(age)!
            }
            UserController.sharedInstance.updateUserInfo(user: user) { (success) in
                if success {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Changes saved!", message: "", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok", style: .default)
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true)
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Error, changes failed to save", message: "", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok", style: .default)
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true)
                    }
                }
            }
        }
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        
        guard let user = UserController.sharedInstance.currentUser else { return }
        deleteUserAlert(user: user)
        
        
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomePageViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}

extension EditAccountViewController {
    func deleteUserAlert(user: User) {
        let alertController = UIAlertController(title: "Delete your account?", message: "This will delete all your saved hikes, hike log, and any pictures taken within the app. Are you sure you want to do this?", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Delete Account", style: .destructive) { (_) in
            UserController.sharedInstance.deleteUser(user: user, completion: { (success) in
                if success {
                    let alertAlertController = UIAlertController(title: "Account successfully deleted", message: "Please restart the app if you'd like to make a new account.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default)
                    alertAlertController.addAction(okAction)
                    
                    self.present(alertAlertController, animated: true)
                } else {
                    let alertAlertController = UIAlertController(title: "Error, account was not deleted", message: "", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default)
                    alertAlertController.addAction(okAction)
                    
                    self.present(alertAlertController, animated: true)
                }
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
}

//extension EditAccountViewController: UITextFieldDelegate {
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        resignFirstResponder()
//    }
//}
