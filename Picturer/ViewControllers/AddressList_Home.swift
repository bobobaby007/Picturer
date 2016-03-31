//
//  Manage_new.swift
//  Picturers
//
//  Created by Bob Huang on 15/6/20.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit


class AddressList_Home: UIViewController,UITabBarControllerDelegate,UITextFieldDelegate {
    let _barH:CGFloat = 64
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    
    
    var _setuped:Bool=false
    
    var _friendsController:AddressList_List?
    var _focusController:AddressList_List?
    var _tab_controller:UITabBarController?
    
    
    weak var _naviDelegate:Navi_Delegate?
    
    let _btnBarH:CGFloat = 42.5
    var _btn_friends:UIButton?
    var _btn_focus:UIButton?
    var _btnLine:UIView?
    var _btnBarV:UIView?
    
    
    var _title_label:UILabel?
    
    
    var _searchBarHH:CGFloat = 43
    var _searchBarH:UIView = UIView()
    var _searchT:UITextField = UITextField()
    
    
    override func viewDidLoad() {
        setup()
    }
    func setup(){
        if _setuped{
            return
        }
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor=Config._color_social_gray_bg
        
        _topBar=UIView(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: _barH))
        _topBar?.backgroundColor=Config._color_black_bar
        
        
        _btn_cancel=UIButton(frame:CGRect(x: 0, y: 20, width: 44, height: 44))
        _btn_cancel?.setImage(UIImage(named: "back_icon.png"), forState: UIControlState.Normal)
        _btn_cancel?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        _friendsController = AddressList_List()
        _friendsController?._type = AddressList_List._Type_Friends
        
        
        _focusController = AddressList_List()
        _focusController?._type = AddressList_List._Type_Focus
        
        
        _tab_controller = UITabBarController()
        _tab_controller?.automaticallyAdjustsScrollViewInsets = false
        _tab_controller?.view.backgroundColor = UIColor.clearColor()
        
        
        _tab_controller!.viewControllers = [_friendsController!,_focusController!]
        
        _tab_controller!.delegate = self
        _tab_controller?.tabBar.hidden = true
        
        _tab_controller?.view.frame = CGRect(x: 0, y: _barH+_btnBarH, width: self.view.frame.width, height: self.view.frame.height-_barH-_btnBarH)
        
        self.addChildViewController(_tab_controller!)
        
        self.view.addSubview(_tab_controller!.view)
        
        
        
        
        
        /*
        //-----搜索栏
        let _gap:CGFloat = Config._gap
        let _searchLableV:UIView = UIView(frame: CGRect(x: 44, y: 27, width: self.view.frame.width-56, height: _searchBarHH-14))
        _searchLableV.backgroundColor = UIColor(white: 1, alpha: 0.2)
        _searchLableV.layer.cornerRadius=5
        
        let _icon:UIImageView = UIImageView(image: UIImage(named: "search_icon.png"))
        _icon.frame=CGRect(x: _gap, y: 10, width: 13, height: 13)
        
        _searchT.frame = CGRect(x: _gap+13+5, y: 20, width: self.view.frame.width-2*_gap-_gap, height: _searchBarHH-14)
        _searchT.placeholder = "通讯录"
        _searchT.font = UIFont.systemFontOfSize(13)
        _searchT.delegate = self
        _searchT.returnKeyType = UIReturnKeyType.Search
        
        
        _searchLableV.addSubview(_icon)
        _searchLableV.addSubview(_searchT)
        
        
        _topBar!.addSubview(_searchLableV)
        
        
        //
        */
        
        _btn_friends = UIButton()
        _btn_friends?.setTitle("朋友", forState: UIControlState.Normal)
        
        
        _btn_friends?.titleLabel?.font = Config._font_social_button_3
        _btn_friends?.setTitleColor(Config._color_social_gray, forState: UIControlState.Normal)
        
        _btn_friends?.frame=CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: _btnBarH-2)
        _btn_friends?.addTarget(self, action: Selector("clickAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_focus = UIButton()
        _btn_focus?.setTitle("妙人", forState: UIControlState.Normal)
        _btn_focus?.titleLabel?.font = Config._font_social_button_3
        _btn_focus?.setTitleColor(Config._color_social_gray, forState: UIControlState.Normal)
        _btn_focus?.frame=CGRect(x: self.view.frame.width/2, y: 0, width: self.view.frame.width/2, height: _btnBarH-2)
        _btn_focus?.addTarget(self, action: Selector("clickAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        _btnBarV = UIView(frame: CGRect(x: 0, y: _barH, width: self.view.frame.width, height: _btnBarH))
        
        let _line:UIView = UIView(frame: CGRect(x: 0, y: _btnBarH-2, width: self.view.frame.width, height: 2))
        _line.backgroundColor = Config._color_social_gray_line
        
        
        _btnLine = UIView(frame: CGRect(x: 0, y: _btnBarH-2, width: self.view.frame.width/2, height: 2))
        _btnBarV?.backgroundColor = UIColor.whiteColor()
        
        _btnBarV?.addSubview(_line)
        _btnBarV?.addSubview(_btnLine!)
        
        _btnBarV?.addSubview(_btn_friends!)
        _btnBarV?.addSubview(_btn_focus!)
        
        self.view.addSubview(_btnBarV!)
        
        
        
        
        _title_label=UILabel(frame:CGRect(x: 50, y: 12, width: self.view.frame.width-100, height: 60))
        _title_label?.textColor=UIColor.whiteColor()
        _title_label?.font = Config._font_topbarTitle
        _title_label?.textAlignment=NSTextAlignment.Center
        _title_label?.text="通讯录"
        
        _topBar?.addSubview(_title_label!)
        _topBar?.addSubview(_btn_cancel!)
        self.view.addSubview(_topBar!)
        
        _switchTo(1)
        
        
        
        _setuped=true
    }
    
    //---
    
    func textFieldDidBeginEditing(textField: UITextField) {
        _switchTo(2)
    }
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //_showSearchResult(textField.text!)
        
        return true
    }
    //--
    
    
    
    func _switchTo(__num:Int){
        switch __num{
        case 1:
            _tab_controller?.selectedIndex = 0
            
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self._btnLine?.frame.origin.x = 0
                self._btnLine?.backgroundColor = Config._color_social_orange
                
            })
            
            
            return
        case 2:
            _tab_controller?.selectedIndex = 1
            
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self._btnLine!.frame.origin.x = self.view.frame.width/2
                self._btnLine?.backgroundColor = Config._color_social_purple
            })
            
            return
        default:
            return
        }
    }
    
    func tabBarController(tabBarController: UITabBarController, animationControllerForTransitionFromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let _tran:MyTransitioningObject = MyTransitioningObject()
        if fromVC == _friendsController{
            _tran._isLeftToRight=false
        }else{
            _tran._isLeftToRight=true
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
            
        case _btn_friends!:
            _switchTo(1)
            return
        case _btn_focus!:
            _switchTo(2)
            return
        default:
            return
        }
        
    }
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle=UIStatusBarStyle.LightContent
    }
}

