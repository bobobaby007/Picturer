//
//  Manage_new.swift
//  Picturers
//
//  Created by Bob Huang on 15/6/20.
//  Copyright (c) 2015年 4view. All rights reserved.
//

import Foundation
import UIKit



class CommentList: UIViewController, UITableViewDelegate,UITableViewDataSource {
    let _gap:CGFloat=15
    var _setuped:Bool=false
    var _topBar:UIView?
    var _btn_cancel:UIButton?
    var _title_label:UILabel?
    
    var _tableView:UITableView?
    let _tableCellH:CGFloat=40
    var _selectedId:Int=0
    
    
    var _dataArray:NSArray?
    
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
        _inputer?.setup()
        
        _topBar=UIView(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: 62))
        _topBar?.backgroundColor=UIColor.blackColor()
        _btn_cancel=UIButton(frame:CGRect(x: 5, y: 5, width: 40, height: 62))
        _btn_cancel?.setTitle("取消", forState: UIControlState.Normal)
        _btn_cancel?.addTarget(self, action: "clickAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        _title_label=UILabel(frame:CGRect(x: 50, y: 5, width: self.view.frame.width-100, height: 62))
        _title_label?.textColor=UIColor.whiteColor()
        _title_label?.textAlignment=NSTextAlignment.Center
        _title_label?.text="评论"
        
        _tableView=UITableView()
        _tableView?.delegate=self
        _tableView?.dataSource=self
        _tableView?.registerClass(CommentList_Cell.self, forCellReuseIdentifier: "CommentList_Cell")
        _tableView?.scrollEnabled=false
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
        cell._setComment(_dataArray!.objectAtIndex(indexPath.row) as! NSDictionary)
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
        cell._setComment(_dataArray!.objectAtIndex(indexPath.row) as! NSDictionary)
        
        return cell._Height()
        
        
        //return CGFloat(((_dataArray!.objectAtIndex(indexPath.row) as! NSDictionary).objectForKey("comment") as! String).lengthOfBytesUsingEncoding(NSUnicodeStringEncoding))
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        _selectedId=indexPath.row
        _tableView?.reloadData()
    }
    
    //----设置位置
    func refreshView(){
        _tableView?.frame = CGRect(x: 0, y: 62+_gap, width: self.view.frame.width, height: self.view.frame.height-62-_gap-40)
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

