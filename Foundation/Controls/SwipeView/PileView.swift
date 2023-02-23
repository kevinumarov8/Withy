//
//  PileView.swift
//  PileView
//
//  Created by Jeff Barg on 6/17/14.
//  Copyright (c) 2014 Fructose Tech. All rights reserved.
//

import UIKit
import Bong

class PileView : UIView {
    
    var popCardViewWithFrame : ((CGRect) -> UIView?)?
    var swipeViews : [SwipeView] = []
    private var callback:((Int, Dictionary<String, Any>?) -> ())? = nil
    let transformRatio : CGFloat = 0.93
    var previous:SwipeDirection = .none
    
    override init(frame: CGRect)  {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func clearContents() {
        for view in swipeViews {
            view.removeFromSuperview()
        }
        swipeViews.removeAll()
    }
    public func removeContents(direction:SwipeDirection) {
        guard self.swipeViews.count > 0 else { return }
        let view = self.swipeViews[0]
        var translation = CGPoint.zero
        if direction == .left {
            translation.x = -100
        }
        else if (direction == .right) {
            translation.x = 100
        }
        translation.y = 50
        view.rotateForTranslation(translation, withRotationDirection: .rotationTowardsCenter)
        view.exitSuperviewFromTranslation(translation)
        view.executeOnPanForTranslation(translation)
    }
    func reloadContent(animation:Bool=true) {
        if (swipeViews.count >= 4) {
            return
        }
        
        for position in self.swipeViews.count...3 {
            let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            
            if let view = self.popCardViewWithFrame?(frame) {
                //Wrap view in a SwipeView
                let options = self.optionsForView(view)
                
                let swipeView = SwipeView(frame: frame, contentView: view, options: options)
                swipeView.viewWasChosenWithDirection = {(command:Int, view : UIView, direction : SwipeDirection) -> () in
                    /*
                    if (direction == .none) {
                        return
                    }
                    */
                    switch command {
                    case 11: //dragging
                        self.previous = direction
                    case 10: //drag & touch up
                        let view = self.swipeViews[0]
                        view.removeFromSuperview()
                        self.swipeViews.remove(at: 0)
                        self.reloadContent()
                    default:
                        break
                    }
                    
                    if self.callback != nil {
                        var dic = Dictionary<String, Any>()
                        dic["position"] = Int(position)
                        if command == 10 {
                            if direction == .none {
                                dic["direction"] = self.previous == .right ? SwipeDirection.left : SwipeDirection.right
                            }
                            else {
                                dic["direction"] = direction
                            }
                        }
                        else if command == 11 {
                            dic["direction"] = direction
                        }
                        dic["view"] = swipeView.contentView
                        dic["remain"] = self.swipeViews.count
                        self.callback!(command, dic)
                    }
                }
                
                //Animate insertion
                self.animateCardInsertion(swipeView, atPosition: CGFloat(position), animation: animation)
                self.insertSubview(swipeView, at: 0)
                self.swipeViews.append(swipeView)

            } else {
                return
            }
        }
    }
    
    public func getTopPositionView()->UIView? {
        guard self.swipeViews.count > 0 else { return nil }
        return swipeViews[0].contentView
    }
    func animateCardInsertion(_ swipeView : SwipeView, atPosition position : CGFloat, animation:Bool) {
        let transform = self.transformForPosition(position)
        let frame = swipeView.frame
        
        let verticalOffset : CGFloat = -50
        swipeView.frame = frame.offsetBy(dx: 0, dy: verticalOffset)
        swipeView.alpha = 0
        swipeView.isOpaque = false
        
        if animation {
            let animationOptions = UIView.AnimationOptions.curveEaseOut
            let duration : TimeInterval = 0.3
            let delay : TimeInterval = duration * Double(4 - position) / Double(1.5)
            UIView.animate(withDuration: duration, delay: delay, options: animationOptions, animations: {
                swipeView.frame = frame
                swipeView.transform = transform
                swipeView.alpha = 1
                
                }, completion: {(finished : Bool) -> () in
                    if (finished) {
                        swipeView.isOpaque = true
                    }
                })
        }
        else {
            swipeView.frame = frame
            swipeView.transform = transform
            swipeView.alpha = 1
            swipeView.isOpaque = true
        }
        if callback != nil {
            var dic = Dictionary<String, Any>()
            dic["position"] = Int(position)
            dic["view"] = swipeView.contentView
            callback!(0, dic)
        }
    }
    func transformForPosition(_ position : CGFloat) -> CGAffineTransform {
        var transform : CGAffineTransform = CGAffineTransform.identity
        
        if (self.swipeViews.count > 0) { //Keep transform at identity if first view
            let scale = pow(transformRatio, position)
            transform = CGAffineTransform(scaleX: scale, y: scale)
            
            let percentage = __bngNumber.percentage(value: Float(self.frame.size.height), total: pt(360))
            let margin = __bngNumber.percentage(percentage: percentage, total: pt(23))
            
            transform = transform.translatedBy(x: 0, y: -CGFloat(margin) * position)
        }
        
        return transform
    }
    
    func optionsForView(_ view : UIView) -> SwipeOptions {
        let options = SwipeOptions()
        options.onPan = {(panState : PanState) -> () in
            for i in 1 ..< self.swipeViews.count {
                let swipeView = self.swipeViews[i]
                let ratio = panState.thresholdRatio
                let position = CGFloat(i) - ratio
                
                let transform = self.transformForPosition(position)
                
                swipeView.transform = transform
            }
        }
        /*
        if callback != nil {
            var dic = Dictionary<String, Any>()
            dic["view"] = view
            callback!(0, dic)
        }
        */
        return options
    }
    public func setListener(callback:((Int, Dictionary<String, Any>?) -> ())?) { self.callback = callback }
    
}
