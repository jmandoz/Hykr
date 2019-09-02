//
//  HykrTextField.swift
//  Trekker
//
//  Created by Drew Seeholzer on 8/30/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class HykrTextField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUpUI() {
        self.textColor = Colors.darkBrown.color()
        overrideFont(with: FontNames.latoRegular)
    }
    
    func overrideFont(with fontName: String) {
        guard let size = self.font?.pointSize else { return }
        self.font = UIFont(name: fontName, size: size)!
    }

    
}
