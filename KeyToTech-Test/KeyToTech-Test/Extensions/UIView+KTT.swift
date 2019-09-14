//
//  UIView+KTT.swift
//  KeyToTech-Test
//
//  Created by Dima Dobrovolskyy on 9/12/19.
//  Copyright © 2019 Dima Dobrovolskyy. All rights reserved.
//

import UIKit

extension UIView {
    
    /// Method for visualizing wrong creds.
    func shake() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        layer.add(shake, forKey: nil)
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
}

