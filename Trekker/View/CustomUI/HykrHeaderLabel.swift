//
//  HykrLabel.swift
//  Trekker
//
//  Created by Drew Seeholzer on 8/30/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class HykrHeaderLabel: UILabel {

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
    func overrideFont(with fontName: String) {
        guard let size = self.font?.pointSize else { return }
        self.font = UIFont(name: fontName, size: size)!
    }
    
    func setUpUI() {
        self.textColor = Colors.darkBrown.color()
        overrideFont(with: FontNames.arielBold)
    }
}
