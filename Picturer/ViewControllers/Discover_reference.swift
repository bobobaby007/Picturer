//
//  Manage_new.swift
//  Picturers
//
//  Created by Bob Huang on 15/6/20.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit


class Discover_search: UIViewController {
    let _gap:CGFloat = 5
    var _barH:CGFloat = 64
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    var _sliderShower:SliderShower?
    
    
    
    var _setuped:Bool=false
    override func viewDidLoad() {
        setup()
    }
    func setup(){
        if _setuped{
            return
        }
        self.view.backgroundColor=UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        
        _topBar=UIView(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: 62))
        _topBar?.backgroundColor=UIColor.blackColor()
        _btn_cancel=UIButton(frame:CGRect(x: 5, y: 5, width: 40, height: 62))
        _btn_cancel?.setTitle("返回", forState: UIControlState.Normal)
        _btn_cancel?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        
        self.view.addSubview(_topBar!)
        
        _topBar?.addSubview(_btn_cancel!)
        
        
        _sliderShower = SliderShower(frame:CGRect(x: 0, y: 62, width: self.view.frame.width, height: 168))
        
        self.view.addSubview(_sliderShower!)
        
        
        
        _getDatas()
        
        _setuped=true
    }
    
    func _getDatas(){
        MainAction._getAdvertisiongs { (array) -> Void in
            _sliderShower?._setup(array)
        }
    }
    
    func clickAction(sender:UIButton){
        switch sender{
        case _btn_cancel!:
            self.navigationController?.popViewControllerAnimated(true)
        default:
            return
        }
        
    }
    
}


