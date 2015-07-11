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


protocol Manage_pic_delegate:NSObjectProtocol{
    func canceled()
    func delete(picIndex:Int)
    func setCover(picIndex:Int)
    
}

class Manage_pic: UIViewController,UIScrollViewDelegate{
    
    @IBOutlet weak var _btn_back:UIButton?
    @IBOutlet weak var _title:UIButton?
    
    @IBOutlet weak var _topView:UIView?
    
    
    
    var _currentIndex:Int?
    
    var _picsArray:NSMutableArray?
    
    var _delegate:Manage_pic_delegate?
    var _scrollView:UIScrollView?
    
    var _viewType:String="view"//---view 浏览编辑，标题显示张数 //---select 选择 //--edit 编辑
    
    var _action:String?
    
    
    var _showingBar:Bool=true{
        didSet{
            UIView.beginAnimations("topA", context: nil)
            UIView.setAnimationDuration(0.2)
            if (_showingBar == true){
                _topView?.frame=CGRect(x: 0, y: 0, width: _topView!.frame.width, height: _topView!.frame.height)
                
                UIApplication.sharedApplication().statusBarHidden=false
            }else{
                _topView?.frame=CGRect(x: 0, y: -62, width: _topView!.frame.width, height: _topView!.frame.height)
                UIApplication.sharedApplication().statusBarHidden=true
            }
            
            UIView.commitAnimations()
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    @IBAction func clickAction(_btn:UIButton)->Void{
        switch _btn{
        case _btn_back!:
            _delegate?.canceled()
            self.navigationController?.popViewControllerAnimated(true)
        default:
            println("")
        }
    }    
    
    func _showIndexAtPics(__index:Int,__array:NSArray){
        _picsArray=NSMutableArray(array: __array)
        _currentIndex=__index
        
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
        
        
        var _tapG:UITapGestureRecognizer=UITapGestureRecognizer(target: self, action: Selector("tapHander:"))
        _scrollView?.addGestureRecognizer(_tapG)
        
        
        _moveToPicByIndex(_currentIndex!)
        
    }
    
    func tapHander(tap:UITapGestureRecognizer){
        _showingBar = !_showingBar
    }
    
    func _moveToPicByIndex(__index:Int){
        _currentIndex=__index
        if (_currentIndex!>_picsArray!.count-1){
            _currentIndex=_picsArray!.count-1
        }
        _viewInAtIndex(__index)
    
        _setTitle(String(_currentIndex!+1)+"/"+String(_picsArray!.count))
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var _p:Int = Int(scrollView.contentOffset.x/scrollView.frame.width)
        
        if _p>_picsArray!.count-2{
            //return
        }else{
            _viewInAtIndex(_p+1)
        }
        
        
        if _p<=0{
            //return
        }else{
            _viewInAtIndex(_p-1)
        }
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        var _p:Int = Int(scrollView.contentOffset.x/scrollView.frame.width)
        _moveToPicByIndex(_p)
        
    }
    func _viewInAtIndex(__index:Int){
        var _picV:PicView!
        if (_scrollView?.viewWithTag(100+__index) != nil){
            _picV=_scrollView?.viewWithTag(100+__index) as! PicView
        }else{
            _picV=PicView(frame: CGRect(x: CGFloat(__index)*_scrollView!.frame.width, y: 0, width: _scrollView!.frame.width, height: _scrollView!.frame.height))
            _picV.tag=100+__index
            var _dict:NSDictionary = _picsArray?.objectAtIndex(__index) as! NSDictionary
            _picV._setPic(_dict)
        }
        _scrollView!.addSubview(_picV)
    }
    func _setTitle(__str:String){
        _title?.setTitle(__str, forState: UIControlState.Normal)
    }
    
    
}