//
//  HykrLabel.swift
//  Trekker
//
//  Created by Drew Seeholzer on 8/30/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class HykrLabel: UILabel {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func overrideFont(with fontName: String) {
        guard let size = self.font?.pointSize else { return }
        self.font = UIFont(name: fontName, size: size)!
    }
    
    func setUpUIHeader() {
        self.textColor = Colors.darkBrown.color()
        overrideFont(with: FontNames.arielBold)
    }
    
    func setUpUISubHeader() {
        self.textColor = Colors.darkBrown.color()
        overrideFont(with: FontNames.roboto)
    }
    
    func setUpUISubHeaderWhite() {
        self.textColor = Colors.white.color()
        overrideFont(with: FontNames.roboto)
    }
    
    func setUpUIBody() {
        self.textColor = Colors.darkBrown.color()
        overrideFont(with: FontNames.latoRegular)
    }

}
