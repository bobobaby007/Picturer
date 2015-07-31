//
//  Manage_pic.swift
//  Picturers
//
//  Created by Bob Huang on 15/6/19.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary
import AVFoundation

protocol Social_pic_delegate:NSObjectProtocol{
    func canceled()
    func delete(picIndex:Int)
    func setCover(picIndex:Int)
    
}

class Social_pic: UIViewController,UIScrollViewDelegate{
    let _gap:CGFloat=15
    
    var _setuped:Bool=false
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    var _btn_moreAction:UIButton?
    var _title_label:UILabel?
    
    var _dataArray:NSMutableArray?=NSMutableArray()
    
    var _tapG:UITapGestureRecognizer?
    
    var _currentIndex:Int?
    
    var _picsArray:NSMutableArray?
    var _pic:NSMutableDictionary?
    
    var _delegate:Social_pic_delegate?
    var _scrollView:UIScrollView!
    
    var _viewType:String="view"//---view 浏览编辑，标题显示张数 //---select 选择 //--edit 编辑
    
    var _desView:UIView?
    var _desText:UITextView?
    var _desH:CGFloat=0//-----描述面板高度
    
    var _isScrolling:Bool = false
    
    var _range:Int = 0
    
    
    var _showingBar:Bool=true{
        didSet{
            UIView.beginAnimations("topA", context: nil)
            UIView.setAnimationDuration(0.2)
            if (_showingBar == true){
                _topBar?.frame=CGRect(x: 0, y: 0, width: _topBar!.frame.width, height: _topBar!.frame.height)
                _desView?.frame=CGRect(x: 0, y: self.view.frame.height-_desH, width: self.view.frame.width, height: _desH)
                UIApplication.sharedApplication().statusBarHidden=false
            }else{
                _topBar?.frame=CGRect(x: 0, y: -62, width: _topBar!.frame.width, height: _topBar!.frame.height)
                _desView?.frame=CGRect(x: 0, y: self.view.frame.height+0, width: self.view.frame.width, height: _desH)
                UIApplication.sharedApplication().statusBarHidden=true
            }
            
            UIView.commitAnimations()
        }
    }
    
    override func viewDidLoad() {
        setup()
        _getDatas()
    }
    
    func setup(){
        if _setuped{
            return
        }
        
        self.view.backgroundColor=UIColor.blackColor()
        
        super.viewDidLoad()
        _desView = UIView(frame: CGRect(x: 0, y: self.view.frame.height-_desH, width: self.view.frame.width, height: _desH))
        _desView?.backgroundColor=UIColor(white: 0, alpha: 0.8)
        
        _desText=UITextView(frame: CGRect(x: 5, y: 5, width: self.view.frame.width-10, height: 0))
        _desText?.backgroundColor=UIColor.clearColor()
        _desText?.textColor=UIColor.whiteColor()
        
        _desView?.addSubview(_desText!)
        self.view.addSubview(_desView!)
        
        
        _topBar=UIView(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: 62))
        _topBar?.backgroundColor=UIColor.blackColor()
        _btn_cancel=UIButton(frame:CGRect(x: 6, y: 30, width: 40, height: 22))
        _btn_cancel?.setImage(UIImage(named: "back_icon.png"), forState: UIControlState.Normal)
        _btn_cancel!.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        _btn_cancel?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_moreAction=UIButton(frame:CGRect(x: 10, y: 30, width: 13, height: 22))
        _btn_moreAction?.setImage(UIImage(named: "changeToCollect_icon.png"), forState: UIControlState.Normal)
        _btn_moreAction?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        _title_label=UILabel(frame:CGRect(x: 50, y: 5, width: self.view.frame.width-100, height: 62))
        _title_label?.textColor=UIColor.whiteColor()
        _title_label?.textAlignment=NSTextAlignment.Center
        _title_label?.text="6月2日\n2/28"
        
        self.view.addSubview(_topBar!)
        
