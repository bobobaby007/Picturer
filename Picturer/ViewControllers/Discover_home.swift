//
//  Manage_new.swift
//  Picturers
//
//  Created by Bob Huang on 15/6/20.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit


class Discover_home: UIViewController,UITabBarControllerDelegate,UITextFieldDelegate {
    let _barH:CGFloat = 64
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    
    
    var _setuped:Bool=false
    
    var _referenceController:Discover_reference?
    var _searchController:Discover_search?
    var _tab_controller:MyTabBarController?
    
    
    var _naviDelegate:Navi_Delegate?
    
    
    var _searchBarH:CGFloat = 43
    var _searchBar:UIView = UIView()
    var _searchT:UITextField = UITextField()
    
    var _messageTap:UITapGestureRecognizer?
    var _messageImg:PicView?
    
    var _btn_close:UIButton?
    override func viewDidLoad() {
        setup()
    }
    func setup(){
        if _setuped{
            return
        }
        self.view.backgroundColor=UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        
        _topBar=UIView(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: _barH))
        _topBar?.backgroundColor=Config._color_black_bar
        
        //---消息提醒----
        
        _messageImg = PicView(frame: CGRect(x: self.view.frame.width - 25 - Config._gap, y: 30, width: 25, height: 25))
        _messageImg?._imgView?.contentMode = UIViewContentMode.ScaleAspectFill
        _messageImg?.minimumZoomScale=1
        
        _messageImg?.maximumZoomScale=1
        _messageImg?._imgView?.layer.masksToBounds = true
        _messageImg?._imgView?.layer.cornerRadius = 12.5
        
        
        _messageTap = UITapGestureRecognizer(target: self, action: Selector("messageTapHander:"))
        _messageImg?.addGestureRecognizer(_messageTap!)
        
        _topBar?.addSubview(_messageImg!)
        
        
        _btn_cancel=UIButton(frame:CGRect(x: 0, y: 20, width: 44, height: 44))
        _btn_cancel?.setImage(UIImage(named: "back_icon.png"), forState: UIControlState.Normal)
        _btn_cancel?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        _btn_close=UIButton(frame: CGRect(x: self.view.frame.width - 25 - Config._gap, y: 29, width: 24, height: 24))
        _btn_close?.setImage(UIImage(named: "icon_close.png"), forState: UIControlState.Normal)
        _btn_close?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        _topBar?.addSubview(_btn_close!)
        
        _referenceController = Discover_reference()
        _searchController = Discover_search()
        
        
        _tab_controller = MyTabBarController()
        
        
        
        _tab_controller!.viewControllers = [_referenceController!,_searchController!]
        
        _tab_controller!.delegate = self
        _tab_controller?.tabBar.hidden = true
        
        
        self.view.addSubview(_tab_controller!.view)
        
        
       
        
        let _searchLableV:UIView = UIView(frame: CGRect(x: 44, y: 27, width: self.view.frame.width-100, height: _searchBarH-14))
        _searchLableV.backgroundColor = UIColor(white: 1, alpha: 0.2)
        _searchLableV.layer.cornerRadius=5
        
        let _icon:UIImageView = UIImageView(image: UIImage(named: "search_icon.png"))
        _icon.frame=CGRect(x: 9, y: 6, width: 14.5, height: 14.5)
        
        _searchT.frame = CGRect(x: 9+14.5+5, y: 0, width: _searchLableV.frame.width-9-14.5-5-5, height: _searchBarH-14)
        
        
        
        _searchT.attributedPlaceholder =
            NSAttributedString(string: "搜索", attributes: [NSForegroundColorAttributeName : UIColor(white: 1, alpha: 0.7)])
        _searchT.textColor = UIColor.whiteColor()
        _searchT.font = UIFont.systemFontOfSize(13)
        _searchT.delegate = self
        _searchT.returnKeyType = UIReturnKeyType.Search
        _searchT.addTarget(self, action: "textHander:", forControlEvents: UIControlEvents.EditingChanged)
        
        
        _searchLableV.addSubview(_icon)
        _searchLableV.addSubview(_searchT)
        
        
        _topBar!.addSubview(_searchLableV)
        
        /*---
        
        
        
        _tab_reference = UIButton()
        _tab_reference?.setTitle("发现", forState: UIControlState.Normal)
        _tab_reference?.titleLabel?.font = UIFont.systemFontOfSize(14)
        _tab_reference?.frame=CGRect(x: 0, y: 0, width: 70, height: 29)
        _tab_reference?.addTarget(self, action: Selector("clickAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        _tab_search = UIButton()
        _tab_search?.setTitle("搜索", forState: UIControlState.Normal)
        _tab_search?.titleLabel?.font = UIFont.systemFontOfSize(14)
        _tab_search?.frame=CGRect(x: 70, y: 0, width: 70, height: 29)
        _tab_search?.addTarget(self, action: Selector("clickAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        _tabBtnView = UIView(frame: CGRect(x: 0.5*self.view.frame.width-70, y: 28, width: 140, height: 29))
        _tabBtnView?.layer.masksToBounds = true
        _tabBtnView?.layer.cornerRadius = 5
        _tabBtnView?.layer.borderWidth = 1
        _tabBtnView?.layer.borderColor = UIColor(red: 242/255, green: 206/255, blue: 53/255, alpha: 1).CGColor
        _tabBtnView?.clipsToBounds = true
        
        _tabBtnView?.addSubview(_tab_reference!)
        _tabBtnView?.addSubview(_tab_search!)
        
        */
        self.view.addSubview(_topBar!)
        
        _topBar?.addSubview(_btn_cancel!)
        
        
        _switchTo(1)
        
        _setuped=true
    }
    
    
    
    //-----文字侦听
    
    func textHander(__text:UITextField){
        print(_searchT.text)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        _switchTo(2)
        _searchController!._showSearchReference()
        
//        _switchTo(2)
//        if _searchT.text == ""{
//            _switchTo(1)
//        }else{
//            _switchTo(2)
//        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
       
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //_showSearchResult(textField.text!)
        _searchController!._showSearchResult(textField.text!)
        _searchT.resignFirstResponder()
        return true
    }
    //--
    func _switchTo(__num:Int){
        switch __num{
        case 1:
            _tab_controller?.selectedIndex = 0
            _btn_close?.hidden = true
            _searchT.text = ""
            _searchT.resignFirstResponder()
            return
        case 2:
            _tab_controller?.selectedIndex = 1
            _btn_close?.hidden = false
            return
        default:
            return
        }
    }
    
    func tabBarController(tabBarController: UITabBarController, animationControllerForTransitionFromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let _tran:MyTransitioningObject = MyTransitioningObject()
        if fromVC == _referenceController{
            _tran._isLeftToRight=true
        }else{
            _tran._isLeftToRight=false
        }
        
        return _tran
    }
    
    
    func clickAction(sender:UIButton){
        switch sender{
        case _btn_cancel!:
            if _naviDelegate != nil{
                _naviDelegate?._cancel()
            }
            self.navigationController?.popViewControllerAnimated(true)
        
        case _btn_close!:
            _switchTo(1)
            return
//        case _tab_search!:
//            _switchTo(2)
//            return
        default:
            return
        }
        
    }
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle=UIStatusBarStyle.LightContent
    }
}



class MyTabBarController:UITabBarController {
   
}

