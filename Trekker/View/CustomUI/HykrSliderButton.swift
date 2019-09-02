//
//  HykrButton.swift
//  Trekker
//
//  Created by Drew Seeholzer on 8/30/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class HykrSliderButton: UIButton {

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
        guard let size = self.titleLabel?.font.pointSize else { return }
        self.titleLabel?.font = UIFont(name: fontName, size: size)!
    }
    
    func setUpUI() {
        updateFont(to: FontNames.latoBold)
        self.backgroundColor = Colors.white.color()
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 3)
        self.setTitleColor(Colors.green.color(), for: .normal)
        self.setTitleColor(Colors.white.color(), for: .highlighted)
        self.addCornerRadius(self.frame.height / 2)
        self.addBorder()
    }
    
    func setUpUIDetailButton() {
        updateFont(to: FontNames.latoBold)
        self.backgroundColor = Colors.white.color()
        self.setTitleColor(Colors.green.color(), for: .normal)
        self.setTitleColor(Colors.white.color(), for: .highlighted)
        self.addCornerRadius(2)
        self.addBorder()
    }

}
