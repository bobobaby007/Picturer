//
//  Manage_new.swift
//  Picturers
//
//  Created by Bob Huang on 15/6/20.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit

class Manage_new: UIViewController {
    let _gap:CGFloat=20
    var _setuped:Bool=false
    
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    
    var _tableView:UITableView?
    var _delegate:UITableViewDelegate?
    var _source:UITableViewDataSource?
    
    var _scrollView:UIScrollView?
    var _imagesBox:UIView?
    var _addButton:UIButton?
    
    
    
    
    
    override func viewDidLoad() {
        setup()
        refreshView()
    }
    
    
    func setup(){
        if _setuped{
            return
        }
        
        _scrollView=UIScrollView()
        _scrollView?.bounces=false
        //_scrollView?.scrollEnabled=true
        
        _topBar=UIView(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: 62))
        _topBar?.backgroundColor=UIColor.blackColor()
        _btn_cancel=UIButton(frame:CGRect(x: 5, y: 5, width: 40, height: 62))
        _btn_cancel?.setTitle("取消", forState: UIControlState.Normal)
        _btn_cancel?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        _tableView=UITableView()
        
        
        
        _imagesBox=UIView()
        _imagesBox?.backgroundColor=UIColor.whiteColor()
        _addButton=UIButton(frame: CGRect(x: _gap, y: _gap, width: self.view.frame.width-2*_gap, height: 150))
        _addButton?.backgroundColor=UIColor(red: 255/255, green: 221/255, blue: 23/255, alpha: 1)
        _addButton?.addTarget(self, action: Selector("clickAction:"), forControlEvents: UIControlEvents.TouchUpInside)
       
        _addButton?.setImage(UIImage(named: "addIcon.png"), forState: UIControlState.Normal)
        
       
        _imagesBox?.addSubview(_addButton!)
        _scrollView?.addSubview(_imagesBox!)
        _scrollView?.addSubview(_tableView!)
        
        _scrollView?.backgroundColor=UIColor.clearColor()
        
        self.view.addSubview(_scrollView!)
        self.view.addSubview(_topBar!)
        _topBar?.addSubview(_btn_cancel!)
        
        self.view.backgroundColor=UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        
        _setuped=true
    }
    
    
    
    
    
    func refreshView(){
        _imagesBox?.frame=CGRect(x: 0, y: 0, width: self.view.frame.width, height: 150+2*_gap)
        _scrollView?.frame=CGRect(x: 0, y: 43, width: self.view.frame.width, height: self.view.frame.height-62)
        
        _scrollView?.contentSize=CGSize(width: self.view.frame.width, height: 3000)
        
        _tableView?.frame = CGRect(x: 0, y: 270, width: self.view.frame.width, height: self.view.frame.height)
    }
    
    func clickAction(sender:UIButton){
        switch sender{
        case _btn_cancel!:
            self.navigationController?.popViewControllerAnimated(true)
        case _addButton!:
            let storyboard:UIStoryboard=UIStoryboard(name: "Main", bundle: nil)
            
            var _controller:Manage_imagePicker?
            
            _controller=storyboard.instantiateViewControllerWithIdentifier("Manage_imagePicker") as? Manage_imagePicker
            //self.view.window!.rootViewController!.presentViewController(_controller!, animated: true, completion: nil)
            self.navigationController?.pushViewController(_controller!, animated: true)
        default:
            println(sender)
        }
        
    }
}

