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

        // Do any additional setup after loading the view.
    }
    
    //Actions
    @IBAction func submitButtonTapped(_ sender: Any) {
        
        guard let user = UserController.sharedInstance.currentUser else { return }
        
        if let email = changeEmailTextField.text, let firstName = editNameTextField.text, let lastName = editLastNameTextField.text, let age = editAgeTextField.text {
            if email.isEmpty && firstName.isEmpty && lastName.isEmpty && age.isEmpty == true {
                let alertController = UIAlertController(title: "All fields were empty", message: "Please edit a field to save changes.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default)
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true)
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
        }
//        if changeEmailTextField.text != "" {
//            user.email = changeEmailTextField.text!
//        }
//        if editNameTextField.text != "" {
//            user.firstName = editNameTextField.text!
//        }
//        if editLastNameTextField.text != "" {
//            user.lastName = editLastNameTextField.text!
//        }
//        if editAgeTextField.text != "" {
//            user.age = Int(editAgeTextField.text!)!
//        }
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
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        
        guard let user = UserController.sharedInstance.currentUser else { return }
        deleteUserAlert(user: user)
        
        
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
