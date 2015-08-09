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
    func _deletePic(picIndex:Int)
    func _setCover(picIndex:Int)
    
}

class Manage_pic: UIViewController,UIScrollViewDelegate,Manage_description_delegate{
    let _barH:CGFloat = 64
    let _gap:CGFloat=15
    let _space:CGFloat=5
    
    var _albumIndex:Int?
    
    var _action:String?
    
    var _setuped:Bool=false
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    var _btn_moreAction:UIButton?
    var _titleT:UITextView?
    
    var _dataArray:NSMutableArray?=NSMutableArray()
    
    var _tapG:UITapGestureRecognizer?
    
    var _currentIndex:Int? = 0
    
    var _picsArray:NSMutableArray?
    var _pic:NSMutableDictionary?
    
    var _delegate:Manage_pic_delegate?
    var _scrollView:UIScrollView!
    
    var _viewType:String="view"//---view 浏览编辑，标题显示张数 //---select 选择 //--edit 编辑
    
    var _desView:UIView?
    var _desText:UITextView?
    var _desH:CGFloat=0//-----描述面板高度
    
    var _isScrolling:Bool = false
    
    var _range:Int = 0
    
    
    var _showType:String = "pic" // collection
    
    
    var _like_iconT:UILabel = UILabel()
    var _comment_iconT:UILabel = UILabel()
    var _like_numT:UILabel = UILabel()
    var _comment_numT:UILabel = UILabel()
    
    var _currentPic:PicView?
    
    var _frameH:CGFloat?
    
    var _showingBar:Bool=true{
        
        didSet{
            UIView.beginAnimations("topA", context: nil)
            UIView.setAnimationDuration(0.2)
            if (_showingBar == true){
                _topBar?.frame=CGRect(x: 0, y: 0, width: _topBar!.frame.width, height: _topBar!.frame.height)
                _desView?.frame=CGRect(x: 0, y: self.view.frame.height-_desH, width: self.view.frame.width, height: _desH)
                UIApplication.sharedApplication().statusBarHidden=false
            }else{
                _topBar?.frame=CGRect(x: 0, y: -_barH, width: _topBar!.frame.width, height: _topBar!.frame.height)
                _desView?.frame=CGRect(x: 0, y: self.view.frame.height+0, width: self.view.frame.width, height: _desH)
                UIApplication.sharedApplication().statusBarHidden=true
            }
            
            UIView.commitAnimations()
        }
    }
    
