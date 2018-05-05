//
//  Float.swift
//  FunctionalSwift
//
//  Created by David Vallas on 4/11/18.
//  Copyright © 2018 David Vallas. All rights reserved.
//

import Foundation

extension Float {
    
    var sliderSpeed: TimeInterval {
        let actualValue = 1.0 - self
        let speed = 0.1 + (2.9 * actualValue)
        return TimeInterval(speed)
    }
    
}
