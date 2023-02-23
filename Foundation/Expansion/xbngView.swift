//
//  xbngView.swift
//  ChocspoApp
//
//  Created by 김봉희 on 2019/10/13.
//  Copyright © 2019 김봉희. All rights reserved.
//

import Foundation
import Bong

class xbngView : __bngView {
    
    private var loader:_bngLoading? = nil
    private var loading:xbngLoading? = nil
    
    override func onCreate() {
        super.onCreate()
    }
    override func onDestroy() {
        super.onDestroy()
        DispatchQueue.main.async {
            if self.loader != nil {
                self.loader?.hide()
                self.loader = nil
            }
            if self.loading != nil {
                self.loading?.removeFromSuperview()
                self.loading = nil
            }
        }
    }
    override func onLayout(offset: Float) {
        super.onLayout(offset: offset)
    }
    public func showLoader(_ v:UIView?=nil, custom:Bool=false) {
        DispatchQueue.main.async {
            if custom {
                if self.loading != nil {
                    self.loading?.removeFromSuperview()
                    self.loading = nil
                }
                self.loading = xbngLoading()
                if v != nil {
                    v?.addSubview(self.loading!)
                }
                else {
                    self.parentViewController!.view.addSubview(self.loading!)
                }
            }
            else {
                if self.loader != nil {
                    self.loader?.hide()
                    self.loader = nil
                }
                self.loader = _bngLoading()
                self.loader?.show(v: v ?? self.parentViewController!.view)
            }
        }
    }
    public func hideLoader() {
        DispatchQueue.main.async {
            if self.loader != nil {
                self.loader?.hide()
                self.loader = nil
            }
            if self.loading != nil {
                self.loading?.removeFromSuperview()
                self.loading = nil
            }
        }
    }
    public func showToast(message:String) {
        _bngToast.show(vc: self.parentViewController!, message: message)
    }
}
