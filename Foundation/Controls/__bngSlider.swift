//
//  __bngSlider.swift
//  ChocspoApp
//
//  Copyright © 2020 김봉희. All rights reserved.
//

import Foundation
import Bong

class __bngSlider : _bngSlider {
    
    public static func makex(x: Float, y: Float, width: Float, height: Float) -> __bngSlider {
        return __bngSlider(frame: CGRect(x:CGFloat(x), y:CGFloat(y), width:CGFloat(width), height:CGFloat(height)))
    }
    public static func makex(x: Float, y: Float, width: Float, height: Float, color:UIColor) -> __bngSlider {
        let v = __bngSlider.makex(x: x, y: y, width: width, height: height)
        v.backgroundColor = color
        return v
    }
    public func setThumbImage(image:UIImage) {
        self.setThumbImage(image, for: .normal)
        //self.setThumbImage(object, for: .selected)
        //self.setThumbImage(object, for: .focused)
        self.setThumbImage(image, for: .highlighted)
    }
}
