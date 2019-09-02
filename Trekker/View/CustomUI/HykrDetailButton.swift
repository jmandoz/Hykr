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
        guard let size = self.titleLabel?.font.pointSize else { return }
        self.titleLabel?.font = UIFont(name: fontName, size: size)!
    }
    
    func setUpUI() {
        updateFont(to: FontNames.latoBold)
        self.backgroundColor = Colors.white.color()
        self.setTitleColor(Colors.green.color(), for: .normal)
        self.setTitleColor(Colors.white.color(), for: .highlighted)
        self.addCornerRadius(2)
        self.addBorder()
    }
}
