//
//  Manage_new.swift
//  Picturers
//
//  Created by Bob Huang on 15/6/20.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit



class CommentList: UIViewController, UITableViewDelegate,UITableViewDataSource,Inputer_delegate,CommentList_Cell_delegate{
    let _barH:CGFloat = 64
    let _gap:CGFloat=15
    var _setuped:Bool=false
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    var _title_label:UILabel?
    
    var _tableView:UITableView?
    let _tableCellH:CGFloat=40
    var _selectedId:Int = -1
    
    
    
    var _dataArray:NSMutableArray?
    
    var _inputer:Inputer?
    
    
    override func viewDidLoad() {
        setup()
        refreshView()
    }
    func setup(){
        if _setuped{
            return
        }
       
        self.view.backgroundColor=UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        
        _inputer = Inputer(frame: self.view.frame)
        _inputer?._delegate=self
        _inputer!._placeHold = "添加评论..."
        _inputer?.setup()
        
        
        _topBar=UIView(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: _barH))
        _topBar?.backgroundColor=UIColor.blackColor()
        
        
        _btn_cancel=UIButton(frame:CGRect(x: 0, y: 20, width: 44, height: 44))
        _btn_cancel?.setImage(UIImage(named: "back_icon.png"), forState: UIControlState.Normal)
        _btn_cancel?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        _title_label=UILabel(frame:CGRect(x: 50, y: 20, width: self.view.frame.width-100, height: _barH-20))
        _title_label?.textColor=UIColor.whiteColor()
        _title_label?.textAlignment=NSTextAlignment.Center
        _title_label?.font = UIFont.boldSystemFontOfSize(17)
        _title_label?.text="评论"
        
        _tableView=UITableView()
        _tableView?.delegate=self
        _tableView?.dataSource=self
        _tableView?.registerClass(CommentList_Cell.self, forCellReuseIdentifier: "CommentList_Cell")
        //_tableView?.scrollEnabled=false
        _tableView?.separatorColor = UIColor.clearColor()
        _tableView?.tableFooterView = UIView()
        _tableView?.tableHeaderView = UIView()
        
        self.view.addSubview(_topBar!)
        
        _topBar?.addSubview(_btn_cancel!)
        _topBar?.addSubview(_title_label!)
        
        self.view.addSubview(_tableView!)
        self.view.addSubview(_inputer!)
        
        _setuped=true
    }
    
   
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //var cell:UITableViewCell = _tableView!.dequeueReusableCellWithIdentifier("table_cell", forIndexPath: indexPath) as! UITableViewCell
        
        var cell:CommentList_Cell = _tableView!.dequeueReusableCellWithIdentifier("CommentList_Cell", forIndexPath: indexPath) as! CommentList_Cell
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
        
       // var cell:CommentList_Cell = _tableView!.dequeueReusableCellWithIdentifier("CommentList_Cell", forIndexPath: indexPath) as! CommentList_Cell
        
        
        var cell:CommentList_Cell = _tableView!.dequeueReusableCellWithIdentifier("CommentList_Cell") as! CommentList_Cell
        cell.setUp(self.view.frame.width)
        cell._setComment(_dataArray!.objectAtIndex(_dataArray!.count - 1 - indexPath.row) as! NSDictionary)
        
        return cell._Height()
        
        
        //return CGFloat(((_dataArray!.objectAtIndex(indexPath.row) as! NSDictionary).objectForKey("comment") as! String).lengthOfBytesUsingEncoding(NSUnicodeStringEncoding))
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        
        var cell:CommentList_Cell = _tableView!.cellForRowAtIndexPath(indexPath) as! CommentList_Cell
        cell.selected = false
        
        //_tableView?.reloadData()
        let _dict:NSDictionary = _dataArray!.objectAtIndex(_dataArray!.count - 1 - indexPath.row) as! NSDictionary
        let _userId:String = _dict.objectForKey("from_userName") as! String
        if _userId != MainAction._currentUser.objectForKey("userId") as! String{
             _selectedId=indexPath.row
            _inputer!._placeHold = "回复"+(_dict.objectForKey("from_userName") as! String)
        }else{
            _selectedId = -1
            _inputer!._placeHold = "添加评论..."
        }
    }
    //----cell 代理
    
    func _viewUser(__userId: String) {
        var _controller:MyHomepage = MyHomepage()
        _controller._userId = __userId
        self.navigationController?.pushViewController(_controller, animated: true)
        
    }
    //----输入框代理
    
    func _inputer_changed(__dict: NSDictionary) {
        
    }
    
    func _inputer_closed() {
        
    }
    func _inputer_opened() {
        
    }
    func _inputer_send(__dict: NSDictionary) {
        
        var _to_userName:String = ""
        var _to_userId:String = ""
        
        if _selectedId >= 0{
            var _dict:NSMutableDictionary
            _dict = NSMutableDictionary(dictionary: _dataArray!.objectAtIndex(_dataArray!.count - 1 - _selectedId) as! NSDictionary)
            _to_userName = (_dict.objectForKey("from_userName") as? String)!
            _to_userId = (_dict.objectForKey("from_userId") as? String)!
        }else{
            
        }
       
        
        var _d:NSDictionary = NSDictionary(objects: [MainAction._currentUser.objectForKey("userName") as! String,_to_userName,MainAction._currentUser.objectForKey("userId") as! String,_to_userId,__dict.objectForKey("text") as! String,MainAction._currentUser.objectForKey("profileImg") as! NSDictionary], forKeys: ["from_userName","to_userName","from_userId","to_userId","comment","userImg"])
        
        
        
        _dataArray?.addObject(_d)
        
        _tableView?.reloadData()
    }
    //----设置位置
    func refreshView(){
        _tableView?.frame = CGRect(x: 0, y: _barH, width: self.view.frame.width, height: self.view.frame.height-_barH-40)
    }
    
    func clickAction(sender:UIButton){
        switch sender{
        case _btn_cancel!:
            self.navigationController?.popViewControllerAnimated(true)
        default:
            println(sender)
        }
        
    }
}

