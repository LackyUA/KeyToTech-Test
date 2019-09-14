//
//  UIFont+KTT.swift
//  KeyToTech-Test
//
//  Created by Dima Dobrovolskyy on 9/12/19.
//  Copyright © 2019 Dima Dobrovolskyy. All rights reserved.
//

import UIKit

extension UIFont {
    
    static func regularWithSize(_ size: Int) -> UIFont {
        return UIFont(name: "PlayfairDisplay-Regular", size: CGFloat(size))!
    }
    
    static func boldWithSize(_ size :Int) -> UIFont {
        return UIFont(name: "PlayfairDisplay-Bold", size: CGFloat(size))!
    }
    
}

