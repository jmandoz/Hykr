//
//  HykrDetailButtonView.swift
//  Trekker
//
//  Created by Drew Seeholzer on 9/2/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class HykrDetailButtonView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
    func setUpUI() {
        self.backgroundColor = Colors.white.color()
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 2)
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 0.1
        self.addCornerRadius(4)
        //self.addBorder()
    }

}
