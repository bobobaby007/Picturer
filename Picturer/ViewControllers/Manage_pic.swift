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

protocol Manage_pic_delegate:NSObjectProtocol{
    func canceled()
    func delete(picIndex:Int)
    func setCover(picIndex:Int)
    
}

class Manage_pic: UIViewController,UIScrollViewDelegate,Manage_description_delegate{
    
    @IBOutlet weak var _btn_back:UIButton?
    @IBOutlet weak var _btn_edite:UIButton?
    @IBOutlet weak var _title:UIButton?
    
    @IBOutlet weak var _topView:UIView?
    
    
    
    var _currentIndex:Int?
    
    var _picsArray:NSMutableArray?
    var _pic:NSDictionary?
    
    var _delegate:Manage_pic_delegate?
    var _scrollView:UIScrollView!
    
    var _viewType:String="view"//---view 浏览编辑，标题显示张数 //---select 选择 //--edit 编辑
    
    
    var _albumIndex:Int?
    
    var _action:String?
    
    var _desView:UIView?
    var _desLabel:UILabel?
    
    
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
      // _scrollView=UIScrollView(frame: self.view.frame)
        //self.view.insertSubview(_scrollView!, atIndex: 0)
    }
    
    @IBAction func clickAction(_btn:UIButton)->Void{
        switch _btn{
        case _btn_back!:
            _delegate?.canceled()
            self.navigationController?.popViewControllerAnimated(true)
        case _btn_edite!:
            switch _viewType{
                case "view":
                    openActions()
                case "select":
                    openActions()
                case "edit":
                    openActions()
            default:
                println("")
            }
            
            
        default:
            println("")
        }
    }
    //-----弹出选择按钮
    func openActions()->Void{
        
        let menu=UIAlertController()
        
        
        
        let action1 = UIAlertAction(title: "图片描述", style: UIAlertActionStyle.Default, handler: changeDes)
        let action2 = UIAlertAction(title: "设为封面", style: UIAlertActionStyle.Default, handler: actionHander)
        let action3 = UIAlertAction(title: "保存图片", style: UIAlertActionStyle.Default, handler: actionHander)
        let action4 = UIAlertAction(title: "删除", style: UIAlertActionStyle.Default, handler: actionHander)
        let action5 = UIAlertAction(title: "分享", style: UIAlertActionStyle.Default, handler: actionHander)
        let action6 = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        
        menu.addAction(action1)
        menu.addAction(action2)
        menu.addAction(action3)
        menu.addAction(action4)
        menu.addAction(action5)
        menu.addAction(action6)
        self.presentViewController(menu, animated: true, completion: nil)
    }
    

    func actionHander(action:UIAlertAction!){
        println(action)
    }
    //---打开
    func changeDes(action:UIAlertAction!){
        var _controller:Manage_description=Manage_description()
        
        
        
        if _pic!.objectForKey("description") != nil{
            _controller._desPlaceHold = _pic!.objectForKey("description") as? String
        }
        
        
        _controller._delegate=self
        self.navigationController?.pushViewController(_controller, animated: true)
        
    }
    //---设置描述代理
    func canceld() {
        
    }
    func saved(dict: NSDictionary) {
        var _array:NSMutableArray = NSMutableArray(array: _picsArray!)
        var _pic:NSMutableDictionary = _array.objectAtIndex(_currentIndex!) as! NSMutableDictionary
        
        if _albumIndex != nil{
            MainAction._changePicAtAlbum(_currentIndex!, albumIndex: _albumIndex!, dict: dict)
            _pic.setValue(dict.objectForKey("description"), forKey: "description")
        }
        
       // _array.removeObject(_pic)
        //_clear()
        //_showIndexAtPics(_currentIndex!,__array: _array)
        _array[_currentIndex!] = _pic
        
        _picsArray = _array
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
        _pic = _picsArray?.objectAtIndex(_currentIndex!) as? NSDictionary
        
        
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
        
        
        var _tapG:UITapGestureRecognizer=UITapGestureRecognizer(target: self, action: Selector("tapHander:"))
        _scrollView?.addGestureRecognizer(_tapG)
        
        
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
        _viewInAtIndex(__index)
    
        _setTitle(String(_currentIndex!+1)+"/"+String(_picsArray!.count))
        
        
        
    }
    //----显示描述
    func _setDes(__str:String){
        if _albumIndex != nil{
            if _pic!.objectForKey("description") != nil{
                
            }
        }

    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var _p:Int = Int(scrollView.contentOffset.x/scrollView.frame.width)
        
        
        if _p>_picsArray!.count-2{
            return
        }else{
            _viewInAtIndex(_p+1)
        }
        
        
        if _p<=0{
            return
        }else{
            _viewInAtIndex(_p-1)
        }
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        var _p:Int = Int(scrollView.contentOffset.x/scrollView.frame.width)
        if _p>_picsArray!.count-1{
            return
        }
        if _p<0{
            return
        }
        
        _moveToPicByIndex(_p)
        
        
    }
    func _viewInAtIndex(__index:Int){
        var _picV:PicView!
        if (_scrollView?.viewWithTag(100+__index) != nil){
            
            _picV=_scrollView?.viewWithTag(100+__index) as! PicView
            //println(_picV.superview?.isEqual(self.view))
        }else{
            println("init")
            _picV=PicView(frame: CGRect(x: CGFloat(__index)*_scrollView!.frame.width, y: 0, width: _scrollView!.frame.width, height: _scrollView!.frame.height))
            _picV.tag=100+__index
            
        }
        var _dict:NSDictionary = _picsArray?.objectAtIndex(__index) as! NSDictionary
        
        
        _picV._setPic(_dict)
        _scrollView!.addSubview(_picV)
    }
    func _setTitle(__str:String){
        _title?.setTitle(__str, forState: UIControlState.Normal)
    }
    
    
}