        _topBar?.addSubview(_btn_cancel!)
        _topBar?.addSubview(_title_label!)
        
        
        _setuped=true
    }
    
    //-----根据排列顺序调出图片
    func _getPicAtIndex(__index:Int)->NSDictionary{
        var _dict:NSDictionary
        _dict = _picsArray?.objectAtIndex(__index) as! NSDictionary
        
        return _dict.objectForKey("pic") as! NSDictionary
    }
    func _showIndexAtPics(__index:Int,__array:NSArray){
        _picsArray=NSMutableArray(array: __array)
        _currentIndex=__index
        
        if _currentIndex > _picsArray!.count-1{
            _currentIndex = _picsArray!.count-1
        }
        if _currentIndex < 0{
            _currentIndex = 0
        }
        //_scrollView?.removeFromSuperview()
        _scrollView=UIScrollView(frame: self.view.frame)
        self.view.insertSubview(_scrollView!, atIndex: 0)
        _scrollView!.bounces=false
        //_scrollView!.bouncesZoom=true
        //_scrollView!.maximumZoomScale=2.0
        _scrollView!.showsVerticalScrollIndicator=false
        _scrollView!.showsHorizontalScrollIndicator=false
        _scrollView!.pagingEnabled=true
        
        _scrollView!.delegate=self
        
        _scrollView!.contentSize=CGSize(width: CGFloat(_picsArray!.count)*self.view.frame.width, height: self.view.frame.height-60)
        _scrollView?.contentOffset.x = CGFloat(_currentIndex!)*_scrollView!.frame.width
        
        
        _tapG=UITapGestureRecognizer(target: self, action: Selector("tapHander:"))
        _scrollView?.addGestureRecognizer(_tapG!)
        
        _moveToPicByIndex(_currentIndex!)
        
    }
    
    func _clear(){
        let _n = _scrollView.subviews.count
        
        for view in _scrollView.subviews{
            view.removeFromSuperview()
            println("remove")
        }
        _scrollView?.removeFromSuperview()
        
    }
    
    func tapHander(tap:UITapGestureRecognizer){
        _showingBar = !_showingBar
    }
    
    func _moveToPicByIndex(__index:Int){
        _currentIndex=__index
        if (_currentIndex!>_picsArray!.count-1){
            _currentIndex=_picsArray!.count-1
        }
        
        _pic = NSMutableDictionary(dictionary: (_getPicAtIndex(_currentIndex!)))
        
        _viewInAtIndex(__index)
        _viewInAtIndex(__index+1)
        _viewInAtIndex(__index-1)
        
    }
    
    //---正在挪动的时候
    func scrollViewDidScroll(scrollView: UIScrollView) {
        _showingBar = false
        if _tapG != nil{
            _scrollView?.removeGestureRecognizer(_tapG!)
        }
        
    }
    //---停止挪动
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        _isScrolling=false
        
        var _p:Int = Int(scrollView.contentOffset.x/scrollView.frame.width)
        
        _moveToPicByIndex(_p)
        _scrollView?.addGestureRecognizer(_tapG!)
        
    }
    
    func _viewInAtIndex(__index:Int){
        var _picV:PicView!
        if __index<0{
            return
        }
        if __index>_picsArray!.count-1{
            return
        }
        if (_scrollView?.viewWithTag(100+__index) != nil){
            
            _picV=_scrollView?.viewWithTag(100+__index) as! PicView
            //println(_picV.superview?.isEqual(self.view))
        }else{
            
            _picV=PicView(frame: CGRect(x: CGFloat(__index)*_scrollView!.frame.width, y: 0, width: _scrollView!.frame.width, height: _scrollView!.frame.height))
            _picV.tag=100+__index
            
        }
        _picV._setPic(_getPicAtIndex(__index),__block: { (__dict) -> Void in
            
        })
        
        _scrollView!.addSubview(_picV)
    }
    
    func _getDatas(){
        
    }
    
    func clickAction(sender:UIButton){
        switch sender{
        case _btn_cancel!:
            self.navigationController?.popViewControllerAnimated(true)
        case _btn_moreAction!:
            return
        default:
            println(sender)
        }
        
    }
}

