//
//  HykrOtherButton.swift
//  Trekker
//
//  Created by Drew Seeholzer on 9/3/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class HykrOtherButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
//    override open var isHighlighted: Bool {
//        didSet {
//            backgroundColor = isHighlighted ? Colors.green.color() : Colors.white.color()
//        }
//    }
    
    func updateFont(to fontName: String) {
        guard let size = self.titleLabel?.font.pointSize,
            let font = UIFont(name: fontName, size: size)
            else { return }
        
        self.titleLabel?.font = font
    }
    
    func setUpUI() {
        updateFont(to: FontNames.roboto)
        self.setTitleColor(Colors.darkBrown.color(), for: .normal)
        //self.setTitleColor(Colors.white.color(), for: .highlighted)
    }

}
