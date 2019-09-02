//
//  HykrSubHeaderBoldLabel.swift
//  Trekker
//
//  Created by Drew Seeholzer on 9/2/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class HykrSubHeaderBoldLabel: UILabel {

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
    func overrideFont(with fontName: String, size: CGFloat) {
        //guard let size = self.font?.pointSize else { return }
        self.font = UIFont(name: fontName, size: size)!
    }
    
    func setUpUI() {
        self.textColor = Colors.darkBrown.color()
        overrideFont(with: FontNames.robotoBold, size: 16)
    }

}
