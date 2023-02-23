//
//  xbngDialog.swift
//  example
//
//  Copyright © 2019 Bong. All rights reserved.
//

import Foundation
import Bong

class xbngDialog : _bngView {
    
    private var anim1 = Spring.AnimationPreset.FadeIn.rawValue
    private var anim2 = Spring.AnimationPreset.FadeOut.rawValue
    
    override func onCreate() {
        super.onCreate()
    }
    override func onLayout(offset: Float) {
        super.onLayout(offset: offset)
        width(width: screenWidth())
        height(height: screenHeight())
        self.backgroundColor = hex("#888888", alpha: 0.5)
        self.setListener() { () -> () in
            self.hide()
        }
        self.layer.zPosition = 999
    }
    override func onDestroy() {
        super.onDestroy()
    }
    public func add(x:Float, y:Float, view:UIView) {
        view.frame.origin.x = CGFloat(x)
        view.frame.origin.y = CGFloat(y)
        self.addSubview(view)
    }
    public func add(_ view:UIView) {
        self.addSubview(view)
    }
    public func show(_ view:UIView) {
        view.addSubview(self)
        self.animation = anim1
        self.animate()
    }
    public func hide() {
        self.animation = anim2
        self.animateNext (completion:{() -> () in
            self.removeFromSuperview()
        })
    }
    public func setAnimation(show:String, hide:String) {
        self.anim1 = show
        self.anim2 = hide
    }
}
