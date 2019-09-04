//
//  SignUpInfoViewController.swift
//  Trekker
//
//  Created by Jason Mandozzi on 8/19/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit
import AVFoundation

class SignUpInfoViewController: UIViewController {
    
    //User Info Landing
    var emailLanding: String?
    var firstNameLanding: String?
    var lastNameLanding: String?
    var gender: String?
    var hikeDistance: Int?
    var profileImage: UIImage?
    
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
    
    // Image Button outlet
    @IBOutlet weak var profilePictureButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
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
    
    
    @IBAction func addProfilePicButtonTapped(_ sender: Any) {
        presentImagePickerActionSheet()
    }
    
    
    //Actions
    @IBAction func submitButtonTapped(_ sender: Any) {
        guard let email = emailLanding,
            let firstName = firstNameLanding,
            let lastName = lastNameLanding,
            let age = ageTextField.text, !age.isEmpty, let ageAsInt = Int(age),
            let genderValue = gender,
            let hikeDist = hikeDistance,
            let profileImage = profileImage ?? UIImage(named: "profile no pic")
            else {return}
        
        UserController.sharedInstance.createUserWith(email: email, firstName: firstName, lastName: lastName, gender: genderValue, age: ageAsInt, hikeDistance: hikeDist, profileImage: profileImage) { (user) in
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
            maleButton.setTitleColor(.white, for: .selected)
            gender = "Male"
            femaleButton.isSelected = false
            otherButton.isSelected = false
        //Female Button
        case 1:
            femaleButton.setTitleColor(.white, for: .selected)
            gender = "Female"
            maleButton.isSelected = false
            otherButton.isSelected = false
        //Other Button
        case 2:
            otherButton.setTitleColor(.white, for: .selected)
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
            oneMileButton.setTitleColor(.white, for: .selected)
            hikeDistance = 1
            twoMileButton.isSelected = false
            fiveMileButton.isSelected = false
            tenMileButton.isSelected = false
            fifteenMileButton.isSelected = false
            twentyPlusMileButton.isSelected = false
        case 1:
            twoMileButton.setTitleColor(.white, for: .selected)
            hikeDistance = 2
            oneMileButton.isSelected = false
            fiveMileButton.isSelected = false
            tenMileButton.isSelected = false
            fifteenMileButton.isSelected = false
            twentyPlusMileButton.isSelected = false
        case 2:
            fiveMileButton.setTitleColor(.white, for: .selected)
            hikeDistance = 5
            oneMileButton.isSelected = false
            twoMileButton.isSelected = false
            tenMileButton.isSelected = false
            fifteenMileButton.isSelected = false
            twentyPlusMileButton.isSelected = false
        case 3:
            tenMileButton.setTitleColor(.white, for: .selected)
            hikeDistance = 10
            oneMileButton.isSelected = false
            twoMileButton.isSelected = false
            fiveMileButton.isSelected = false
            fifteenMileButton.isSelected = false
            twentyPlusMileButton.isSelected = false
        case 4:
            fifteenMileButton.setTitleColor(.white, for: .selected)
            hikeDistance = 15
            oneMileButton.isSelected = false
            twoMileButton.isSelected = false
            fiveMileButton.isSelected = false
            tenMileButton.isSelected = false
            twentyPlusMileButton.isSelected = false
        case 5:
            twentyPlusMileButton.setTitleColor(.white, for: .selected)
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

extension SignUpInfoViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomePageViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

// MARK: Image picker extension

extension SignUpInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentImagePickerActionSheet(){
        //creating an instance of UIImagePickerController initialized
        let imagePickerController = UIImagePickerController()
        //setting the ImagePickerController delegate
        imagePickerController.delegate = self
        //creating the action sheet that let's the user select either select a photo or use the camera
        let actionSheet = UIAlertController(title: "Select a photo or take a picture", message: nil, preferredStyle: .actionSheet)
        //MARK: - Select a photo from the Library
        //Here we check if the photoLibrary is available as a source type
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            //if it is available, we add an action to the action sheet titled "Photo" and if it is selected, than the code below will run
            actionSheet.addAction(UIAlertAction(title: "Photo", style: .default, handler: { (_) in
                //we set our instance of imagePickerController and set it equal the source type we want: in this case photoLibrary
                imagePickerController.sourceType = .photoLibrary
                //we present imagePicker Controller
                self.present(imagePickerController, animated: true, completion:  nil)
            }))
        }
        //MARK: - Select your camera
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
            self.requestCameraPermission()
            //Here we check if the camera source type is available
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "Camera access not allowed", message: "To use your camera in this app, please go to your phone's settings and allow us camera access.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default)
                alertController.addAction(okAction)
                self.present(alertController, animated: true)
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.profileImage = photo
            self.profilePictureButton.setImage(photo, for: .normal)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { accessGranted in
            guard accessGranted == true else { return }
        })
    }
}
