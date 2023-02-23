//
//  __bngView.swift
//  ChocspoApp
//
//  Created by 김봉희 on 2019/10/13.
//  Copyright © 2019 김봉희. All rights reserved.
//

import Foundation
import Bong

class __bngView : _bngView {
    override func onCreate() {
        super.onCreate()
    }
    override func onDestroy() {
        super.onDestroy()
    }
    override func onLayout(offset: Float) {
        super.onLayout(offset: offset)
    }
    public static func makex(x: Float, y: Float, width: Float, height: Float) -> __bngView {
        return __bngView(frame: CGRect(x:CGFloat(x), y:CGFloat(y), width:CGFloat(width), height:CGFloat(height)))
    }
    public static func makex(x: Float, y: Float, width: Float, height: Float, color:UIColor) -> __bngView {
        let v = __bngView.makex(x: x, y: y, width: width, height: height)
        v.backgroundColor = color
        return v
    }
    public static func makex(x: Float, y: Float, width: Float, height: Float, image:String) -> __bngView {
        let v = __bngView.makex(x: x, y: y, width: width, height: height)
        v.setBackgroundImage(image:image)
        return v
    }
    
    
}
