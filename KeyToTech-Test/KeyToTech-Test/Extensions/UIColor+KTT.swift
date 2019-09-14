//
//  UIColor+KTT.swift
//  KeyToTech-Test
//
//  Created by Dima Dobrovolskyy on 9/12/19.
//  Copyright © 2019 Dima Dobrovolskyy. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func lightGray() -> UIColor {
        return UIColor(hexString: "#d3d3d3")
    }
    
    static func darkGray() -> UIColor {
        return UIColor(hexString: "#2c2c2c")
    }
    
    static func darkBlue() -> UIColor {
        return UIColor(hexString: "#1d2b43")
    }
    
    static func lightBlue() -> UIColor {
        return UIColor(hexString: "#5a91a6")
    }
    
    public convenience init(hexString: String) {
        let hexString = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) as String
        let scanner = Scanner(string: hexString)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }

    
}
