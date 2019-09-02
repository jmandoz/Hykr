//
//  HykrSubHeaderWhiteLabel.swift
//  Trekker
//
//  Created by Drew Seeholzer on 9/2/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class HykrSubHeaderWhiteLabel: UILabel {

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
    func overrideFont(with fontName: String) {
        guard let size = self.font?.pointSize else { return }
        self.font = UIFont(name: fontName, size: size)!
    }
    
    func setUpUI() {
        self.textColor = Colors.white.color()
        overrideFont(with: FontNames.roboto)
    }

}
