//
//  __bngCollectionCell.swift
//  example
//
//  Copyright © 2019 Bong. All rights reserved.
//

import Foundation
import Bong
import Alamofire

class __bngCollectionCell : _bngCollectionCell {
    
    public func load(url:String) {
        Alamofire.request(url).responseImage { response in
            if let image = response.result.value {
                //let roundedImage = image.af_imageRounded(withCornerRadius: CGFloat(20))
                self.setBackgroundImage(obj: image)
            }
        }
    }
    
}
