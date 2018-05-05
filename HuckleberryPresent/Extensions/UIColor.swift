//
//  UIColor.swift
//  FunctionalSwift
//
//  Created by David Vallas on 4/11/18.
//  Copyright © 2018 David Vallas. All rights reserved.
//

import UIKit

extension UIColor {
    
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let coreImageColor = CIColor(color: self)
        return (coreImageColor.red, coreImageColor.green, coreImageColor.blue, coreImageColor.alpha)
    }
    
}
