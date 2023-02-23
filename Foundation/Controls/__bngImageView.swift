//
//  __bngImageView.swift
//  example
//
//  Copyright © 2019 Bong. All rights reserved.
//

import Foundation
import Bong
import Alamofire
import AlamofireImage

class __bngImageView : _bngImageView {
    
    class Memory {
        static let shared = Memory()
        private init() {
            
        }
        public var dic = Dictionary<String, Any>()
    }
    
    override func onCreate() {
        super.onCreate()
    }
    override func onLayout(offset: Float) {
        super.onLayout(offset: offset)
    }
    override func onDestroy() {
        super.onDestroy()
    }
    
    public static func get(url:String) -> UIImage? { return Memory.shared.dic[url] as? UIImage }
    public func set(image:UIImage, circle:Bool=false, round:Float=pt(0)) {
        if circle {
            self.image = image.af_imageRoundedIntoCircle()
        }
        else {
            if round > 0 {
                let resize = image.af_imageAspectScaled(toFill: CGSize(width: self.frame.size.width, height: self.frame.size.height))
                self.image = resize.af_imageRounded(withCornerRadius: CGFloat(round))
            }
            else {
                self.image = image
            }
        }
        self.animation = Spring.AnimationPreset.FadeIn.rawValue
        self.animate()
    }
    public func load(url:String, _ circle:Bool=false, _ round:Float=pt(0), _ encoding:Bool=true, callback:((UIImage?) -> ())?=nil) {
        if let saved = Memory.shared.dic[url] {
            set(image: saved as! UIImage, circle: circle, round: round)
            if callback != nil {
                callback!((saved as! UIImage))
            }
        }
        else {
            DataRequest.addAcceptableImageContentTypes(["binary/octet-stream"])
            Alamofire.request(encoding ? url.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)! : url, method: .get).responseImage { response in
                debugPrint(response.result)
                if let image = response.result.value {
                    self.set(image: image, circle: circle, round: round)
                    Memory.shared.dic[url] = image
                }
                if callback != nil {
                    callback!(response.result.value)
                }
            }
        }
    }
    public static func makex(x: Float, y: Float, width: Float, height: Float) -> __bngImageView {
        return __bngImageView(frame: CGRect(x:CGFloat(x), y:CGFloat(y), width:CGFloat(width), height:CGFloat(height)))
    }
    public static func makex(x: Float, y: Float, width: Float, height: Float, color:UIColor) -> __bngImageView {
        let v = __bngImageView.makex(x: x, y: y, width: width, height: height)
        v.backgroundColor = color
        return v
    }
    public static func makex(x: Float, y: Float, width: Float, height: Float, image:String) -> __bngImageView {
        let v = __bngImageView.makex(x: x, y: y, width: width, height: height)
        v.setBackgroundImage(image: image)
        return v
    }
}
extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
