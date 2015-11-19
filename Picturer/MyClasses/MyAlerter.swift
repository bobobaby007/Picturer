//
//  MyAlerter.swift
//  Picturer
//
//  Created by Bob Huang on 15/8/19.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit


protocol MyAlerter_delegate:NSObjectProtocol{
    func _myAlerterClickAtMenuId(__id:Int)
    func _myAlerterStartToClose()
    func _myAlerterDidClose()
    func _myAlerterDidShow()
}

class MyAlerter: UIViewController {
    var _gap:CGFloat = 53
    var setuped:Bool = false
    var _menus:NSArray?
    var _container:UIView?
    var _bottomHeight:CGFloat = 57
    var _cancelButtonHeight:CGFloat = 50
    var _topToY:CGFloat = 0
    weak var _delegate:MyAlerter_delegate?
    var _bg:UIView?
    var _tap:UITapGestureRecognizer?
    var _isOpened:Bool = false
    var _canelButton:UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup(){
        if setuped{
            return
        }
        
        _container = UIView()
        
        
        _tap = UITapGestureRecognizer(target: self, action: "tapHander:")
        
        _bg = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        _bg!.backgroundColor = UIColor(white: 0, alpha: 0.4)
        _bg?.alpha = 0
        _bg?.hidden = true
        self.view.addSubview(_bg!)
        self.view.addSubview(_container!)
        
        setuped=true
    }
    func _setMenus(__array:NSArray){
        _menus = __array
        
        if _container ==  nil{
            _container = UIView()
            self.view.addSubview(_container!)
        }
        
        _container!.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: CGFloat(_menus!.count) * _gap+_bottomHeight)
        _container?.backgroundColor = UIColor.lightGrayColor()
        
        for subV in _container!.subviews {
            subV.removeFromSuperview()
        }
        
        
        _topToY = self.view.frame.height  - _container!.frame.height
        
        for i in 0..._menus!.count-1{
            let _v:UIButton = UIButton(frame: CGRect(x: 0, y: CGFloat(i)*_gap, width: self.view.frame.width, height: _gap))
            _v.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            _v.backgroundColor = UIColor.whiteColor()
            _v.titleLabel?.font = UIFont.systemFontOfSize(18)
            _v.setTitle(_menus!.objectAtIndex(i) as? String, forState: UIControlState.Normal)
            _v.tag = 100+i
            _v.addTarget(self, action: "_buttonHander:", forControlEvents: UIControlEvents.TouchUpInside)
            _container?.addSubview(_v)
            if i>0{
                let _line:UIView = UIView(frame: CGRect(x: 0, y: CGFloat(i)*_gap, width: self.view.frame.width, height: 0.5))
                _line.backgroundColor = UIColor(white: 0.8, alpha: 1)
                _container?.addSubview(_line)
            }
        }
        _canelButton = UIButton(frame: CGRect(x: 0, y: _container!.frame.height - _cancelButtonHeight, width: self.view.frame.width, height: _cancelButtonHeight))
        _canelButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        _canelButton!.titleLabel?.font = UIFont.systemFontOfSize(18)
        _canelButton!.backgroundColor = UIColor.blackColor()
        _canelButton!.setTitle("取消", forState: UIControlState.Normal)
        _canelButton!.addTarget(self, action: "_buttonHander:", forControlEvents: UIControlEvents.TouchUpInside)
        _canelButton!.tag = -100
        _container?.addSubview(_canelButton!)
        
    }
    func tapHander(__tap:UITapGestureRecognizer){
        _close()
    }
    func _buttonHander(__sender:UIButton){
        _close()
        if __sender.tag == -100{
            return
        }
        
        _delegate?._myAlerterClickAtMenuId(__sender.tag-100)
    }
    func _show(){
        self._bg?.hidden = false
        self._bg?.alpha = 0
        _isOpened = true
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self._bg?.alpha = 1
            self._container?.frame.origin = CGPoint(x: 0, y: self._topToY)
            }) { (stop) -> Void in
                self._bg!.addGestureRecognizer(self._tap!)
                self._delegate?._myAlerterDidShow()
        }
    }
    func _close(){
        _delegate?._myAlerterStartToClose()
        _isOpened = false
        self._bg!.removeGestureRecognizer(self._tap!)
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self._bg?.alpha = 0
            self._container?.frame.origin = CGPoint(x: 0, y: self.view.frame.height)
        }) { (stop) -> Void in
            
            self._bg?.hidden = true
            self._delegate?._myAlerterDidClose()
            
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
            
        }
    }
    
    
}
