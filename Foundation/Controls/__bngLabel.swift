//
//  __bngLabel.swift
//  ChocspoApp
//
//  Created by 김봉희 on 2019/12/09.
//  Copyright © 2019 김봉희. All rights reserved.
//

import Foundation
import Bong

class __bngLabel : _bngLabel {
    
    public static func makex() -> __bngLabel {
        return __bngLabel(frame: CGRect(x:0, y:0, width:0, height:0))
    }
    public static func makex(x: Float, y: Float, width: Float, height: Float) -> __bngLabel {
        let v:__bngLabel = __bngLabel(frame: CGRect(x:CGFloat(x), y:CGFloat(y), width:CGFloat(width), height:CGFloat(height)))
        return v
    }
    public static func makex(x: Float, y: Float, width: Float, height: Float, color:UIColor) -> __bngLabel {
        let v:__bngLabel = __bngLabel.makex(x: x, y: y, width: width, height: height)
        v.backgroundColor = color
        return v
    }
    public func setStylex(color:UIColor, size:Float, font:String="regular") {
        setTextColor(color: color)
        setStylex(size: size, font: font)
    }
    public func setStylex(size:Float, font:String="regular") {
        if font == "bold" {
            self.font = _bngFont.boldSystemFont(ofSize:CGFloat(size))
        }
        else if font == "medium" {
            self.font = _bngFont.systemMediumFont(ofSize:CGFloat(size))
        }
        else if font == "italic" {
            //let tmp = UIFont(name: "Roboto-MediumItalic", size: CGFloat(size))
            let tmp = UIFont.preferredFont(forTextStyle: .body)
            self.font = tmp.bold_italic
        }
        else {
            self.font = _bngFont.systemFont(ofSize:CGFloat(size))
        }
    }
    
}
