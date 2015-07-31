//
//  Manage_new.swift
//  Picturers
//
//  Created by Bob Huang on 15/6/20.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit



class MessageList: UIViewController, UITableViewDelegate,UITableViewDataSource,MessageList_Cell_delegate {
    let _gap:CGFloat=15
    var _setuped:Bool=false
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    var _btn_deleteAll:UIButton?
    var _title_label:UILabel?
    
    var _tableView:UITableView?
    let _tableCellH:CGFloat=40
    var _selectedId:Int = -1
    
    
    
    var _dataArray:NSMutableArray?=NSMutableArray()
    
    
    override func viewDidLoad() {
        setup()
        refreshView()
        _getDatas()
    }
    
    func setup(){
        if _setuped{
            return
        }
        
        self.view.backgroundColor=UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        
        
        _topBar=UIView(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: 62))
        _topBar?.backgroundColor=UIColor.blackColor()
        _btn_cancel=UIButton(frame:CGRect(x: 6, y: 30, width: 40, height: 22))
        _btn_cancel?.setImage(UIImage(named: "back_icon.png"), forState: UIControlState.Normal)
        _btn_cancel!.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        _btn_cancel?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        _btn_deleteAll=UIButton(frame:CGRect(x: self.view.frame.width - 60, y: 30, width: 60, height: 22))
        _btn_deleteAll?.setTitle("清空", forState: UIControlState.Normal)
        _btn_deleteAll?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        _topBar?.addSubview(_btn_deleteAll!)
        
        
        
        _title_label=UILabel(frame:CGRect(x: 50, y: 5, width: self.view.frame.width-100, height: 62))
        _title_label?.textColor=UIColor.whiteColor()
        _title_label?.textAlignment=NSTextAlignment.Center
        _title_label?.text="消息列表"
        
        _tableView=UITableView()
        _tableView?.delegate=self
        _tableView?.dataSource=self
        _tableView?.registerClass(MessageList_Cell.self, forCellReuseIdentifier: "MessageList_Cell")
        //_tableView?.scrollEnabled=false
        _tableView?.separatorColor = UIColor.clearColor()
        _tableView?.tableFooterView = UIView()
        _tableView?.tableHeaderView = UIView()
        
        self.view.addSubview(_topBar!)
        
        _topBar?.addSubview(_btn_cancel!)
        _topBar?.addSubview(_title_label!)
        
        self.view.addSubview(_tableView!)
        
        _setuped=true
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //var cell:UITableViewCell = _tableView!.dequeueReusableCellWithIdentifier("table_cell", forIndexPath: indexPath) as! UITableViewCell
        
        var cell:MessageList_Cell = _tableView!.dequeueReusableCellWithIdentifier("MessageList_Cell", forIndexPath: indexPath) as! MessageList_Cell
        cell.setUp(self.view.frame.width)
        cell._setComment(_dataArray!.objectAtIndex(_dataArray!.count - 1 - indexPath.row) as! NSDictionary)
        cell._delegate = self
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return _dataArray!.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        // var cell:MessageList_Cell = _tableView!.dequeueReusableCellWithIdentifier("MessageList_Cell", forIndexPath: indexPath) as! MessageList_Cell
        
        
        var cell:MessageList_Cell = _tableView!.dequeueReusableCellWithIdentifier("MessageList_Cell") as! MessageList_Cell
        cell.setUp(self.view.frame.width)
        cell._setComment(_dataArray!.objectAtIndex(_dataArray!.count - 1 - indexPath.row) as! NSDictionary)
        
        return cell._Height()
        
        
        //return CGFloat(((_dataArray!.objectAtIndex(indexPath.row) as! NSDictionary).objectForKey("comment") as! String).lengthOfBytesUsingEncoding(NSUnicodeStringEncoding))
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        var cell:MessageList_Cell = _tableView!.cellForRowAtIndexPath(indexPath) as! MessageList_Cell
       // cell.selected = false
        
    }
    
    func _viewUser(__userId: String) {
        var _controller:MyHomepage = MyHomepage()
        _controller._userId = __userId
        self.navigationController?.pushViewController(_controller, animated: true)
        
    }
    func _viewAlbum(__albumId: String) {
        
    }
    
    //----设置位置
    func refreshView(){
        _tableView?.frame = CGRect(x: 0, y: 62, width: self.view.frame.width, height: self.view.frame.height-62)
    }
    
    
    func _getDatas(){
        MainAction._getMessages { (array) -> Void in
            self._dataArray = NSMutableArray(array: array)
            self._tableView?.reloadData()
        }
    }
    
    func clickAction(sender:UIButton){
        switch sender{
        case _btn_cancel!:
            self.navigationController?.popViewControllerAnimated(true)
        case _btn_deleteAll!:
            _dataArray = []
            _tableView?.reloadData()
        default:
            println(sender)
        }
        
    }
}

