//
//  CustomTabBarController.swift
//  Trekker
//
//  Created by Jason Mandozzi on 8/29/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.shadowImage = UIImage()
        self.tabBar.backgroundImage = UIImage()
        // Do any additional setup after loading the view.
    }
}
