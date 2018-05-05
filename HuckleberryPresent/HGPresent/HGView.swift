//
//  HGView.swift
//  HuckleberryPresent
//
//  Created by David Vallas on 5/5/18.
//  Copyright © 2018 David Vallas. All rights reserved.
//

import UIKit

extension UIView {
    
    var safeArea: CGRect {
        let insets = self.safeAreaInsets
        let bounds = self.bounds
        let rect = CGRect(x: bounds.origin.x + insets.left,
                          y: bounds.origin.y + insets.top,
                          width: bounds.size.width - insets.left - insets.right,
                          height: bounds.size.height - insets.top - insets.bottom)
        return rect
    }
    
}
