//
//  Manage_new.swift
//  Picturers
//
//  Created by Bob Huang on 15/6/20.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit


class Setting_tags: UIViewController {
    let _gap:CGFloat=15
    var _setuped:Bool=false
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    var _btn_save:UIButton?
    var _title_label:UILabel?
    var _delegate:SettingDelegate?
    
    var _selectedId:Int=0
    
    override func viewDidLoad() {
        setup()
        refreshView()
    }
    func setup(){
        if _setuped{
            return
        }
        self.view.backgroundColor=UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        
        _topBar=UIView(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: 62))
        _topBar?.backgroundColor=UIColor.blackColor()
        _btn_cancel=UIButton(frame:CGRect(x: 5, y: 5, width: 40, height: 62))
        _btn_cancel?.setTitle("取消", forState: UIControlState.Normal)
        _btn_cancel?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_save=UIButton(frame:CGRect(x: self.view.frame.width-50, y: 5, width: 40, height: 62))
        _btn_save?.setTitle("完成", forState: UIControlState.Normal)
        _btn_save?.setTitleColor(UIColor(red: 255/255, green: 221/255, blue: 23/255, alpha: 1), forState: UIControlState.Normal)
        _btn_save?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        _title_label=UILabel(frame:CGRect(x: 50, y: 5, width: self.view.frame.width-100, height: 62))
        _title_label?.textColor=UIColor.whiteColor()
        _title_label?.textAlignment=NSTextAlignment.Center
        _title_label?.text="标签"
        
       
        self.view.addSubview(_topBar!)
        
        _topBar?.addSubview(_btn_cancel!)
        _topBar?.addSubview(_btn_save!)
        _topBar?.addSubview(_title_label!)
        
        
        _setuped=true
    }
    
    
    
    //----设置位置
    func refreshView(){
       
    }
    
    func clickAction(sender:UIButton){
        switch sender{
        case _btn_cancel!:
            self.navigationController?.popViewControllerAnimated(true)
            _delegate?.settingCanceled()
        case _btn_save!:
            var _dict:NSMutableDictionary=NSMutableDictionary()
            _delegate?.settingSaved(self, settings: _dict)
            self.navigationController?.popViewControllerAnimated(true)
        default:
            println(sender)
        }
        
    }
}

