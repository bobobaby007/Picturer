//
//  PicView.swift
//  Picturer
//
//  Created by Bob Huang on 15/7/11.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary

class SliderShower: UIView,UIScrollViewDelegate{
    
    var _scrollView:UIScrollView?
    var _page:Int = 0
    var _imagesArray:NSArray?
    var _pageController:UIPageControl?
    var _timer:NSTimer?
    let _interval:NSTimeInterval = 5
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        _pageController = UIPageControl()
        
        _scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        _scrollView!.maximumZoomScale = 1
        _scrollView?.pagingEnabled=true
        _scrollView!.minimumZoomScale = 1
        _scrollView?.bounces = false
        //self.bouncesZoom=false
        _scrollView!.scrollEnabled=true
        _scrollView!.showsHorizontalScrollIndicator=false
        _scrollView!.showsVerticalScrollIndicator=false
        
        _scrollView!.delegate=self
        
        self.addSubview(_scrollView!)
        
        _timer = NSTimer.scheduledTimerWithTimeInterval(_interval, target: self, selector: Selector("timerHander:"), userInfo: nil, repeats: true)
        
    }
    
    
    
    
    
    func _setup(__images:NSArray){
        _imagesArray = __images
        _pageController?.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height-16.5)
        _pageController?.numberOfPages = _imagesArray!.count
        
        self.addSubview(_pageController!)
        
        for var i:Int = 0;i<_imagesArray?.count;++i{
            let _picV:PicView = PicView(frame: CGRect(x: CGFloat(i)*self.bounds.width, y: 0, width: self.bounds.width, height: self.bounds.height))
            _scrollView?.addSubview(_picV)
            _picV._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
            _picV._setPic((_imagesArray?.objectAtIndex(i) as! NSDictionary).objectForKey("pic") as! NSDictionary, __block: { (__dict) -> Void in
                
            })
        }
        
        _scrollView?.contentSize = CGSize(width: CGFloat(_imagesArray!.count)*self.bounds.width, height: self.bounds.height)
        
    }
    
    
    //---正在挪动的时候
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        _timer?.invalidate()
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        
    }
    //---停止挪动
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let _p:Int = Int(scrollView.contentOffset.x/scrollView.frame.width)
        //scrollView.setContentOffset(CGPoint(x: CGFloat(_p)*self.frame.width, y: 0), animated: true)
        _pageController?.currentPage = _p
        
        _timer = NSTimer.scheduledTimerWithTimeInterval(_interval, target: self, selector: Selector("timerHander:"), userInfo: nil, repeats: true)
    }
    func timerHander(__timer:NSTimer){
         ++_page
        _showPage(_page)
    }
    
    func _showPage(__p:Int){
        _page = __p
        if _page >= _imagesArray?.count{
            _page = 0
            _pageController?.currentPage = _page
            _scrollView!.setContentOffset(CGPoint(x: CGFloat(_page)*self.frame.width, y: 0), animated: false)
        }
        if _page < 0{
            _page = _imagesArray!.count-1
            _pageController?.currentPage = _page
            _scrollView!.setContentOffset(CGPoint(x: CGFloat(_page)*self.frame.width, y: 0), animated: false)
        }
        _pageController?.currentPage = _page
        _scrollView!.setContentOffset(CGPoint(x: CGFloat(_page)*self.frame.width, y: 0), animated: true)
        
    }
    func _refreshView(){
        
    }
    override func removeFromSuperview() {
        _timer?.invalidate()
    }
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}