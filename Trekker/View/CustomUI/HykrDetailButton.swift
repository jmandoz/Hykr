//
//  HykrDetailButton.swift
//  Trekker
//
//  Created by Drew Seeholzer on 9/2/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class HykrDetailButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
    override open var isHighlighted: Bool {
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
        self.layer.shadowOffset = CGSize(width: 1, height: 2)
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 0.1
        self.setTitleColor(Colors.darkBrown.color(), for: .normal)
        self.setTitleColor(Colors.white.color(), for: .highlighted)
        self.addCornerRadius(4)
        //self.addBorder()
    }
}
