//
//  AccountViewController.swift
//  Trekker
//
//  Created by Jason Mandozzi on 8/20/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit
import AVFoundation

class AccountViewController: UIViewController {
    
    
    @IBOutlet weak var proPicImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var changeUnitsButton: UIButton!
    @IBOutlet weak var milesButton: UIButton!
    @IBOutlet weak var kiloButton: UIButton!
    @IBOutlet weak var changeProfilePicButton: UIButton!
    @IBOutlet weak var ageLabel: HykrBodyLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = UserController.sharedInstance.currentUser else { return }
        proPicImageView.image = user.profileImage
        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func changeProfilePicButtonTapped(_ sender: Any) {
        presentImagePickerActionSheet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let user = UserController.sharedInstance.currentUser else { return }
        nameLabel.text = user.firstName + " " + user.lastName
        emailLabel.text = user.email
        ageLabel.text = "\(user.age)"
    }
    
    //Actions
    @IBAction func changeUnitsButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func milesButtonTapped(_ sender: Any) {
        guard let user = UserController.sharedInstance.currentUser else { return }
        if user.unitsInMiles != true {
            user.unitsInMiles = false
            UserController.sharedInstance.updateUserInfo(user: user) { (success) in
                if success {
                    print ("User units updated succesfully")
                } else {
                    print ("User units not updated for some reason")
                }
            }
        }
        
    }
    
    @IBAction func kiloButtonTapped(_ sender: Any) {
        guard let user = UserController.sharedInstance.currentUser else { return }
        if user.unitsInMiles == true {
            user.unitsInMiles = false
            UserController.sharedInstance.updateUserInfo(user: user) { (success) in
                if success {
                    print ("User units updated succesfully")
                } else {
                    print ("User units not updated for some reason")
                }
            }
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



extension AccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
            proPicImageView.image = photo
            guard let user = UserController.sharedInstance.currentUser else { return }
            user.profileImage = photo
            UserController.sharedInstance.updateUserInfo(user: user) { (success) in
                if success {
                    
                }
            }
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
