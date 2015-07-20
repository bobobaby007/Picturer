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
    
    var _bottomView:UIView?
    
    var _tapG:UITapGestureRecognizer?
    
    var _currentIndex:Int?
    
    var _picsArray:NSMutableArray?
    var _pic:NSMutableDictionary?
    
    var _delegate:Manage_pic_delegate?
    var _scrollView:UIScrollView!
    
    var _viewType:String="view"//---view 浏览编辑，标题显示张数 //---select 选择 //--edit 编辑
    
    
    var _albumIndex:Int?
    
    var _action:String?
    
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
                _topView?.frame=CGRect(x: 0, y: 0, width: _topView!.frame.width, height: _topView!.frame.height)
                _desView?.frame=CGRect(x: 0, y: self.view.frame.height-_desH, width: self.view.frame.width, height: _desH)
                UIApplication.sharedApplication().statusBarHidden=false
            }else{
                _topView?.frame=CGRect(x: 0, y: -62, width: _topView!.frame.width, height: _topView!.frame.height)
                _desView?.frame=CGRect(x: 0, y: self.view.frame.height+0, width: self.view.frame.width, height: _desH)
                UIApplication.sharedApplication().statusBarHidden=true
            }
            
            UIView.commitAnimations()
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _desView = UIView(frame: CGRect(x: 0, y: self.view.frame.height-_desH, width: self.view.frame.width, height: _desH))
        _desView?.backgroundColor=UIColor(white: 0, alpha: 0.8)
        
        _desText=UITextView(frame: CGRect(x: 5, y: 5, width: self.view.frame.width-10, height: 0))
        _desText?.backgroundColor=UIColor.clearColor()
        _desText?.textColor=UIColor.whiteColor()
        
        _desView?.addSubview(_desText!)
        
        self.view.addSubview(_desView!)
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
        var _dict:NSDictionary = NSDictionary(object: _getPicAtIndex(_currentIndex!), forKey: "cover") as NSDictionary
        MainAction._changeAlbumAtIndex(_albumIndex!, dict: _dict)
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
    
        _setTitle(String(_currentIndex!+1)+"/"+String(_picsArray!.count))
        
        
        
        
            if _pic!.objectForKey("description") != nil{
                //println(_pic)
                _setDes((_pic!.objectForKey("description") as! String))
            }else{
                _setDes("")
            }
        
//        let _shows:Bool=self._showingBar
//        self._showingBar=_shows
        
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
        _picV._setPic(_getPicAtIndex(__index))
        _scrollView!.addSubview(_picV)
    }
    func _setTitle(__str:String){
        _title?.setTitle(__str, forState: UIControlState.Normal)
    }
    //----显示描述
    func _setDes(__str:String){
        
            _desText?.text=__str
            if __str.lengthOfBytesUsingEncoding(NSUnicodeStringEncoding)<=0{
                _desH = 0
                _desText?.frame = CGRect(x: 5, y: 5, width: self.view.frame.width-10, height: 0)
            }else{
                
                _desH = _desText!.contentSize.height+10
                _desText?.frame=CGRect(x: 5, y: 5, width: self.view.frame.width-10, height: _desText!.contentSize.height)
                
            }
        
        
            //_desView?.frame = CGRect(x: 0, y: self.view.frame.height-_desH, width: self.view.frame.width, height: _desH)
        
            //println(_desH)
        
    }
    
}