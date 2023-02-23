//
//  xbngLoader.swift
//  ChocspoApp
//
//  Created by 김봉희 on 2019/11/21.
//  Copyright © 2019 김봉희. All rights reserved.
//

import Foundation
import NVActivityIndicatorView
import Bong

class xbngLoading : xbngView {
    
    private var loading:NVActivityIndicatorView? = nil
    
    override func onCreate() {
        super.onCreate()
    }
    override func onDestroy() {
        super.onDestroy()
        if loading != nil {
            loading?.stopAnimating()
            loading?.removeFromSuperview()
            loading = nil
        }
    }
    override func onLayout(offset: Float) {
        super.onLayout(offset: offset)
        
        width(width: screenWidth())
        height(height: screenHeight())
        self.backgroundColor = hex("#888888", alpha: 0.5)
        self.layer.zPosition = 100
        
        let size = pt(40)
        loading = NVActivityIndicatorView(frame: CGRect(x: CGFloat(mid(self.width(), size)), y: CGFloat(mid(self.height()-pt(50), size)), width: CGFloat(size), height: CGFloat(size)), type: .pacman, color: Color.white, padding: nil)
        loading?.startAnimating()
        self.addSubview(loading!)
    }
    
}
