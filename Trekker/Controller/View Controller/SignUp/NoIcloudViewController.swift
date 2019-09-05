//
//  NoIcloudViewController.swift
//  Trekker
//
//  Created by Jason Mandozzi on 9/5/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit
import CloudKit

class NoIcloudViewController: UIViewController {

    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var noIcloudLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noIcloudLabel.alpha = 0
        // Do any additional setup after loading the view.
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        checkForiCloudUser()
    }
    
    
    func presentSignUpView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func animateNoIcloudLabel() {
        noIcloudLabel.alpha = 1
        UIView.animate(withDuration: 5) {
            self.noIcloudLabel.alpha = 0
        }
    }
    
    func checkForiCloudUser() {
        CKContainer.default().accountStatus { (status, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                switch status {
                case .available : self.presentSignUpView()
                case .restricted : print("restricted")
                case .noAccount :
                    DispatchQueue.main.async {
                        self.animateNoIcloudLabel()
                    }
                case .couldNotDetermine : print("Account could not be determined")
                @unknown default:
                    fatalError()
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
