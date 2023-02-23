//
//  __bngImageZoomView.swift
//  Copyright © 2020 Bong. All rights reserved.
//

import Foundation
import Bong

class __bngImageZoomView : _bngScrollView, UIScrollViewDelegate {
    
    override func onCreate() {
        super.onCreate()
    }
    override func onLayout(offset: Float) {
        super.onLayout(offset: offset)
    }
    override func onDestroy() {
        super.onDestroy()
    }
    
    public static func makez(x: Float, y: Float, width: Float, height: Float) -> __bngImageZoomView {
        return __bngImageZoomView(frame: CGRect(x:CGFloat(x), y:CGFloat(y), width:CGFloat(width), height:CGFloat(height)))
    }
    public static func makez(x: Float, y: Float, width: Float, height: Float, color:UIColor) -> __bngImageZoomView {
        let v = __bngImageZoomView.makez(x: x, y: y, width: width, height: height)
        v.backgroundColor = color
        return v
    }
    public static func makez(x: Float, y: Float, width: Float, height: Float, image:String) -> __bngImageZoomView {
        let v = __bngImageZoomView.makez(x: x, y: y, width: width, height: height)
        
        let iv = __bngImageView.makex(x: 0, y: 0, width: width, height: height, image: image)
        v.connectImageView(iv: iv)
        return v
    }
    public static func makez(x: Float, y: Float, width: Float, height: Float, image:UIImage) -> __bngImageZoomView {
        let v = __bngImageZoomView.makez(x: x, y: y, width: width, height: height)
        let iv = __bngImageView.makex(x: 0, y: 0, width: width, height: height)
        iv.set(image: image)
        v.connectImageView(iv: iv)
        return v
    }
    var gestureRecognizer: UITapGestureRecognizer!
    private func connectImageView(iv:__bngImageView) {
        iv.contentMode = .scaleAspectFit
        self.addSubview(iv)
        self.delegate = self
        self.minimumZoomScale = 1.0
        self.maximumZoomScale = 2.0
        self.setObjtag(objtag: iv)
        self.hideIndicator()
        self.setupGestureRecognizer()
    }
    func setupGestureRecognizer() {
        gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        gestureRecognizer.numberOfTapsRequired = 2
        addGestureRecognizer(gestureRecognizer)
    }
    @objc func handleDoubleTap() {
        if zoomScale == 1 {
            zoom(to: zoomRectForScale(maximumZoomScale, center: gestureRecognizer.location(in: gestureRecognizer.view)), animated: true)
        } else {
            setZoomScale(1, animated: true)
        }
    }
    func zoomRectForScale(_ scale: CGFloat, center: CGPoint) -> CGRect {
        let iv = self.getObjtag() as! __bngImageView
        var zoomRect = CGRect.zero
        zoomRect.size.height = iv.frame.size.height / scale
        zoomRect.size.width = iv.frame.size.width / scale
        let newCenter = convert(center, from: iv)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        let iv = self.getObjtag() as! __bngImageView
        return iv
    }
}
