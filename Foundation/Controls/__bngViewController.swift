//
//  __bngViewController.swift
//  example
//
//  Copyright © 2019 Bong. All rights reserved.
//

import Foundation
import Bong
import Jelly
import SideMenuSwift
import Presentr

class __bngViewController : _bngViewController {
    
    private var statusLightContent = false
    private var statusHidden = false
    override func onCreate() {
        super.onCreate()
        if !statusHidden {
            self.setStatusBarColor(color: self.view.backgroundColor!)
        }

    }
    public func setStatusHidden(hidden:Bool) {
        self.statusHidden = hidden
    }
    override var prefersStatusBarHidden: Bool {
        return statusHidden
    }
    public func setStatusBarColor(color:UIColor, content:Bool=false) {
        if !statusHidden {
            self.statusLightContent = content
            let v = View.make(x: 0, y: 0, width: self.width(), height: statusBar(), color: color)
            v.setLayerTop()
            self.addSubview(v)
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return (statusLightContent) ? .lightContent : .default
    }
    override var modalPresentationCapturesStatusBarAppearance: Bool { set {} get{ return true }}
    
    override func onLayout(offset: Float) {
        super.onLayout(offset: offset)
    }
    
    let presentr_right: Presentr = {
        let customPresenter = Presentr(presentationType: .fullScreen )
        customPresenter.transitionType = .coverHorizontalFromRight
        customPresenter.dismissTransitionType = .coverHorizontalFromRight
        customPresenter.roundCorners = false
        return customPresenter
    }()
    let presentr_left: Presentr = {
        let customPresenter = Presentr(presentationType: .fullScreen )
        customPresenter.transitionType = .coverHorizontalFromLeft
        customPresenter.dismissTransitionType = .coverHorizontalFromLeft
        customPresenter.roundCorners = false
        return customPresenter
    }()
    let presentr_bottom: Presentr = {
        let customPresenter = Presentr(presentationType: .fullScreen )
        customPresenter.transitionType = .coverVertical
        customPresenter.dismissTransitionType = .coverVertical
        customPresenter.roundCorners = false
        return customPresenter
    }()
    public func startx(to:__bngViewController, _ animated:Bool=true, _ completion:((Any?) -> ())?=nil) {
        to.setInvoker(invoker: self)
        if completion != nil {
            to.setCompletionHandler(handler: completion!)
        }
        customPresentViewController(presentr_right, viewController: to, animated: animated, completion: nil)
    }
    public func startxx(to:__bngViewController, _ completion:((Any?) -> ())?=nil) {
        to.setInvoker(invoker: self)
        if completion != nil {
            to.setCompletionHandler(handler: completion!)
        }
        customPresentViewController(presentr_bottom, viewController: to, animated: true, completion: nil)
    }
    public func finishx(_ object:Any?=nil) {
        super.finish(object)
    }
    public func startx(to:__bngViewController, _ animated:Bool=true, _ direction:Direction = .right, _ delay:Double=0.3, _ completion:((Any?) -> ())?=nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            let presentation = SlidePresentation(direction: direction)
            let animator: Jelly.Animator? = Animator(presentation:presentation)
            animator?.prepare(presentedViewController: to)
            self.start(to: to, animated, completion)
        }
    }
    public func startx(to:__bngViewController, _ animated:Bool=true, _ delay:Double=0.3, _ completion:((Any?) -> ())?=nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            let presentation = FadePresentation()
            let animator: Jelly.Animator? = Animator(presentation:presentation)
            animator?.prepare(presentedViewController: to)
            self.start(to: to, animated, completion)
        }
    }
    public static func startx(from:__bngViewController, to:__bngViewController, _ animated:Bool=true, _
                    direction:Direction = .right, _ delay:Double=0.3, _ completion:((Any?) -> ())?=nil) {
        from.startx(to: to, animated, direction, delay, completion)
    }
    public func finishx(_ delay:Double=0.1, _ object:Any?=nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            let presentation = SlidePresentation(direction: .right)
            let animator: Jelly.Animator? = Animator(presentation:presentation)
            animator?.prepare(presentedViewController: self)
            self.finish(object)
        }
    }
    public func add(vc:__bngViewController, width:Float)->SideMenuController {
        SideMenuController.preferences.basic.menuWidth = CGFloat(width)
        SideMenuController.preferences.basic.statusBarBehavior = .none
        SideMenuController.preferences.basic.position = .above
        SideMenuController.preferences.basic.direction = .left
        SideMenuController.preferences.basic.enablePanGesture = true
        SideMenuController.preferences.basic.supportedOrientations = .portrait
        SideMenuController.preferences.basic.shouldRespectLanguageDirection = true
        return SideMenuController(contentViewController: self, menuViewController: vc)
    }
    public func start(to:SideMenuController, _ animated:Bool=true, _ direction:Direction = .right) {
        let presentation = SlidePresentation(direction: direction)
        let animator: Jelly.Animator? = Animator(presentation:presentation)
        animator?.prepare(presentedViewController: to)
        self.present(to, animated: animated, completion: nil)
    }
}
