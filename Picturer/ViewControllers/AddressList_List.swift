//
//  AddressList_List.swift
//  Picturer
//
//  Created by Bob Huang on 16/2/11.
//  Copyright © 2016年 4view. All rights reserved.
//

import Foundation

class AddressList_List:UIViewController, UITableViewDelegate,UITableViewDataSource{
    let _barH:CGFloat = 64
    let _gap:CGFloat=15
    var _setuped:Bool=false
    
    var _tableView:UITableView?
    let _tableCellH:CGFloat=40
    
    var _dataArray:NSArray = []
    
    static let _Type_Friends:String = "friends"
    static let _Type_Focus:String = "focus"
    
    var _type:String = "friends"
    
    override func viewDidLoad() {
        setup()
    }
    func setup(){
        if _setuped{
            return
        }
        
        
        self.view.backgroundColor = UIColor.clearColor()
        self.automaticallyAdjustsScrollViewInsets = false
        
        _tableView=UITableView(frame: CGRect(x: 0,y: 0,width: self.view.frame.width,height: self.view.frame.height))
        _tableView?.delegate=self
        _tableView?.dataSource=self
        _tableView?.backgroundColor = UIColor.clearColor()
        _tableView?.registerClass(UserListCell.self, forCellReuseIdentifier: "UserListCell")
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
        case AddressList_List._Type_Friends:
            Social_Main._getFriendsList(Social_Main._userId) { (__array) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self._setArray(__array)
                })
            }
            break
        case AddressList_List._Type_Focus:
            Social_Main._getMyFocusList(Social_Main._userId) { (__array) -> Void in
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
        if _tableView != nil{
            _tableView?.reloadData()
        }
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //var cell:UITableViewCell = _tableView!.dequeueReusableCellWithIdentifier("table_cell", forIndexPath: indexPath) as! UITableViewCell
        var cell:UserListCell
        if let _cell = _tableView?.cellForRowAtIndexPath(indexPath) as? UserListCell{
            cell = _cell
        }else{
            cell = _tableView!.dequeueReusableCellWithIdentifier("UserListCell", forIndexPath: indexPath) as! UserListCell
        }
        
        //let cell:UserListCell = _tableView!.dequeueReusableCellWithIdentifier("UserListCell", forIndexPath: indexPath) as! UserListCell
        //if cell.respondsToSelector("setSeparatorInset:") {
            cell.separatorInset = UIEdgeInsetsZero
        //}
        //if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsetsZero
        //}
        //if cell.respondsToSelector("setPreservesSuperviewLayoutMargins:") {
            cell.preservesSuperviewLayoutMargins = false
        //}
        
        if let _dict = _dataArray.objectAtIndex(indexPath.row) as? NSDictionary{
            let _user:NSDictionary = _dict.objectForKey("follow") as! NSDictionary
            
            cell._setPic(MainInterface._userAvatar(_user))
            cell._setTitle(_user.objectForKey("nickname") as! String)
            cell._setDes("xiaobai_0434")
            
            
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
        return 60
        //return CGFloat(((_dataArray!.objectAtIndex(indexPath.row) as! NSDictionary).objectForKey("comment") as! String).lengthOfBytesUsingEncoding(NSUnicodeStringEncoding))
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let _dict = _dataArray.objectAtIndex(indexPath.row) as? NSDictionary{
            let _user:NSDictionary = _dict.objectForKey("follow") as! NSDictionary
            _viewUser(_user.objectForKey("_id") as! String)
        }
        let cell:UserListCell = _tableView?.cellForRowAtIndexPath(indexPath) as! UserListCell
        cell.selected = false
        
    }
    func _viewUser(__userId: String) {
        let _controller:MyHomepage = MyHomepage()
        _controller._userId = __userId
        self.navigationController?.pushViewController(_controller, animated: true)
        
    }
}
