//
//  MyAlerter.swift
//  Picturer
//
//  Created by Bob Huang on 15/8/19.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit


protocol ShareAlert_delegate:NSObjectProtocol{
    func _myAlerterClickAtMenuId(__id:Int)
    func _myAlerterStartToClose()
    func _myAlerterDidClose()
    func _myAlerterDidShow()
}

class ShareAlert: UIViewController {
    var _gap:CGFloat = 53
    var setuped:Bool = false
    var _menus:NSArray?
    var _container:UIView?
    var _bottomHeight:CGFloat = 57
    var _topToY:CGFloat = 0
    var _delegate:ShareAlert_delegate?
    var _bg:UIView?
    var _tap:UITapGestureRecognizer?
    var _isOpened:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup(){
        if setuped{
            return
        }
        
        _container = UIView()
        _container!.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 271)
        
        
        _tap = UITapGestureRecognizer(target: self, action: "tapHander:")
        
        _bg = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        _bg!.backgroundColor = UIColor(white: 0, alpha: 0.4)
        _bg?.alpha = 0
        _bg?.hidden = true
        
        _topToY = self.view.frame.height - 271 - _bottomHeight
        
        let _imageV:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 271))
        _imageV.backgroundColor = UIColor.whiteColor()
        _imageV.contentMode = UIViewContentMode.ScaleAspectFit
        _imageV.image = UIImage(named: "shareIcons.png")
        
        
        let _line1:UIView = UIView(frame: CGRect(x: 0, y: 271/2, width: self.view.frame.width, height: 0.5))
        _line1.backgroundColor = UIColor(white: 0.8, alpha: 1)
        let _line2:UIView = UIView(frame: CGRect(x: self.view.frame.width/2, y: 0, width: 0.5, height: 271))
        _line2.backgroundColor = UIColor(white: 0.8, alpha: 1)
        
        _container?.addSubview(_imageV)
        _container?.addSubview(_line1)
        _container?.addSubview(_line2)
        
        
        self.view.addSubview(_bg!)
        
        
        
        
        self.view.addSubview(_container!)
        
        setuped=true
    }
    
    
    
    
    func tapHander(__tap:UITapGestureRecognizer){
        _close()
    }
    func _buttonHander(__sender:UIButton){
        _close()
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
                self.view.addGestureRecognizer(self._tap!)
                self._delegate?._myAlerterDidShow()
        }
    }
    func _close(){
        _delegate?._myAlerterStartToClose()
        _isOpened = false
        self.view.removeGestureRecognizer(self._tap!)
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self._bg?.alpha = 0
            self._container?.frame.origin = CGPoint(x: 0, y: self.view.frame.height)
            }) { (stop) -> Void in
                
                self._bg?.hidden = true
                self._delegate?._myAlerterDidClose()
        }
    }
    
    
}
