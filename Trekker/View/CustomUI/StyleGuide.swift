//
//  StyleGuide.swift
//  Trekker
//
//  Created by Drew Seeholzer on 8/30/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

extension UIView {
    func addCornerRadius(_ radius: CGFloat = 4) {
        self.layer.cornerRadius = radius
    }
    
    func addBorder(width: CGFloat = 0.5, color: UIColor = Colors.ultraLightGrey.color()) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
}


struct FontNames {
    /// Headers
    static let arielBold = "Arial-BoldMT"
    /// Sub headers
    static let roboto = "Roboto-Regular"
    static let robotoBold = "Roboto-Bold"
    /// Body Copy
    static let latoRegular = "Lato-Regular"
    static let latoBold = "Lato-Bold"
}


    enum Colors {
        case lightGreen
        case green
        case darkBrown
        case white
        case lightGrey
        case ultraLightGrey
        
        func color() -> UIColor {
            switch self {
            case .lightGreen:
                return UIColor(hexString: "A0B6A5")
            case .green:
                return UIColor(hexString: "6E9075")
            case .darkBrown:
                return UIColor(hexString: "484538")
            case .white:
                return UIColor(hexString: "FFFFFF")
            case .lightGrey:
                return UIColor(hexString: "D3D3D3")
            case .ultraLightGrey:
                return UIColor(hexString: "E8E8E8")
            }
        }
    }
    extension UIColor {
        convenience init(hexString: String) {
            // Take hexString and turn it into hexidecimal value
            let hexString: String = (hexString as NSString).trimmingCharacters(in: .whitespacesAndNewlines)
            let scanner = Scanner(string: hexString as String)
            if hexString.hasPrefix("#") {
                scanner.scanLocation = 1
            }
            var color: UInt32 = 0
            scanner.scanHexInt32(&color)
            
            // Set color values for the hexidecimal
            let mask = 0x000000FF
            let r = Int(color >> 16) & mask
            let g = Int(color >> 8) & mask
            let b = Int(color) & mask
            
            let red = CGFloat(r) / 255.0
            let green = CGFloat(g) / 255.0
            let blue = CGFloat(b) / 255.0
            self.init(red: red, green: green, blue: blue, alpha: 1)
        }
    }

