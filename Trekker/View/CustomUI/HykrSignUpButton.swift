//
//  HykrSignUpButton.swift
//  Trekker
//
//  Created by Drew Seeholzer on 9/3/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class HykrSignUpButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
//    override open var isHighlighted: Bool {
//        didSet {
//            backgroundColor = isHighlighted ? Colors.green.color() : Colors.white.color()
//        }
//    }
    
    override open var isEnabled: Bool {
        didSet {
            backgroundColor = isHighlighted ? Colors.green.color() : Colors.white.color()
        }
    }
    
    
    func updateFont(to fontName: String) {
        guard let size = self.titleLabel?.font.pointSize,
            let font = UIFont(name: fontName, size: size)
            else { return }
        
        self.titleLabel?.font = font
    }
    
    func setUpUI() {
        updateFont(to: FontNames.roboto)
        self.backgroundColor = Colors.white.color()
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.5, height: 1.5)
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 0.3
        self.setTitleColor(Colors.darkBrown.color(), for: .normal)
        self.setTitleColor(Colors.white.color(), for: .highlighted)
        self.setTitleColor(Colors.white.color(), for: .selected)
        self.tintColor = Colors.green.color()
       // self.setBackgroundImage(UIImage(named: "greensquare"), for: .selected)
        self.addCornerRadius(4)
        self.addBorder()
    }

}


