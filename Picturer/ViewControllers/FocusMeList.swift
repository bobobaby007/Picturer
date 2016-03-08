//
//  Manage_new.swift
//  Picturers
//
//  Created by Bob Huang on 15/6/20.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit


class FocusMeList: UIViewController,UITabBarControllerDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,FocusListCellDelegate{
    let _barH:CGFloat = 64
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    
    
    var _setuped:Bool=false
    
    
    var _title_label:UILabel?
    weak var _naviDelegate:Navi_Delegate?
    
    var _tableView:UITableView?
    let _tableCellH:CGFloat=40
    
    var _dataArray:NSArray = []
    var _focusArray:NSMutableArray = []
    
    static let _Type_FocusMe:String = "focusMe"//关注我
    static let _Type_Focus:String = "focus"//---我关注
    
    var _type:String = "friends"
    var _uid:String = ""
    
    
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
        
       
        
        
        
        
        _title_label=UILabel(frame:CGRect(x: 50, y: 12, width: self.view.frame.width-100, height: 60))
        _title_label?.textColor=UIColor.whiteColor()
        _title_label?.font = Config._font_topbarTitle
        _title_label?.textAlignment=NSTextAlignment.Center
        _title_label?.text="被关注"
        
        _topBar?.addSubview(_title_label!)
        _topBar?.addSubview(_btn_cancel!)
        self.view.addSubview(_topBar!)
        
        _tableView=UITableView(frame: CGRect(x: 0,y: _barH,width: self.view.frame.width,height: self.view.frame.height-_barH))
        _tableView?.delegate=self
        _tableView?.dataSource=self
        _tableView?.backgroundColor = UIColor.clearColor()
        _tableView?.registerClass(FocusListCell.self, forCellReuseIdentifier: "FocusListCell")
        //_tableView?.scrollEnabled=false
        _tableView?.separatorColor = Config._color_social_gray_line
        //_tableView?.separatorInset = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        _tableView?.tableFooterView = UIView()
        _tableView?.tableHeaderView = UIView()
        self.view.addSubview(_tableView!)
        _getData()
        
        _setuped=true
    }
    
    func _getData(){
        switch _type{
        case FocusMeList._Type_FocusMe://---被关注
            Social_Main._getFocusMeList(_uid) { (__array) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self._setArray(__array)
                })
            }
            break
        case FocusMeList._Type_Focus://－－关注
            Social_Main._getMyFocusList(_uid) { (__array) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self._setArray(__array)
                })
            }
            break
        default:
            break
        }
    }
    
    
    func _setArray(__array:NSArray){
        _dataArray = __array
        // print("载入：",_tableView)
        _focusArray = NSMutableArray()
        for var i:Int = 0; i < _dataArray.count ; ++i{
            
            let _dict:NSDictionary = _dataArray.objectAtIndex(i) as! NSDictionary
            _focusArray.addObject(_dict.objectForKey("each") as! Int)
            
        }
        
        if _tableView != nil{
            _tableView?.reloadData()
        }
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //var cell:UITableViewCell = _tableView!.dequeueReusableCellWithIdentifier("table_cell", forIndexPath: indexPath) as! UITableViewCell
        
        let cell:FocusListCell = _tableView!.dequeueReusableCellWithIdentifier("FocusListCell", forIndexPath: indexPath) as! FocusListCell
        //if cell.respondsToSelector("setSeparatorInset:") {
        if indexPath.row == _dataArray.count - 1 {
            cell.separatorInset = UIEdgeInsetsMake(0, -10, 0, 0)
        }else{
            cell.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0)
        }
        
        //}
        //if cell.respondsToSelector("setLayoutMargins:") {
        cell.layoutMargins = UIEdgeInsetsZero
        //}
        //if cell.respondsToSelector("setPreservesSuperviewLayoutMargins:") {
        cell.preservesSuperviewLayoutMargins = false
        //}
        
        cell._index = indexPath.row
        if let _dict = _dataArray.objectAtIndex(indexPath.row) as? NSDictionary{
            print("关注我的：",_dict)
            
            var _user:NSDictionary
            
            if _type == FocusMeList._Type_FocusMe{
              _user  = _dict.objectForKey("me") as! NSDictionary
            }else{
               _user = _dict.objectForKey("follow") as! NSDictionary
            }
            cell._setFocusType(_focusArray.objectAtIndex(indexPath.row) as! Int)
            
            cell._setPic(MainInterface._userAvatar(_user))
            cell._setTitle(_user.objectForKey("nickname") as! String)
            
            
            //---to do list
            
            //cell._setDes(_user.objectForKey("sign") as! String)
            
            if indexPath.row%3 == 1{
                cell._setDes("签名签名我是签名")
            }else{
                cell._setDes("")
            }
            
        }
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _dataArray.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
        //return CGFloat(((_dataArray!.objectAtIndex(indexPath.row) as! NSDictionary).objectForKey("comment") as! String).lengthOfBytesUsingEncoding(NSUnicodeStringEncoding))
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let _dict = _dataArray.objectAtIndex(indexPath.row) as? NSDictionary{
            var _user:NSDictionary
            
            if _type == FocusMeList._Type_FocusMe{
                _user  = _dict.objectForKey("me") as! NSDictionary
            }else{
                _user = _dict.objectForKey("follow") as! NSDictionary
            }
            
            _viewUser(_user.objectForKey("_id") as! String)
        }
        
        //cell.selected = false
        
    }
    
    func _FocusActionAt(__index: Int) {
        
        let _arr:NSMutableArray = NSMutableArray(array: _focusArray)
        
        switch _arr.objectAtIndex(__index) as! Int {
        case 0:
            break
        case 1:
            break
        default:
            break
        }
        _focusArray = _arr
        _tableView?.reloadData()
    }
    func _viewUserAt(__index: Int) {
        if let _dict = _dataArray.objectAtIndex(__index) as? NSDictionary{
            var _user:NSDictionary
            
            if _type == FocusMeList._Type_FocusMe{
                _user  = _dict.objectForKey("me") as! NSDictionary
            }else{
                _user = _dict.objectForKey("follow") as! NSDictionary
            }
            
            _viewUser(_user.objectForKey("_id") as! String)
            
        }
    }
    
    func _viewUser(__userId: String) {
        let _controller:MyHomepage = MyHomepage()
        _controller._userId = __userId
        self.navigationController?.pushViewController(_controller, animated: true)
        
    }
    
    func clickAction(sender:UIButton){
        switch sender{
        case _btn_cancel!:
            if _naviDelegate != nil{
                _naviDelegate?._cancel()
            }
            self.navigationController?.popViewControllerAnimated(true)
        default:
            return
        }
        
    }
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle=UIStatusBarStyle.LightContent
    }
}

