//
//  xbngViewController.swift
//  example
//
//  Copyright © 2019 Bong. All rights reserved.
//

import Foundation
import Bong

class xbngViewController : __bngViewController {
    
    private var loader:_bngLoading? = nil
    private var loading:xbngLoading? = nil
    
    override func onCreate() {
        super.onCreate()
    }
    override func onLayout(offset: Float) {
        super.onLayout(offset: offset)
    }
    override func onDestroy() {
        super.onDestroy()
        if loader != nil {
            loader?.hide()
            loader = nil
        }
        if loading != nil {
            loading?.removeFromSuperview()
            loading = nil
        }
    }
    
    public func alert() {
        
    }
    public func showLoader(_ v:UIView?=nil, custom:Bool=false) {
        if custom {
            loading = xbngLoading()
            if v != nil {
                v?.addSubview(self.loading!)
            }
            else {
                self.addSubview(self.loading!)
            }
        }
        else {
            loader = _bngLoading()
            loader?.show(v: v ?? self.view)
        }
    }
    public func hideLoader() {
        if loader != nil {
            loader?.hide()
            loader = nil
        }
        if loading != nil {
            loading?.removeFromSuperview()
            loading = nil
        }
    }
    public func showToast(message:String) {
        _bngToast.show(vc: self, message: message)
    }
}
