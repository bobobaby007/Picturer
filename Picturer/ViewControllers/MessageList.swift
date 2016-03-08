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
    let _barH:CGFloat = 64
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
    var _heightArray:NSMutableArray? = NSMutableArray()
    
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
        
        
        
        _topBar=UIView(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: _barH))
        _topBar?.backgroundColor=Config._color_black_bar
        
        
        _btn_cancel=UIButton(frame:CGRect(x: 0, y: 20, width: 44, height: 44))
        _btn_cancel?.setImage(UIImage(named: "back_icon.png"), forState: UIControlState.Normal)
        _btn_cancel?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        _title_label=UILabel(frame:CGRect(x: 50, y: 20, width: self.view.frame.width-100, height: _barH-20))
        _title_label?.textColor=UIColor.whiteColor()
        _title_label?.textAlignment=NSTextAlignment.Center
        _title_label?.font = Config._font_topbarTitle
        _title_label?.text="消息"
        
        _topBar?.addSubview(_title_label!)
        
        
        _btn_deleteAll=UIButton(frame:CGRect(x: self.view.frame.width - 60, y: 20, width: 60, height: 44))
        _btn_deleteAll?.setTitle("清空", forState: UIControlState.Normal)
        _btn_deleteAll?.titleLabel?.font = Config._font_topbarTitle
        _btn_deleteAll?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        _topBar?.addSubview(_btn_deleteAll!)
        
        
        
       
        
        _tableView=UITableView()
        _tableView?.delegate=self
        _tableView?.dataSource=self
        _tableView?.registerClass(MessageList_Cell.self, forCellReuseIdentifier: "MessageList_Cell")
        //_tableView?.scrollEnabled=false
        //_tableView?.separatorColor = UIColor.clearColor()
        _tableView?.tableFooterView = UIView()
        _tableView?.tableHeaderView = UIView()
        
        //_tableView?.separatorInset = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        
        self.view.addSubview(_topBar!)
        
        _topBar?.addSubview(_btn_cancel!)
        _topBar?.addSubview(_title_label!)
        
        self.view.addSubview(_tableView!)
        
        _setuped=true
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //var cell:UITableViewCell = _tableView!.dequeueReusableCellWithIdentifier("table_cell", forIndexPath: indexPath) as! UITableViewCell
        
        let cell:MessageList_Cell = _tableView!.dequeueReusableCellWithIdentifier("MessageList_Cell", forIndexPath: indexPath) as! MessageList_Cell
        cell.setUp(self.view.frame.width)
        cell._setDict(_dataArray!.objectAtIndex(_dataArray!.count - 1 - indexPath.row) as! NSDictionary)
        
        
        
        cell.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        cell.preservesSuperviewLayoutMargins = false
        //cell.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
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
       
        
        return _heightArray?.objectAtIndex(_dataArray!.count - 1 - indexPath.row) as! CGFloat
        
        
        //return CGFloat(((_dataArray!.objectAtIndex(indexPath.row) as! NSDictionary).objectForKey("comment") as! String).lengthOfBytesUsingEncoding(NSUnicodeStringEncoding))
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        //var cell:MessageList_Cell = _tableView!.cellForRowAtIndexPath(indexPath) as! MessageList_Cell
       // cell.selected = false
        
    }
    
    func _viewUser(__userId: String) {
        let _controller:MyHomepage = MyHomepage()
        _controller._userId = __userId
        self.navigationController?.pushViewController(_controller, animated: true)
    }
    func _viewAlbum(__albumId: String) {
        
    }
    
    //----设置位置
    func refreshView(){
        _tableView?.frame = CGRect(x: 0, y: _barH, width: self.view.frame.width, height: self.view.frame.height-_barH)
    }
    
    
    func _getDatas(){
        Social_Main._getMessages { (array) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self._dealWidthDatas(array)
            })
            
        }
    }
    func _dealWidthDatas(__array:NSArray){
        self._dataArray = NSMutableArray(array: __array)
        self._heightArray = NSMutableArray()
        for var i:Int = 0 ;i < __array.count; ++i{
            _heightArray?.addObject(MessageList_Cell._getHeihtWidthDict(_dataArray!.objectAtIndex(i) as! NSDictionary,_defaultWidth: self.view.frame.width))
        }
        
        self._tableView?.reloadData()

    }
    func clickAction(sender:UIButton){
        switch sender{
        case _btn_cancel!:
            self.navigationController?.popViewControllerAnimated(true)
        case _btn_deleteAll!:
            _dataArray = []
            _tableView?.reloadData()
        default:
            print(sender)
        }
        
    }
}

