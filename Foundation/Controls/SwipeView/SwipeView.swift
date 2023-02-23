//
//  SwipeView.swift
//  PileView
//
//  Created by Jeff Barg on 6/16/14.
//  Copyright (c) 2014 Fructose Tech. All rights reserved.
//

import UIKit
import Bong

class SwipeView: UIView {
    
    var options : SwipeOptions
    var viewState : SwipeViewState = SwipeViewState()
    
    var contentView : UIView
    
    //Delegate Functions
    var viewDidCancelSwipe : ((UIView) -> ())?
    var viewWasChosenWithDirection : ((Int, UIView, SwipeDirection) -> ())?
    
    init(frame: CGRect, contentView: UIView, options : SwipeOptions) {
        contentView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        contentView.contentMode = .scaleToFill
        self.options = options
        self.contentView = contentView
        
        super.init(frame: frame)

        self.setupView()
        self.setupSwipe()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        self.backgroundColor = .white
        //self.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: CGFloat(pt(8)))
        
        
        //self.layer.cornerRadius = CGFloat(pt(8))
        //self.clipsToBounds = true
        //self.roundCorners(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: CGFloat(pt(8)))
        /*
        layer.cornerRadius = CGFloat(pt(8))
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = CGFloat(pt(8))
        
        let containerView = UIView(frame: self.frame)
        containerView.layer.cornerRadius = CGFloat(pt(8))
        containerView.layer.masksToBounds = true
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        let shadow = CAShapeLayer()
        shadow.path = UIBezierPath(roundedRect: bounds, cornerRadius: CGFloat(pt(8))).cgPath
        shadow.shadowColor = UIColor.black.cgColor
        shadow.fillColor = self.backgroundColor?.cgColor
        shadow.shadowPath = shadow.path
        shadow.shadowOffset = CGSize(width: 1.0, height: 1.0)
        shadow.shadowOpacity = pt(0.4)
        shadow.shadowRadius = CGFloat(pt(8))
        layer.insertSublayer(shadow, at: 0)
        self.addSubview(self.contentView)
        */
        
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = CGFloat(pt(8))
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.masksToBounds = false
        self.layer.cornerRadius = CGFloat(pt(8))
        self.addSubview(self.contentView)
    }
    
    func setupSwipe() {
        self.viewState.originalCenter = self.center
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(SwipeView.onSwipe(_:)))
        self.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func onSwipe(_ panGestureRecognizer : UIPanGestureRecognizer!) {
        let view = panGestureRecognizer.view!
        
        switch (panGestureRecognizer.state) {
        case UIGestureRecognizer.State.began:
            if (panGestureRecognizer.location(in: view).y < view.center.y) {
                self.viewState.rotationDirection = .rotationAwayFromCenter
            } else {
                self.viewState.rotationDirection = .rotationTowardsCenter
            }
        case UIGestureRecognizer.State.ended:
            self.finalizePosition()
        default:
            let translation : CGPoint = panGestureRecognizer.translation(in: view)
            view.center = self.viewState.originalCenter + translation
            self.rotateForTranslation(translation, withRotationDirection: self.viewState.rotationDirection)
            self.executeOnPanForTranslation(translation)
        }
    }
    
    func rotateForTranslation(_ translation : CGPoint, withRotationDirection rotationDirection : RotationDirection) {
        var rotation :CGFloat = (translation.x/self.options.threshold * self.options.rotationFactor).toRadians
        
        switch (rotationDirection) {
        case .rotationAwayFromCenter:
            rotation *= 1
        case .rotationTowardsCenter:
            rotation *= -1
        }
        
        self.transform = CGAffineTransform.identity.rotated(by: rotation);
    }
    
    func finalizePosition() {
        let direction = self.directionOfExceededThreshold();
        
        switch (direction) {
        case .left, .right, .up, .down:
            let translation = self.center - self.viewState.originalCenter;
            self.exitSuperviewFromTranslation(translation)
        case .none:
            self.returnToOriginalCenter()
            self.executeOnPanForTranslation(CGPoint.zero)
        }
    }
    
    func executeOnPanForTranslation(_ translation : CGPoint) {
        let thresholdRatio : CGFloat = min(
            1,
            sqrt(
                pow(translation.x, 2) +
                pow(translation.y, 2)
            ) / self.options.threshold * 1.414
        )

        var direction = SwipeDirection.none
        if (translation.x > 0) {
            direction = .right
        } else if (translation.x < 0) {
            direction = .left
        }
        
        let state = PanState(direction: direction, view: self, thresholdRatio: thresholdRatio)
        self.options.onPan(state)
        
        self.viewWasChosenWithDirection?(11, self, direction)
    }
    
    func returnToOriginalCenter() {
        UIView.animate(withDuration: self.options.swipeCancelledAnimationDuration,
            delay: 0.0,
            options: self.options.swipeCancelledAnimationOptions,
            animations: {
                self.transform = CGAffineTransform.identity;
                self.center = self.viewState.originalCenter;
            }, completion: {(finished : Bool) -> () in
                if (finished) {
                    self.viewDidCancelSwipe?(self)   
                }
            })
    }

    func exitSuperviewFromTranslation(_ translation : CGPoint) {
        let direction = self.directionOfExceededThreshold()
        
        let result = SwipeResult()
        result.view = self
        result.translation = translation
        result.direction = direction
        result.onCompletion = {
            self.viewWasChosenWithDirection?(10, self, direction)
            return
        }
        
        self.options.onChosen(result)
    }

        
    func directionOfExceededThreshold() -> SwipeDirection {
        let translation = self.viewState.originalCenter - self.center
        let threshold = self.options.threshold
        
        switch (translation.x, translation.y) {
        case let (x, y) where x < -threshold && abs(y) < threshold:
            return .left
        case let (x, y) where y < -threshold && abs(x) < threshold:
            return .down
        case let (x, y) where x > threshold && abs(y) < threshold:
            return .right
        case let (x, y) where y > threshold && abs(x) < threshold:
            return .up
        default:
            return .none
        }

//        if (self.center.x > (self.viewState.originalCenter.x + self.options.threshold)) {
//            return .Right
//        } else if (self.center.x < (self.viewState.originalCenter.x - self.options.threshold)) {
//            return .Left
//        } else {
//            return .None
//        }
    }
}
