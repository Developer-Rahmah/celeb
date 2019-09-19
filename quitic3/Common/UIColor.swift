//
//  UIColor.swift
//  quitic3
//
//  Created by DOT on 7/10/18.
//  Copyright © 2018 DOT. All rights reserved.
//

import UIKit

extension UIColor{
    static let quiticPink =   UIColor.init(red: 251, green: 96, blue: 127)
    static let textPrimaryColor = UIColor(hex: 0x757575)
    static let accentBlue = UIColor(hex: 0x03a9f4)
    static let textColorSecondary = UIColor(hex: 0x404040)
    static let productBorderColor = UIColor(hex: 0xD8D8D8)
    
    convenience  init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red)/255.0,
            green: CGFloat(green)/255.0,
            blue: CGFloat(blue)/255.0,
            alpha: a
        )
    }
    
    convenience init(hex: Int, a:CGFloat = 1.0) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF,
            a: a
        )
    }
}