    var _bottomBar:UIView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        _getDatas()
    }
    
    func setup(){
        if _setuped{
            return
        }
        self.view.backgroundColor=UIColor.blackColor()
        
        _desView = UIView(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: _desH))
        _desView?.backgroundColor=UIColor(white: 0, alpha: 0.8)
        
        _desText=UITextView(frame: CGRect(x: 5, y: 5, width: self.view.frame.width-10, height: 0))
        _desText?.backgroundColor=UIColor.clearColor()
        _desText?.textColor=UIColor.whiteColor()
        
        _desView?.addSubview(_desText!)
        self.view.addSubview(_desView!)
        
        
        _topBar=UIView(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: _barH))
        _topBar?.backgroundColor=UIColor(white: 0.1, alpha: 0.98)
        
        _btn_cancel=UIButton(frame:CGRect(x: 11, y: _barH-21-11, width: 51, height: 21))
        _btn_cancel?.setImage(UIImage(named: "back.png"), forState: UIControlState.Normal)
        //_btn_cancel!.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        _btn_cancel?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_moreAction=UIButton(frame:CGRect(x: self.view.frame.width-50, y: _barH-44, width: 50, height: 44))
        _btn_moreAction?.setImage(UIImage(named: "edit.png"), forState: UIControlState.Normal)
        _btn_moreAction?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        
        _topBar=UIView(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: _barH))
        _topBar?.backgroundColor=UIColor.blackColor()
        
        _titleT=UITextView(frame:CGRect(x: 50, y: 10, width: self.view.frame.width-100, height: 56))
        _titleT?.editable = false
        _titleT?.font = UIFont.boldSystemFontOfSize(16)
        _titleT?.backgroundColor = UIColor.clearColor()
        _titleT?.textColor=UIColor.whiteColor()
        _titleT?.scrollEnabled = false
        _titleT?.textAlignment=NSTextAlignment.Center
        _titleT?.text="6月2日\n2/28"
        
        
        _bottomBar=UIView(frame:CGRect(x: 0, y: self.view.frame.height-58, width: self.view.frame.width, height: 58))
        _bottomBar?.backgroundColor=UIColor(white: 0.2, alpha: 0.6)
        
        
        
        
        // _like_iconT.frame = CGRect(x: self.view.frame.width-20, y: <#CGFloat#>, width: <#CGFloat#>, height: <#CGFloat#>)
      
        
        
        // self.view.addSubview(_imagesCollection!)
        
        self.view.addSubview(_topBar!)
        self.view.addSubview(_bottomBar!)
        
        _topBar?.addSubview(_btn_cancel!)
        _topBar?.addSubview(_btn_moreAction!)
        _topBar?.addSubview(_titleT!)
        
        
        
        _scrollView=UIScrollView()
        _scrollView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        _scrollView.clipsToBounds=false
        self.view.insertSubview(_scrollView!, atIndex: 0)
        _scrollView!.bounces=false
        //_scrollView!.bouncesZoom=true
        _scrollView!.maximumZoomScale=1
        _scrollView!.minimumZoomScale = 1
        _scrollView!.showsVerticalScrollIndicator=false
        _scrollView!.showsHorizontalScrollIndicator=false
        _scrollView!.pagingEnabled=true
        
        _scrollView!.delegate=self
        
        _frameH = self.view.bounds.height - 60
        
        //println(_frameH!)
        
        _scrollView!.contentSize=CGSize(width: CGFloat(_picsArray!.count)*self.view.frame.width, height:_frameH! )
        _scrollView?.contentOffset.x = CGFloat(_currentIndex!)*_scrollView!.frame.width
        
        
        _tapG=UITapGestureRecognizer(target: self, action: Selector("tapHander:"))
        //_scrollView?.addGestureRecognizer(_tapG!)
        
        _moveToPicByIndex(_currentIndex!)
        
        _setuped=true
    }
    
    //外部调用直接到达指定图片
    func _showIndexAtPics(__index:Int,__array:NSArray){
        _picsArray=NSMutableArray(array: __array)
        
        _currentIndex=__index
        
        if _currentIndex > _picsArray!.count-1{
            _currentIndex = _picsArray!.count-1
        }
        
        if _currentIndex < 0{
            _currentIndex = 0
        }
    }
    
    func _clear(){
        let _n = _scrollView.subviews.count
        
        for view in _scrollView.subviews{
            view.removeFromSuperview()
            println("remove")
        }
       // _scrollView?.removeFromSuperview()
    }
    
    func tapHander(tap:UITapGestureRecognizer){
        _showingBar = !_showingBar
    }
    
    func _moveToPicByIndex(__index:Int){
        _currentIndex=__index
        if (_currentIndex!>_picsArray!.count-1){
            _currentIndex=_picsArray!.count-1
        }
        
        _titleT?.text = "5月12日 12:33 \n"+String(_currentIndex!+1)+"/"+String(_picsArray!.count)
        
        _pic = NSMutableDictionary(dictionary: (_getPicAtIndex(_currentIndex!)))
        
        _viewInAtIndex(__index)
        
        _viewInAtIndex(__index+1)
        _viewInAtIndex(__index-1)
        
        
    }
    
    //---正在挪动的时候
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if scrollView == _scrollView{
            _showingBar = false
            return
        }
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
    }
    //---停止挪动
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView == _scrollView{
            _isScrolling=false
            
            
            var _p:Int = Int(scrollView.contentOffset.x/scrollView.frame.width)
            
            _moveToPicByIndex(_p)
            
            //_scrollView?.addGestureRecognizer(_tapG!)
            return
        }
        
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
            _picV=PicView(frame: CGRect(x: CGFloat(__index)*_scrollView!.frame.width, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
            _picV.tag=100+__index
        }
        _picV._setPic(_getPicAtIndex(__index),__block: { (__dict) -> Void in
            
        })
        if __index == _currentIndex{
            _picV.addGestureRecognizer(_tapG!)
            _currentPic = _picV
        }
        _scrollView!.addSubview(_picV)
    }
    
    
    func _getDatas(){
        
    }
    
    func clickAction(sender:UIButton){
        switch sender{
        case _btn_cancel!:
            _delegate?.canceled()
            self.navigationController?.popViewControllerAnimated(true)
        case _btn_moreAction!:
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
            return
        default:
            println(sender)
        }
        
    }
    //-----弹出选择按钮
    func openActions()->Void{
        
        let menu=UIAlertController()

        let action1 = UIAlertAction(title: "图片描述", style: UIAlertActionStyle.Default, handler: changeDes)
        let action2 = UIAlertAction(title: "设为封面", style: UIAlertActionStyle.Default, handler: setToCover)
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
        
    }
    //-----设为封面
    func setToCover(action:UIAlertAction!){
        _delegate?._setCover(_realIndex(_currentIndex!))
//        
//        var _dict:NSDictionary = NSDictionary(object: _getPicAtIndex(_currentIndex!), forKey: "cover") as NSDictionary
//        MainAction._changeAlbumAtIndex(_albumIndex!, dict: _dict)
        
        var _alert:UIAlertView = UIAlertView(title: "设置封面成功", message: nil, delegate: nil, cancelButtonTitle: "确认")
        _alert.show()
    }
    //---打开描述编辑
    func changeDes(action:UIAlertAction!){
        var _controller:Manage_description=Manage_description()
        
        
        
        if _pic!.objectForKey("description") != nil{
            _controller._desPlaceHold = _pic!.objectForKey("description") as? String
        }
        
        
        _controller._delegate=self
        self.navigationController?.pushViewController(_controller, animated: true)
        
    }
    
    //-----根据排列顺序调出图片
    func _getPicAtIndex(__index:Int)->NSDictionary{
        var _dict:NSDictionary
        
        if _range == 0{
            _dict = _picsArray?.objectAtIndex(__index) as! NSDictionary
        }else{
            _dict = _picsArray?.objectAtIndex(_picsArray!.count-__index-1) as! NSDictionary
        }
        return _dict
    }
    func _realIndex(__index:Int)->Int{
        if _range == 0{
            return __index
        }else{
            return _picsArray!.count-__index-1
        }
    }
    //---设置描述代理
    func canceld() {
        
    }
    func saved(dict: NSDictionary) {
        
        var _array:NSMutableArray = NSMutableArray(array: _picsArray!)
        var _picDict:NSMutableDictionary = NSMutableDictionary(dictionary: _array.objectAtIndex(_currentIndex!) as! NSDictionary)
        
        if _albumIndex != nil{
            MainAction._changePicAtAlbum(_currentIndex!, albumIndex: _albumIndex!, dict: dict)
            _picDict.setValue(dict.objectForKey("description"), forKey: "description")
        }
        
        // _array.removeObject(_pic)
        
        _array[_currentIndex!] = _picDict
        
        _picsArray = _array
        
        _clear()
        
        _showIndexAtPics(_currentIndex!,__array: _array)
        _moveToPicByIndex(_currentIndex!)
    }
    
    override func viewWillDisappear(animated: Bool) {
        //_currentPic?.removeGestureRecognizer(_tapG!)
    }
}
