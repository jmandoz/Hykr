//
//  PhotosTableViewController.swift
//  Trekker
//
//  Created by Jason Mandozzi on 8/20/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class PhotosTableViewController: UITableViewController {

    var picArray: [UIImage] = [#imageLiteral(resourceName: "pic2"), #imageLiteral(resourceName: "pic1"), #imageLiteral(resourceName: "pic3")]
    
    let user = UserController.sharedInstance.currentUser
    
    var hike: Hike?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func addImageButtonTapped(_ sender: Any) {
        presentImagePickerActionSheet()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return hike?.userPhotos.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as? PhotoTableViewCell else {return UITableViewCell()}
        let pic = hike?.userPhotos[indexPath.row]
        cell.photoImageView.contentMode = .scaleAspectFill
        cell.photoImageView.image = pic
        // Configure the cell...
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let hike = hike else { return }
            hike.userPhotos.remove(at: indexPath.row)
            HikeController.sharedInstance.update(hike: hike) { (success) in
                if success {
                    print("Image deleted successfully")
                } else {
                    print("Image was not deleted")
                }
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension PhotosTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentImagePickerActionSheet(){
        //creating an instance of UIImagePickerController initialized
        let imagePickerController = UIImagePickerController()
        //setting the ImagePickerController delegate
        imagePickerController.delegate = self
        //creating the action sheet that let's the user select either select a photo or use the camera
        let actionSheet = UIAlertController(title: "Select a photo for this hike to upload", message: nil, preferredStyle: .actionSheet)
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
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
           // proPicImageView.image = photo
            guard let hike = hike else { return }
            hike.userPhotos.append(photo)
            HikeController.sharedInstance.update(hike: hike) { (success) in
                if success {
                    print("Hike photo saved successfully")
                } else {
                    print("Hike photo failed to save")
                }
            }
        }
        tableView.reloadData()
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

