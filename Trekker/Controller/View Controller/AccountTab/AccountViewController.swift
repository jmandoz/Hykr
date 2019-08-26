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
    @IBOutlet weak var changeProfilePicButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func changeProfilePicButtonTapped(_ sender: Any) {
        presentImagePickerActionSheet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let user = UserController.sharedInstance.currentUser else { return }
        nameLabel.text = user.firstName + " " + user.lastName
        emailLabel.text = user.email
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
        //Here we check if the camera source type is available
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            //same as above, we are adding an action called "Camera"
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            proPicImageView.image = photo
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
