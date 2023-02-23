//
//  xbngBannerView.swift
//  example
//
//  Copyright © 2019 Bong. All rights reserved.
//

import Foundation
import Bong

struct BannerViewConfiguration {
    var pagingDuration = 3.0
    var enableSelection = true
}
class xbngBannerView: _bngView {
    private var callback:((Int) -> ())? = nil
    private let scrollView:UIScrollView = {
        let sc = UIScrollView(frame: .zero)
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.isPagingEnabled = true
        return sc
    }()
    
    private var itemAtIndex:((_ bannerView:xbngBannerView , _ index:Int)->(UIView))!
    private var numberOfItems:Int = 0
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func setListener(callback:((Int) -> ())?) {
        self.callback = callback
    }
    func reloadData(configuration:BannerViewConfiguration? , numberOfItems:Int , itemAtIndex:@escaping ((_ bannerView:xbngBannerView , _ index:Int)->(UIView)) ) {
        self.itemAtIndex = itemAtIndex
        self.numberOfItems = numberOfItems
        reloadScrollView()
        if configuration != nil {
            self.start(interval: configuration!.pagingDuration, repeats: true)
        }
    }
    override func onDestroy() {
        super.onDestroy()
        stop()
    }
    override func onTimer() {
        super.onTimer()
        /*
        scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x +
            self.scrollView.frame.size.width, y: self.scrollView.contentOffset.y)
        scrollViewDidEndDecelerating(scrollView)
        */
        /*
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
             self.scrollView.contentOffset = CGPoint(x: self.scrollView.contentOffset.x +
             self.scrollView.frame.size.width, y: self.scrollView.contentOffset.y)
             self.scrollViewDidEndDecelerating(self.scrollView)
         }, completion: nil)
        */
        scrollView.setContentOffset(CGPoint(x: self.scrollView.contentOffset.x +
            self.scrollView.frame.size.width, y: 0), animated: true)
        self.scrollViewDidEndDecelerating(self.scrollView)
        
        if callback != nil {
            let currentPage:Int = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
            callback!(currentPage)
        }
    }
    private func reloadScrollView() {
        guard self.numberOfItems > 0 else { return }
        if self.numberOfItems == 1 {
            let firstItem:UIView = self.itemAtIndex(self , 0)
            addViewToIndex(view: firstItem, index: 0)
            scrollView.isScrollEnabled = false
            return
        }
        let firstItem:UIView = self.itemAtIndex(self , 0)
        addViewToIndex(view: firstItem, index: numberOfItems+1)
        
        let lastItem:UIView = self.itemAtIndex(self , numberOfItems-1)
        addViewToIndex(view: lastItem, index: 0)
        for index in 0..<self.numberOfItems {
            let item:UIView = self.itemAtIndex(self , index)
            addViewToIndex(view: item, index: index+1)
        }
        scrollView.contentSize = CGSize(width: CGFloat(numberOfItems+2)*scrollView.frame.size.width, height: scrollView.frame.size.height)
        scrollView.contentOffset = CGPoint(x: self.scrollView.frame.size.width, y: self.scrollView.contentOffset.y)
    }
    private func addViewToIndex(view:UIView, index:Int) {
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        view.frame = CGRect(x: CGFloat(index)*scrollView.frame.size.width, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage:Int = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        if currentPage == 0 {
            self.scrollView.contentOffset = CGPoint(x: scrollView.frame.size.width * CGFloat(numberOfItems), y: scrollView.contentOffset.y)
        }
        else if currentPage == numberOfItems {
            self.scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y)
        }
    }
    private func setUpUI() {
        scrollView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        scrollView.delegate = self
        self.addSubview(scrollView)
        scrollView.showsHorizontalScrollIndicator = false
        //scrollView.isScrollEnabled = false
    }
}

extension UIImageView {
    func setImage(path:String) {
        guard let url:URL = URL(string: path) else { return }
        DispatchQueue.global(qos: .background).async {
            guard let data:Data = try? Data(contentsOf: url) , let image:UIImage = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}


