//
//  UIColorExtension.swift
//  NoteManager
//
//  Created by Lada Vrska on 15/09/2019.
//  Copyright © 2019 Lada Vrska. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor{
    
    convenience init(rgba: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)) {
        self.init(red: rgba.r, green: rgba.g, blue: rgba.b, alpha: rgba.a)
    }
    
    fileprivate class func colorWith(R: CGFloat, G: CGFloat, B: CGFloat, A: CGFloat) -> UIColor {
        return UIColor(rgba: (R/255.0, G/255.0, B/255.0, A))
    }
    
    class func yellowGreenLight() -> UIColor {
        return self.colorWith(R:158, G:222, B:62, A:1.0)
    }
    
    class func yellowGreenDark() -> UIColor {
        return self.colorWith(R:101, G:201, B:54, A:1.0)
    }

}
